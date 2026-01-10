# estado del sistema
from fastapi import APIRouter

router = APIRouter()

@router.get("/health")
def health_check():
    return {
        "status": "OK",
        "version": "1.0.0",
        "env": "production"
    }