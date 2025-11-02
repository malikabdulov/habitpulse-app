from prometheus_client import Gauge
from prometheus_fastapi_instrumentator import Instrumentator

habit_total_gauge = Gauge("habitpulse_habits_total", "Total number of habits tracked by HabitPulse")

instrumentator = Instrumentator(
    should_respect_env_var=True,
    excluded_handlers={"/health"},
)


def register_metrics(app):
    instrumentator.instrument(app).expose(app, include_in_schema=False)
