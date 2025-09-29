// todos-api/todoController.js
'use strict';

const cache = require('memory-cache');
const CircuitBreaker = require('opossum');
const { promisify } = require('util');

const OPERATION_CREATE = 'CREATE';
const OPERATION_DELETE = 'DELETE';

const keyForUser = (username) => `todos:${username}`;
const log = (...a) => console.log(new Date().toISOString(), ...a);

module.exports = function ({ tracer, redisClient, logChannel, cacheTtl }) {
  // --------- “Fuente de verdad” en memoria (igual que tenías) ----------
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
  function _setTodoData(userID, data) { cache.put(userID, data); }

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

  // --------- Promesas para Redis (redis@2.x callbacks) ----------
  const getAsync = promisify(redisClient.get).bind(redisClient);
  const delAsync = promisify(redisClient.del).bind(redisClient);
  const setexAsync = (k, s, v) =>
    new Promise((resolve, reject) =>
      redisClient.setex(k, s, v, (err, ok) => (err ? reject(err) : resolve(ok)))
    );

  // --------- Circuit Breakers ----------
  const cbOpts = {
    timeout: parseInt(process.env.REDIS_CB_TIMEOUT_MS || '300', 10),           // ms por intento
    errorThresholdPercentage: parseInt(process.env.REDIS_CB_ERROR_PCT || '50', 10), // % error para abrir
    resetTimeout: parseInt(process.env.REDIS_CB_RESET_MS || '10000', 10)       // ms para half-open
  };

  const getCB   = new CircuitBreaker(getAsync, cbOpts);
  const setexCB = new CircuitBreaker(setexAsync, cbOpts);
  const delCB   = new CircuitBreaker(delAsync, cbOpts);

  // Logs de estado del breaker (demo/observabilidad)
  ;[['get', getCB], ['setex', setexCB], ['del', delCB]].forEach(([name, cb]) => {
    cb.on('open',     () => log(`[cb-open] redis ${name}`));
    cb.on('halfOpen', () => log(`[cb-half-open] redis ${name}`));
    cb.on('close',    () => log(`[cb-close] redis ${name}`));
    cb.on('timeout',  () => log(`[cb-timeout] redis ${name}`));
    cb.on('reject',   () => log(`[cb-reject] redis ${name}`));
    cb.on('failure', (e) => log(`[cb-fail] redis ${name}:`, e && e.message));
  });

  // ----------------- handlers ----------------------
  // GET /todos  -> cache-aside con breaker (fallback a memoria)
  async function list(req, res) {
    const username = (req.user && req.user.username) || 'unknown';
    const rkey = keyForUser(username);

    try {
      const cached = await getCB.fire(rkey);
      if (cached) {
        log('[cache-hit]', rkey);
        try { return res.json(JSON.parse(cached)); }
        catch (_) { /* si falla parseo, seguimos a MISS */ }
      }
      log('[cache-miss]', rkey);
    } catch (e) {
      log('[cb-fallback] get -> serving from memory', rkey);
    }

    const data = _getTodoData(username);
    const payload = data.items;

    try {
      await setexCB.fire(rkey, cacheTtl, JSON.stringify(payload));
    } catch (_) {
      // no bloquear respuesta por fallo de caché
    }

    return res.json(payload);
  }

  // POST /todos  -> muta y EVICT con breaker (no bloquea si falla)
  async function create(req, res) {
    const username = (req.user && req.user.username) || 'unknown';
    const rkey = keyForUser(username);

    const data = _getTodoData(username);
    const id = (data.lastInsertedID || 0) + 1;
    const todo = { id, content: (req.body && req.body.content) || '' };

    data.items[id] = todo;
    data.lastInsertedID = id;
    _setTodoData(username, data);

    _logOperation(OPERATION_CREATE, username, id);

    try { await delCB.fire(rkey); log('[cache-evict]', rkey); }
    catch (_) { log('[cb-fallback] del -> skip evict', rkey); }

    return res.status(201).json(todo);
  }

  // DELETE /todos/:taskId  -> muta y EVICT con breaker
  async function remove(req, res) {
    const username = (req.user && req.user.username) || 'unknown';
    const rkey = keyForUser(username);
    const id = String(req.params.taskId);

    const data = _getTodoData(username);
    const existed = !!data.items[id];
    delete data.items[id];
    _setTodoData(username, data);

    _logOperation(OPERATION_DELETE, username, id);

    try { await delCB.fire(rkey); log('[cache-evict]', rkey); }
    catch (_) { log('[cb-fallback] del -> skip evict', rkey); }

    if (!existed) return res.status(404).json({ message: 'not found' });
    return res.status(204).send();
  }

  return { list, create, remove };
};
