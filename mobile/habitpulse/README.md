# HabitPulse Mobile

Flutter application for HabitPulse. It connects to the FastAPI backend to manage habits and visualise completion statistics.

## Getting started

```bash
flutter pub get
flutter run
```

Set the backend URL at compile time if needed:

```bash
flutter run --dart-define=HABITPULSE_API_BASE_URL=http://10.0.2.2:8000
```
