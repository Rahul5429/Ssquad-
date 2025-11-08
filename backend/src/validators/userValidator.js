const Joi = require('joi');

const updateProfileSchema = Joi.object({
  name: Joi.string().min(2).max(80),
  phone: Joi.string().allow('', null),
});

module.exports = {
  updateProfileSchema,
};

