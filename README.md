# Cargo Objects – Flutter (Mobile & Web)

A cross-platform Flutter app implementing Firebase Google Authentication and CRUD operations on a REST API with **GetX** for state management, navigation, and dependency injection.

---

## 🚀 Features
- Firebase Google Login (Mobile + Web)
- CRUD operations with [restful-api.dev](https://restful-api.dev/)  
  - List, Detail, Create, Update (PUT), Delete
- Optimistic UI updates with error handling
- Responsive Material UI
- Firebase Hosting Deployment (Web) + APK Build (Android)

---

## 📂 Project Structure
```
lib/
 ├── models/          # Data models
 ├── controllers/     # GetX controllers
 ├── views/           # UI screens
 ├── services/        # API service class
 ├── utils/           # Helpers
 └── main.dart
```

---

## ⚙️ Setup & Installation

```bash
git clone https://github.com/rupesh88899/Cargo_Objects.git
cd Cargo_Objects
flutter pub get
flutter run
```

### Firebase Setup
- Enable Google Sign-In in Firebase Console.
- Add `google-services.json` in `android/app/`.
- Configure `firebase_options.dart` for Web.

---

## 📦 Deployment
- **Web:** [Firebase Hosting URL]()  
- **Android APK:** [Download Link]()  

---

## 📹 Walkthrough
- 5–10 min demo video (link here)

---

## 🛠️ Tech Stack
- Flutter (Mobile & Web)  
- Dart  
- Firebase Authentication  
- GetX (State, Navigation, DI)  
- REST API – [restful-api.dev](https://restful-api.dev/)  

---

## 📌 Future Improvements
- PATCH support  
- Search & Filter  
- Advanced error logging  
- Alternative state management (Riverpod/BLoC)  

---

## 📝License
MIT license 