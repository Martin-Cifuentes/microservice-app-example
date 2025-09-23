// todos-api/todoController.js
'use strict';

const cache = require('memory-cache');

const OPERATION_CREATE = 'CREATE';
const OPERATION_DELETE = 'DELETE';

const keyForUser = (username) => `todos:${username}`;
const log = (...a) => console.log(new Date().toISOString(), ...a);

module.exports = function ({ tracer, redisClient, logChannel, cacheTtl }) {
  // --------- helpers (tu “DB” en memoria) ----------
  function _getTodoData(userID) {
    let data = cache.get(userID);
    if (!data) {
      data = {
        items: {
          '1': { id: 1, content: 'Create new todo' },
          '2': { id: 2, content: 'Update me' },
          '3': { id: 3, content: 'Delete example ones' }
        },
        lastInsertedID: 3
      };
      _setTodoData(userID, data);
    }
    return data;
  }

  function _setTodoData(userID, data) {
    cache.put(userID, data);
  }

  function _logOperation(opName, username, todoId) {
    tracer.scoped(() => {
      const traceId = tracer.id;
      try {
        redisClient.publish(
          logChannel,
          JSON.stringify({ zipkinSpan: traceId, opName, username, todoId })
        );
      } catch (_) {}
    });
  }

  // ----------------- handlers ----------------------
  // GET /todos  -> cache-aside
  function list(req, res) {
    const username = (req.user && req.user.username) || 'unknown';
    const rkey = keyForUser(username);

    redisClient.get(rkey, (err, cached) => {
      if (!err && cached) {
        log('[cache-hit]', rkey);
        try {
          return res.json(JSON.parse(cached)); // devolvemos el mapa { id: {..}, ... }
        } catch (_) {
          // si falla el parseo, seguimos a MISS
        }
      }

      log('[cache-miss]', rkey);
      const data = _getTodoData(username);
      const payload = data.items;

      try {
        redisClient.setex(rkey, cacheTtl, JSON.stringify(payload));
      } catch (_) {}

      return res.json(payload);
    });
  }

  // POST /todos  -> muta y EVICT
  function create(req, res) {
    const username = (req.user && req.user.username) || 'unknown';
    const rkey = keyForUser(username);

    const data = _getTodoData(username);
    const id = (data.lastInsertedID || 0) + 1;
    const todo = { id, content: (req.body && req.body.content) || '' };

    data.items[id] = todo;
    data.lastInsertedID = id;
    _setTodoData(username, data);

    _logOperation(OPERATION_CREATE, username, id);

    try {
      redisClient.del(rkey, () => log('[cache-evict]', rkey));
    } catch (_) {}

    return res.status(201).json(todo);
  }

  // DELETE /todos/:taskId  -> muta y EVICT
  function remove(req, res) {
    const username = (req.user && req.user.username) || 'unknown';
    const rkey = keyForUser(username);
    const id = String(req.params.taskId);

    const data = _getTodoData(username);
    const existed = !!data.items[id];
    delete data.items[id];
    _setTodoData(username, data);

    _logOperation(OPERATION_DELETE, username, id);

    try {
      redisClient.del(rkey, () => log('[cache-evict]', rkey));
    } catch (_) {}

    if (!existed) return res.status(404).json({ message: 'not found' });
    return res.status(204).send();
  }

  return { list, create, remove };
};
