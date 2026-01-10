from fastapi import FastAPI, Request
from fastapi.responses import RedirectResponse, HTMLResponse
from fastapi.templating import Jinja2Templates

# routers
from app.api.upload import router as upload_router
from app.api.catalog import router as catalog_router
from app.api.health import router as health_router
from app.core.config import IS_DEV

templates = Jinja2Templates(directory="app/templates")

app = FastAPI(
    docs_url="/docs" if IS_DEV else None,
    redoc_url="/redoc" if IS_DEV else None,
    openapi_url="/openapi.json" if IS_DEV else None,
)  # crea el backend


@app.get("/", response_class=HTMLResponse)
def root (request: Request):
    if IS_DEV:
        return RedirectResponse("/docs")
    
    return templates.TemplateResponse("index.html", {"request":request})

# routers NO TOCAR
app.include_router(upload_router)
app.include_router(catalog_router)
app.include_router(health_router)