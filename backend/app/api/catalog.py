# leer el catálogo, devolver productos, filtrar prendas
# endpoint de catalogo

from fastapi import APIRouter, HTTPException
import os
import json

router = APIRouter()

UPLOADS_DIR = "uploads/processed"

@router.get("/catalog/{brand_id}") #endpoint: func que responde a una url y hace algo
def get_catalog(brand_id: str):
    catalog_path = os.path.join(
        UPLOADS_DIR,
        brand_id,
        "catalogo.json"
    )

    if not os.path.exists(catalog_path): # existe el catálogo?
        raise HTTPException(
            status_code= 404,
            detail = "Catálogo de marca no encontrado."
        )
    
    with open(catalog_path, "r", encoding="utf-8") as f: # lee el archivo
        catalog_data = json.load(f)

    return {
        "brand" : brand_id,
        "items" : catalog_data
    }