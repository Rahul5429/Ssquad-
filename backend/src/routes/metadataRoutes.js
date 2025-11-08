const express = require('express');
const metadataController = require('../controllers/metadataController');

const router = express.Router();

router.get('/event-types', metadataController.getEventTypes);
router.get('/countries', metadataController.getCountries);
router.get('/cuisines', metadataController.getCuisines);
router.get('/response-options', metadataController.getResponseOptions);
router.get('/travel', metadataController.getTravelMetadata);
router.get('/retail', metadataController.getRetailMetadata);

module.exports = router;

