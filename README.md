# Project Setup Guide 

Follow these steps to get both the Node.js backend and the Flutter frontend running locally.

## Prerequisites

- **Node.js** v18+ and npm
- **MongoDB** running locally (default URI: `mongodb://127.0.0.1:27017/banquets_app`) or you can use    mongodb atlas
- **Flutter SDK** (stable channel) with Dart 3.x
- **Android Studio** / **Xcode** (optional) for device emulators
- **Git** (optional, for version control)

---

## Backend Setup (Node.js + Express + MongoDB)

1. Open a terminal and navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   - make a .env file in backend repo and 
     ```bash
     in .env set following env variables
     ```
   - Update values if needed:
     ```env
     PORT=4000
     MONGO_URI=mongodb://127.0.0.1:27017/banquets_app
     JWT_SECRET=change-me-please
     JWT_EXPIRES_IN=7d
     ```

4. Start MongoDB locally (skip if already running). Or use atlas link.

5. Seed data runs automatically when the server starts. Launch the backend:
   ```bash
   npm run dev
   ```

6. Set the backend base API URL in frontend/lib/core/app_config.dart .
   The API will be available at `http://localhost:4000/api`.
   If frontend doesn't fetch backend the use your IP insted of localhost.
   Also I hosted backend on render so if you find any difficulty to setup backend then you can directly use this link in frontend for API: https://banquet-8k4a.onrender.com/api

---

## Frontend Setup (Flutter)

1. In a new terminal, navigate to the Flutter project:
   ```bash
   cd frontend
   ```

2. Fetch dependencies:
   ```bash
   flutter pub get
   ```

3. (Optional) Clean previous builds if assets were updated:
   ```bash
   flutter clean
   flutter pub get
   ```

4. Run the app on your desired device/emulator:
   ```bash
   flutter run 
   ```
---

## Authentication & Routing Notes

- The app enforces authentication. Upon launch, unauthenticated users see the login screen.
- Logging in stores JWT tokens securely; logging out clears tokens and returns you to the login view.
- Protected routes (home, forms, history) are only accessible after authentication.

---

## Seed Data Overview

- Categories, event types, cuisines, travel metadata, and retail metadata are seeded automatically on backend start.
- Countries include 5 regions each with 5 states and 5 cities where available.

---

## Useful Scripts

### Backend
- `npm run dev` – Start server with nodemon
- `npm start` – Start server without watch mode

### Frontend
- `flutter run` – Launch app
- `flutter analyze` – Static analysis for Dart code
- `flutter test` – Run unit/widget tests

---

## Troubleshooting

- **Assets not displaying**: Ensure `flutter pub get` ran after adding assets, and file names match the mappings in code.
- **API not reachable**: Confirm backend is running and `API_BASE_URL` matches the device/emulator routing.
- **Authentication issues**: Clear secure storage (uninstall the app or reset via emulator) and log in again.

---

You’re ready to go! Enjoy building and testing the Banquet & Venue marketplace application.



Author - Rahul Kumar
