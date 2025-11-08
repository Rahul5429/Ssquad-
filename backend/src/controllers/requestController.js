const ApiError = require('../utils/apiError');
const ApiResponse = require('../utils/apiResponse');
const asyncHandler = require('../utils/asyncHandler');
const EventType = require('../models/EventType');
const Cuisine = require('../models/Cuisine');
const ResponseOption = require('../models/ResponseOption');
const BanquetRequest = require('../models/BanquetRequest');
const { TravelPurpose, AccommodationType, TravelAmenity } = require('../models/TravelMetadata');
const TravelRequest = require('../models/TravelRequest');
const { RetailStoreType, RetailProductCategory } = require('../models/RetailMetadata');
const RetailRequest = require('../models/RetailRequest');

exports.createBanquetRequest = asyncHandler(async (req, res) => {
  const {
    eventTypeId,
    country,
    state,
    city,
    eventDates,
    adults,
    children,
    cateringPreferences,
    cuisineIds,
    budget,
    responseOptionId,
    additionalNotes,
  } = req.body;

  const [eventType, responseOption, cuisines] = await Promise.all([
    EventType.findById(eventTypeId),
    ResponseOption.findById(responseOptionId),
    Cuisine.find({ _id: { $in: cuisineIds } }),
  ]);

  if (!eventType) {
    throw new ApiError(400, 'Invalid event type');
  }
  if (!responseOption) {
    throw new ApiError(400, 'Invalid response option');
  }
  if (cuisines.length !== cuisineIds.length) {
    throw new ApiError(400, 'One or more cuisines are invalid');
  }

  const banquetRequest = await BanquetRequest.create({
    user: req.user.id,
    eventType: eventTypeId,
    country,
    state,
    city,
    eventDates,
    guests: {
      adults,
      children,
    },
    cateringPreferences: cateringPreferences || [],
    cuisines: cuisines.map((c) => c._id),
    budget,
    responseOption: responseOptionId,
    additionalNotes: additionalNotes || '',
  });

  await banquetRequest.populate(['eventType', 'cuisines', 'responseOption']);

  return res
    .status(201)
    .json(new ApiResponse(banquetRequest, 'Request submitted'));
});

exports.createTravelRequest = asyncHandler(async (req, res) => {
  const {
    destinationCountry,
    destinationCity,
    checkIn,
    checkOut,
    adults,
    children,
    roomsNeeded,
    purposeId,
    accommodationTypeId,
    amenityIds,
    budget,
    additionalNotes,
  } = req.body;

  const [purpose, accommodationType, amenities] = await Promise.all([
    TravelPurpose.findById(purposeId),
    AccommodationType.findById(accommodationTypeId),
    TravelAmenity.find({ _id: { $in: amenityIds || [] } }),
  ]);

  if (!purpose) {
    throw new ApiError(400, 'Invalid travel purpose');
  }
  if (!accommodationType) {
    throw new ApiError(400, 'Invalid accommodation type');
  }
  if ((amenityIds || []).length !== amenities.length) {
    throw new ApiError(400, 'One or more amenities are invalid');
  }

  const travelRequest = await TravelRequest.create({
    user: req.user.id,
    destinationCountry,
    destinationCity,
    stayTimeline: { checkIn, checkOut },
    guests: { adults, children },
    roomsNeeded,
    purpose: purposeId,
    accommodationType: accommodationTypeId,
    amenities: amenities.map((a) => a._id),
    budget,
    additionalNotes: additionalNotes || '',
  });

  await travelRequest.populate(['purpose', 'accommodationType', 'amenities']);

  return res
    .status(201)
    .json(new ApiResponse(travelRequest, 'Travel request submitted'));
});

exports.createRetailRequest = asyncHandler(async (req, res) => {
  const {
    preferredCountry,
    preferredCity,
    storeTypeId,
    productCategoryIds,
    floorArea,
    openingTimeline,
    requiresInventorySupport,
    budget,
    additionalNotes,
  } = req.body;

  const [storeType, productCategories] = await Promise.all([
    RetailStoreType.findById(storeTypeId),
    RetailProductCategory.find({ _id: { $in: productCategoryIds } }),
  ]);

  if (!storeType) {
    throw new ApiError(400, 'Invalid store type');
  }
  if (productCategories.length !== productCategoryIds.length) {
    throw new ApiError(400, 'One or more product categories are invalid');
  }

  const retailRequest = await RetailRequest.create({
    user: req.user.id,
    preferredCountry,
    preferredCity,
    storeType: storeTypeId,
    productCategories: productCategories.map((c) => c._id),
    floorArea,
    openingTimeline,
    requiresInventorySupport: !!requiresInventorySupport,
    budget,
    additionalNotes: additionalNotes || '',
  });

  await retailRequest.populate(['storeType', 'productCategories']);

  return res
    .status(201)
    .json(new ApiResponse(retailRequest, 'Retail request submitted'));
});

exports.getMyRequests = asyncHandler(async (req, res) => {
  const [banquets, travels, retails] = await Promise.all([
    BanquetRequest.find({ user: req.user.id })
      .sort({ createdAt: -1 })
      .populate('eventType')
      .populate('cuisines')
      .populate('responseOption')
      .lean(),
    TravelRequest.find({ user: req.user.id })
      .sort({ createdAt: -1 })
      .populate('purpose')
      .populate('accommodationType')
      .populate('amenities')
      .lean(),
    RetailRequest.find({ user: req.user.id })
      .sort({ createdAt: -1 })
      .populate('storeType')
      .populate('productCategories')
      .lean(),
  ]);

  const hydrated = [
    ...banquets.map((request) => ({ type: 'banquet', request })),
    ...travels.map((request) => ({ type: 'travel', request })),
    ...retails.map((request) => ({ type: 'retail', request })),
  ].sort((a, b) => new Date(b.request.createdAt) - new Date(a.request.createdAt));

  return res.json(new ApiResponse(hydrated));
});

