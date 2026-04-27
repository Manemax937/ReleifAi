ReleifAI: Mobile App + Dashboard Integration

- Flutter mobile app sends SOS requests to Firestore (sos_requests)
- Includes authenticated user details (name, email, uid, role)
- Captures GPS coordinates (latitude, longitude)
- Supports optional incident types (Flood, Fire, etc.)

Dashboard system:
- Backend (Django) imports Firestore SOS data into Incident model
- Frontend displays incidents in Active Requests dashboard

Firebase setup:
- Authentication (Email/Password) enabled
- Firestore rules configured and deployed
- Android and iOS configs added

Notes:
- Location permissions handled (Android + iOS)
- App still works without location (coordinates optional)