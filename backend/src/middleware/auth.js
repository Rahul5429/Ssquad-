const ApiError = require('../utils/apiError');
const { verifyToken } = require('../utils/token');
const User = require('../models/User');

const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization || '';
    const token = authHeader.startsWith('Bearer ')
      ? authHeader.substring(7)
      : null;

    if (!token) {
      throw new ApiError(401, 'Authorization token missing');
    }

    const decoded = verifyToken(token);
    const user = await User.findById(decoded.sub);

    if (!user) {
      throw new ApiError(401, 'Invalid token');
    }

    req.user = user;
    next();
  } catch (error) {
    if (error.name === 'JsonWebTokenError' || error.name === 'TokenExpiredError') {
      return next(new ApiError(401, 'Invalid or expired token'));
    }
    return next(error);
  }
};

module.exports = authMiddleware;

