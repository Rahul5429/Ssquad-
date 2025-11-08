const ApiResponse = require('../utils/apiResponse');
const asyncHandler = require('../utils/asyncHandler');
const Category = require('../models/Category');

exports.getCategories = asyncHandler(async (req, res) => {
  const categories = await Category.find().sort({ order: 1, createdAt: 1 });
  return res.json(new ApiResponse(categories));
});

exports.getCategoryBySlug = asyncHandler(async (req, res) => {
  const { slug } = req.params;
  const category = await Category.findOne({ slug });
  if (!category) {
    return res.status(404).json({
      success: false,
      message: 'Category not found',
    });
  }

  return res.json(new ApiResponse(category));
});

