const mongoose = require('mongoose');

const budgetSchema = new mongoose.Schema(
  {
    amount: { type: Number, required: true },
    currency: { type: String, default: 'INR' },
  },
  { _id: false }
);

const retailRequestSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    preferredCountry: { type: String, required: true },
    preferredCity: { type: String, required: true },
    storeType: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'RetailStoreType',
      required: true,
    },
    productCategories: [
      { type: mongoose.Schema.Types.ObjectId, ref: 'RetailProductCategory', required: true },
    ],
    floorArea: { type: Number, required: true },
    openingTimeline: { type: String, required: true },
    budget: { type: budgetSchema, required: true },
    requiresInventorySupport: { type: Boolean, default: false },
    additionalNotes: { type: String, default: '' },
    status: {
      type: String,
      enum: ['pending', 'in_progress', 'completed'],
      default: 'pending',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('RetailRequest', retailRequestSchema);

