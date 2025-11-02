from datetime import datetime
from types import SimpleNamespace

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_create_and_list_habits(monkeypatch):
    class FakeSession:
        def __init__(self):
            self.storage = []

        def query(self, model):
            if hasattr(model, 'id'):
                data = self.storage

                class Query:
                    def __init__(self, data):
                        self.data = data

                    def order_by(self, *_):
                        return self

                    def all(self):
                        return self.data

                return Query(data)

            return SimpleNamespace(scalar=lambda: len(self.storage))

        def add(self, habit):
            habit.id = len(self.storage) + 1
            habit.created_at = datetime.utcnow()
            self.storage.append(habit)

        def commit(self):
            pass

        def refresh(self, habit):
            return habit

        def close(self):
            pass

    fake_db = FakeSession()

    def fake_get_db():
        yield fake_db

    monkeypatch.setattr("app.routers.habits.get_db", fake_get_db)
    monkeypatch.setattr("app.routers.habits.habit_total_gauge", SimpleNamespace(set=lambda *_: None))

    response = client.post(
        "/habits",
        json={"name": "Read", "description": "Read 20 pages", "completed_today": False},
    )
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Read"

    response = client.get("/habits")
    assert response.status_code == 200
    assert len(response.json()) == 1
