const jwt = require('jsonwebtoken');
const { jwtSecret, jwtExpiresIn } = require('../config/env');

const generateAccessToken = (payload, options = {}) =>
  jwt.sign(payload, jwtSecret, { expiresIn: jwtExpiresIn, ...options });

const verifyToken = (token) => jwt.verify(token, jwtSecret);

module.exports = {
  generateAccessToken,
  verifyToken,
};

