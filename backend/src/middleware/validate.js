const ApiError = require('../utils/apiError');

const validate =
  (schema, property = 'body') =>
  (req, res, next) => {
    const { error, value } = schema.validate(req[property], {
      abortEarly: false,
      stripUnknown: true,
    });

    if (error) {
      return next(
        new ApiError(400, 'Validation failed', error.details.map((d) => d.message))
      );
    }

    req[property] = value;
    return next();
  };

module.exports = validate;

