const mongoose = require('mongoose');

const responseOptionSchema = new mongoose.Schema(
  {
    label: { type: String, required: true, unique: true },
    description: { type: String, default: '' },
    hours: { type: Number, required: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model('ResponseOption', responseOptionSchema);

