const bcrypt = require('bcrypt');
const ApiError = require('../utils/apiError');
const ApiResponse = require('../utils/apiResponse');
const asyncHandler = require('../utils/asyncHandler');
const { generateAccessToken } = require('../utils/token');
const User = require('../models/User');

const SALT_ROUNDS = 10;

exports.register = asyncHandler(async (req, res) => {
  const { email, password, name, phone } = req.body;

  const existing = await User.findOne({ email });
  if (existing) {
    throw new ApiError(409, 'Email already registered');
  }

  const passwordHash = await bcrypt.hash(password, SALT_ROUNDS);
  const user = await User.create({ email, passwordHash, name, phone });
  const token = generateAccessToken({ sub: user.id, role: user.role });

  return res.status(201).json(
    new ApiResponse({
      token,
      user,
    })
  );
});

exports.login = asyncHandler(async (req, res) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email });
  if (!user) {
    throw new ApiError(401, 'Invalid email or password');
  }

  const match = await user.comparePassword(password);
  if (!match) {
    throw new ApiError(401, 'Invalid email or password');
  }

  const token = generateAccessToken({ sub: user.id, role: user.role });
  return res.json(
    new ApiResponse({
      token,
      user,
    })
  );
});

exports.me = asyncHandler(async (req, res) => {
  return res.json(new ApiResponse(req.user));
});

