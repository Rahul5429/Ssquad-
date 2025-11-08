require('./config/env');
const http = require('http');
const app = require('./app');
const { port } = require('./config/env');
const { connectDatabase } = require('./config/database');
const runSeeders = require('./seed/seedData');

const startServer = async () => {
  await connectDatabase();
  await runSeeders();

  const server = http.createServer(app);
  server.listen(port, () => {
    console.log(`[server] listening on port ${port}`);
  });
};

startServer().catch((error) => {
  console.error('[server] failed to start', error);
  process.exit(1);
});

