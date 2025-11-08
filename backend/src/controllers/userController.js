const ApiResponse = require('../utils/apiResponse');
const asyncHandler = require('../utils/asyncHandler');

exports.updateProfile = asyncHandler(async (req, res) => {
  const { name, phone } = req.body;

  if (name !== undefined) {
    req.user.name = name;
  }
  if (phone !== undefined) {
    req.user.phone = phone;
  }

  await req.user.save();
  return res.json(new ApiResponse(req.user, 'Profile updated'));
});

