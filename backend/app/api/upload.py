from fastapi import APIRouter, UploadFile, File
from app.services.validators import validate_file_extension
from app.services.file_parser import parse_file
from datetime import datetime
import os
import json

# subir archivos, guardar cosas, validar formatos
router = APIRouter()

@router.post("/upload_catalog") # endpoint --> recibe archivo y lo guarda en backend/uploads
async def upload_catalog(file: UploadFile = File(...), marca: str ="testMarca" , sucursal: str = "testSucursal"):
    
    validate_file_extension(file) # 1 - valida archivo/extensión
    
    raw_dir = f"uploads/raw/{marca}Raw/{sucursal}Raw"
    processed_dir = f"uploads/processed/{marca}/{sucursal}"

    os.makedirs(raw_dir, exist_ok=True)
    os.makedirs(processed_dir, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S") # timestamp para versionado anti pisado

    filename_base, ext = os.path.splitext(file.filename)
    raw_filename = f"{filename_base}_{timestamp}.{ext}"
    json_filename = f"{filename_base}_{timestamp}.json" # crea el nombre dela rchivo json

    raw_path = os.path.join(raw_dir, raw_filename)

    with open(raw_path, "wb") as f: # manejo de archivos
        f.write(await file.read()) # await => lo que espera. La variable content espera el archivo.read() Solo válido en el cuerpo de un Async

    parsed_data = parse_file(raw_path # parsea desde disco (no desde uploadfile)
                             )
    processed_path = os.path.join(processed_dir, json_filename) # guarda json procesado

    with open(processed_path, "w", encoding="utf-8") as f:
        json.dump(parsed_data, f, ensure_ascii=False, indent=2)

    return {
        "status":"ok",
        "marca":marca,
        "sucursal": sucursal,
        "rawfile": raw_path,
        "processed_file": processed_path,
        "rows": len(parsed_data)
        } # devuelve el json simple 

'''
# endpoints a agregar: 
- POST /upload-banners
- POST /upload-images

reciben archivos -> validan -> guardan
'''
