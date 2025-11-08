const mongoose = require('mongoose');
const { mongoUri } = require('./env');

mongoose.set('strictQuery', true);

const connectDatabase = async () => {
  try {
    await mongoose.connect(mongoUri, {
      serverSelectionTimeoutMS: 5000,
    });
    console.log('[database] connected');
  } catch (error) {
    console.error('[database] connection error', error);
    process.exit(1);
  }
};

module.exports = {
  connectDatabase,
};

