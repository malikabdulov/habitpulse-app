# HabitPulse

HabitPulse is a full-stack habit tracking platform composed of a FastAPI backend, Flutter mobile client, PostgreSQL database, and observability with Prometheus and Grafana.

## Project structure

```
habitpulse-app/
├── backend/            # FastAPI application
├── mobile/             # Flutter mobile client
├── prometheus/         # Prometheus configuration
├── grafana/            # Grafana dashboard
├── docker-compose.yml  # Local infrastructure definition
└── .env.example        # Sample environment configuration
```

## Prerequisites

- Docker and Docker Compose
- Flutter SDK (for running the mobile client)

## Getting started

1. Copy environment variables and adjust if necessary:
   ```bash
   cp .env.example .env
   ```

2. Start the infrastructure:
   ```bash
   docker compose up -d
   ```

3. Run database migrations:
   ```bash
   docker exec -it habitpulse-app-backend alembic upgrade head
   ```

4. Access the services:
   - API docs: http://localhost:8000/docs
   - Prometheus: http://localhost:9090
   - Grafana: http://localhost:3000 (admin/admin)

5. Launch the Flutter app:
   ```bash
   cd mobile/habitpulse
   flutter pub get
   flutter run --dart-define=HABITPULSE_API_BASE_URL=http://10.0.2.2:8000
   ```

## Testing

- Backend tests:
  ```bash
  cd backend
  pytest
  ```

- Flutter widget tests:
  ```bash
  cd mobile/habitpulse
  flutter test
  ```

## Monitoring

Prometheus scrapes metrics from the backend at `/metrics`. Grafana ships with a dashboard (imported from `grafana/dashboard.json`) displaying request rate, latency percentiles, error counts, and the total number of tracked habits.

## Development notes

- Alembic migrations are stored in `backend/alembic/versions`.
- The backend automatically creates tables on start for convenience in local development, but migrations should be used to evolve the schema.
- Update the Docker images or dependencies as needed before deploying to production.
