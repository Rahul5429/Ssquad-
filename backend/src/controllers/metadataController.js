const ApiResponse = require('../utils/apiResponse');
const asyncHandler = require('../utils/asyncHandler');
const EventType = require('../models/EventType');
const Country = require('../models/Country');
const Cuisine = require('../models/Cuisine');
const ResponseOption = require('../models/ResponseOption');
const { TravelPurpose, AccommodationType, TravelAmenity } = require('../models/TravelMetadata');
const { RetailStoreType, RetailProductCategory } = require('../models/RetailMetadata');

exports.getEventTypes = asyncHandler(async (req, res) => {
  const eventTypes = await EventType.find().sort({ name: 1 });
  return res.json(new ApiResponse(eventTypes));
});

exports.getCountries = asyncHandler(async (req, res) => {
  const countries = await Country.find().sort({ name: 1 });
  return res.json(new ApiResponse(countries));
});

exports.getCuisines = asyncHandler(async (req, res) => {
  const cuisines = await Cuisine.find().sort({ name: 1 });
  return res.json(new ApiResponse(cuisines));
});

exports.getResponseOptions = asyncHandler(async (req, res) => {
  const options = await ResponseOption.find().sort({ hours: 1 });
  return res.json(new ApiResponse(options));
});

exports.getTravelMetadata = asyncHandler(async (req, res) => {
  const [purposes, accommodations, amenities] = await Promise.all([
    TravelPurpose.find().sort({ name: 1 }),
    AccommodationType.find().sort({ name: 1 }),
    TravelAmenity.find().sort({ name: 1 }),
  ]);

  return res.json(
    new ApiResponse({
      purposes,
      accommodationTypes: accommodations,
      amenities,
    })
  );
});

exports.getRetailMetadata = asyncHandler(async (req, res) => {
  const [storeTypes, categories] = await Promise.all([
    RetailStoreType.find().sort({ name: 1 }),
    RetailProductCategory.find().sort({ name: 1 }),
  ]);

  return res.json(
    new ApiResponse({
      storeTypes,
      productCategories: categories,
    })
  );
});

