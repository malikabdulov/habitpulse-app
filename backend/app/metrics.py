from prometheus_client import Gauge
from prometheus_fastapi_instrumentator import Instrumentator

habit_total_gauge = Gauge(
    "habitpulse_habits_total",
    "Total number of habits tracked by HabitPulse",
)

_instrumentator = Instrumentator(
    should_instrument_requests_inprogress=True,
    excluded_handlers=["/health", "/metrics"],
)
_metrics_registered = False


def register_metrics(app):
    @app.on_event("startup")
    async def _startup_metrics():
        global _metrics_registered
        if not _metrics_registered:
            _instrumentator.instrument(app).expose(app, include_in_schema=False)
            _metrics_registered = True

        # Set the gauge to 0 on startup. Update this gauge elsewhere in the codebase
        # whenever the number of habits changes to reflect real data.
        habit_total_gauge.set(0)
