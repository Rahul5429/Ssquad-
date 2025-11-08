const mongoose = require('mongoose');

const travelPurposeSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, unique: true },
    description: { type: String, default: '' },
  },
  { timestamps: true }
);

const accommodationTypeSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, unique: true },
    description: { type: String, default: '' },
  },
  { timestamps: true }
);

const amenitySchema = new mongoose.Schema(
  {
    name: { type: String, required: true, unique: true },
  },
  { timestamps: true }
);

const TravelPurpose = mongoose.model('TravelPurpose', travelPurposeSchema);
const AccommodationType = mongoose.model('AccommodationType', accommodationTypeSchema);
const TravelAmenity = mongoose.model('TravelAmenity', amenitySchema);

module.exports = {
  TravelPurpose,
  AccommodationType,
  TravelAmenity,
};

