const mongoose = require('mongoose');

const citySchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
  },
  { _id: false }
);

const stateSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    cities: { type: [citySchema], default: [] },
  },
  { _id: false }
);

const countrySchema = new mongoose.Schema(
  {
    name: { type: String, required: true, unique: true },
    code: { type: String, required: true, unique: true },
    states: { type: [stateSchema], default: [] },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Country', countrySchema);

