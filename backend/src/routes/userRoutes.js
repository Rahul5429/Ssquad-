const express = require('express');
const userController = require('../controllers/userController');
const validate = require('../middleware/validate');
const { updateProfileSchema } = require('../validators/userValidator');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.use(authMiddleware);
router.patch('/me', validate(updateProfileSchema), userController.updateProfile);

module.exports = router;

