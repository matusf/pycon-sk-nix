from flask import Flask

app = Flask(__name__)


@app.get("/")
def index():
    return "Hello PyCon SK"


def main():
    app.run(host="0.0.0.0")
