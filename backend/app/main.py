from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .db import Base, engine
from .metrics import register_metrics
from .routers import habits

Base.metadata.create_all(bind=engine)

app = FastAPI(title="HabitPulse API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

register_metrics(app)


@app.get("/health", tags=["health"])
async def health_check():
    return {"status": "ok"}


app.include_router(habits.router)
