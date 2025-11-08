const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const routes = require('./routes');
const errorHandler = require('./middleware/errorHandler');

const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(morgan('dev'));

app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'API is healthy',
  });
});

app.use('/api', routes);

app.use((req, res, next) => {
  res.status(404).json({
    success: false,
    message: 'Resource not found',
  });
});

app.use(errorHandler);

module.exports = app;

