const mongoose = require('mongoose');

const retailStoreTypeSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, unique: true },
    description: { type: String, default: '' },
  },
  { timestamps: true }
);

const retailProductCategorySchema = new mongoose.Schema(
  {
    name: { type: String, required: true, unique: true },
  },
  { timestamps: true }
);

const RetailStoreType = mongoose.model('RetailStoreType', retailStoreTypeSchema);
const RetailProductCategory = mongoose.model('RetailProductCategory', retailProductCategorySchema);

module.exports = {
  RetailStoreType,
  RetailProductCategory,
};

