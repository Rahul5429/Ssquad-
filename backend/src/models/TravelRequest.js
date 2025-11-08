const mongoose = require('mongoose');

const guestSchema = new mongoose.Schema(
  {
    adults: { type: Number, default: 1 },
    children: { type: Number, default: 0 },
  },
  { _id: false }
);

const timelineSchema = new mongoose.Schema(
  {
    checkIn: { type: Date, required: true },
    checkOut: { type: Date, required: true },
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

const travelRequestSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    destinationCountry: { type: String, required: true },
    destinationCity: { type: String, required: true },
    stayTimeline: { type: timelineSchema, required: true },
    guests: { type: guestSchema, required: true },
    roomsNeeded: { type: Number, required: true },
    purpose: { type: mongoose.Schema.Types.ObjectId, ref: 'TravelPurpose', required: true },
    accommodationType: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'AccommodationType',
      required: true,
    },
    amenities: [{ type: mongoose.Schema.Types.ObjectId, ref: 'TravelAmenity' }],
    budget: { type: budgetSchema, required: true },
    additionalNotes: { type: String, default: '' },
    status: {
      type: String,
      enum: ['pending', 'in_progress', 'completed'],
      default: 'pending',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('TravelRequest', travelRequestSchema);

