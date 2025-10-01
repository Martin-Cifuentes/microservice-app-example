'use strict';

const makeController = require('./todoController');

module.exports = function (app, { tracer, redisClient, logChannel }) {
  const cacheTtl = parseInt(process.env.TODOS_CACHE_TTL || '60', 10);
  const controller = makeController({ tracer, redisClient, logChannel, cacheTtl });

  app.get('/todos', controller.list);
  app.post('/todos', controller.create);
  app.delete('/todos/:taskId', controller.remove);
};
