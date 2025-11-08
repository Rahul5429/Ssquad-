const Joi = require('joi');

const createTravelRequestSchema = Joi.object({
  destinationCountry: Joi.string().required(),
  destinationCity: Joi.string().required(),
  checkIn: Joi.date().iso().required(),
  checkOut: Joi.date().iso().greater(Joi.ref('checkIn')).required(),
  adults: Joi.number().integer().min(1).required(),
  children: Joi.number().integer().min(0).default(0),
  roomsNeeded: Joi.number().integer().min(1).required(),
  purposeId: Joi.string().required(),
  accommodationTypeId: Joi.string().required(),
  amenityIds: Joi.array().items(Joi.string()).default([]),
  budget: Joi.object({
    amount: Joi.number().positive().required(),
    currency: Joi.string().length(3).uppercase().default('INR'),
  }).required(),
  additionalNotes: Joi.string().allow('', null),
});

module.exports = {
  createTravelRequestSchema,
};

