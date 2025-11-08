const express = require('express');
const requestController = require('../controllers/requestController');
const validate = require('../middleware/validate');
const authMiddleware = require('../middleware/auth');
const { createBanquetRequestSchema } = require('../validators/banquetValidator');
const { createTravelRequestSchema } = require('../validators/travelValidator');
const { createRetailRequestSchema } = require('../validators/retailValidator');

const router = express.Router();

router.use(authMiddleware);
router.get('/', requestController.getMyRequests);
router.post('/banquets', validate(createBanquetRequestSchema), requestController.createBanquetRequest);
router.post('/travel', validate(createTravelRequestSchema), requestController.createTravelRequest);
router.post('/retail', validate(createRetailRequestSchema), requestController.createRetailRequest);

module.exports = router;

