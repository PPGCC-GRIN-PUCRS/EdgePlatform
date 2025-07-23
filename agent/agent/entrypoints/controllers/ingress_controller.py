# agent/controllers/ingress_controller.py

from agent.actions.ingress import ingress
from fastapi import APIRouter, Request # type: ignore
from pydantic import BaseModel # type: ignore
from typing import Optional
# import logging


# logger = logging.getLogger("agent.rest")
router = APIRouter()

class IngressData(BaseModel):
    connections: Optional[dict] = None

@router.post("/ingress")
async def ingress_endpoint(request: Request, body: Optional[IngressData] = None):
    # If no body was sent, body will be None
    data = body.model_dump() if body else None  # Use model_dump() instead of dict()

    return ingress(data)