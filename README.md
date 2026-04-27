HEAD
# ReleifAi

# ReleifAI Mobile App

This Flutter app sends SOS requests to Firestore (`sos_requests`) with:

- authenticated user identity (`name`, `email`, `uid`, `role`)
- GPS coordinates (`latitude`, `longitude`) from device location services
- optional incident type selected by the user (Flood/Fire/etc.)

The dashboard pipeline is:

1. Mobile app writes SOS to Firestore
2. Dashboard backend imports Firestore docs into Django `Incident`
3. Dashboard frontend renders those incidents in Active Requests

## Firebase setup (mobile app)

1. Ensure Firebase project is configured (`lib/firebase_options.dart` already exists).
2. Ensure Android app config exists: `android/app/google-services.json`.
3. Ensure iOS plist is configured in `ios/Runner` if building iOS.
4. Enable **Authentication → Email/Password** in Firebase Console.
5. Deploy Firestore rules from workspace root:

	- `firebase deploy --only firestore:rules --project releifai`

## Location permissions

Already configured in code:

- Android: `android.permission.ACCESS_COARSE_LOCATION`, `android.permission.ACCESS_FINE_LOCATION`
- iOS: `NSLocationWhenInUseUsageDescription`

User can still send SOS if location is unavailable; coordinates are included when permission/service is available.

## Run mobile app

1. `flutter pub get`
2. `flutter run`

Use a **full restart** after dependency/plugin changes (not only hot reload).
8f9f140 (Backend Work done)
