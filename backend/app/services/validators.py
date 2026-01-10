from fastapi import HTTPException, UploadFile
import os
# procesa el archivo

VALID_EXTENSIONS = {".csv", ".xlsx", ".json"}

def validate_file_extension(file: UploadFile):
    _, extension = os.path.splitext(file.filename)
    extension = extension.lower()

    if extension not in VALID_EXTENSIONS:
        raise HTTPException(
            status_code = 400,
            detail = "Formato de archivo no permitido. Por favor, ingrese el formato correcto."
        )