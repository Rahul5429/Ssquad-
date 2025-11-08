const Joi = require('joi');

const createRetailRequestSchema = Joi.object({
  preferredCountry: Joi.string().required(),
  preferredCity: Joi.string().required(),
  storeTypeId: Joi.string().required(),
  productCategoryIds: Joi.array().items(Joi.string()).min(1).required(),
  floorArea: Joi.number().positive().required(),
  openingTimeline: Joi.string().required(),
  requiresInventorySupport: Joi.boolean().default(false),
  budget: Joi.object({
    amount: Joi.number().positive().required(),
    currency: Joi.string().length(3).uppercase().default('INR'),
  }).required(),
  additionalNotes: Joi.string().allow('', null),
});

module.exports = {
  createRetailRequestSchema,
};

