const mongoose = require('mongoose');

const guestSchema = new mongoose.Schema(
  {
    adults: { type: Number, default: 0 },
    children: { type: Number, default: 0 },
  },
  { _id: false }
);

const budgetSchema = new mongoose.Schema(
  {
    amount: { type: Number, required: true },
    currency: { type: String, default: 'INR' },
  },
  { _id: false }
);

const banquetRequestSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    eventType: { type: mongoose.Schema.Types.ObjectId, ref: 'EventType', required: true },
    country: { type: String, required: true },
    state: { type: String, required: true },
    city: { type: String, required: true },
    eventDates: { type: [Date], required: true },
    guests: { type: guestSchema, default: () => ({}) },
    cateringPreferences: { type: [String], default: [] },
    cuisines: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Cuisine' }],
    budget: { type: budgetSchema, required: true },
    responseOption: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'ResponseOption',
      required: true,
    },
    additionalNotes: { type: String, default: '' },
    status: {
      type: String,
      enum: ['pending', 'in_progress', 'completed'],
      default: 'pending',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('BanquetRequest', banquetRequestSchema);

