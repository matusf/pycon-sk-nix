from app import app


def test_index():
    r = app.test_client().get("/")
    assert b"PyCon" in r.data
