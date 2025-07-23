# agent/rest.py

from agent.entrypoints.controllers.ingress_controller import router as ingress_router
from agent.utils import load_config
from fastapi import FastAPI # type: ignore
import uvicorn # type: ignore
import os

def run_server():
    config = load_config()
    app = FastAPI()

    # Include all controllers
    app.include_router(ingress_router)

    port = int(os.getenv("AGENT_PORT", config["server"].get("port", 8000)))
    host = os.getenv("AGENT_HOST", config["server"].get("host", "0.0.0.0"))
    logl = os.getenv("AGENT_LOGL", config["logging"].get("level", "ERROR"))

    print(f"🚀 Starting REST API at http://{host}:{port}")
    uvicorn.run(
        app,
        host=host,
        port=port,
        log_level=logl
    )