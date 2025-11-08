const express = require('express');
const authRoutes = require('./authRoutes');
const categoryRoutes = require('./categoryRoutes');
const metadataRoutes = require('./metadataRoutes');
const userRoutes = require('./userRoutes');
const requestRoutes = require('./requestRoutes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/categories', categoryRoutes);
router.use('/metadata', metadataRoutes);
router.use('/users', userRoutes);
router.use('/requests', requestRoutes);

module.exports = router;

