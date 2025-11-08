const Joi = require('joi');

const createBanquetRequestSchema = Joi.object({
  eventTypeId: Joi.string().required(),
  country: Joi.string().required(),
  state: Joi.string().required(),
  city: Joi.string().required(),
  eventDates: Joi.array().items(Joi.date().iso()).min(1).required(),
  adults: Joi.number().integer().min(0).required(),
  children: Joi.number().integer().min(0).default(0),
  cateringPreferences: Joi.array()
    .items(Joi.string().valid('Veg', 'Non-veg'))
    .unique(),
  cuisineIds: Joi.array().items(Joi.string()).min(1).required(),
  budget: Joi.object({
    amount: Joi.number().positive().required(),
    currency: Joi.string().length(3).uppercase().default('INR'),
  }).required(),
  responseOptionId: Joi.string().required(),
  additionalNotes: Joi.string().allow('', null),
});

module.exports = {
  createBanquetRequestSchema,
};

