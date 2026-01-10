'''
recibe archivo -> detecta si es válido (CSV/XLSX/JSON) -> 
-> convierte en estructura uniforme (list[dict])

es lógica (por eso va en la carpeta 'services')
'''
from typing import List, Dict, Any
import os
import json
import pandas as pd
from fastapi import UploadFile


def normalize_row_keys(row: dict) -> dict:
    return {
        str(k).strip().lower(): v
        for k, v in row.items()
    }

def parse_csv(path: str) -> List[Dict[str, Any]]:
    df = pd.read_csv(path, sep=None, engine="python")
    rows = df.to_dict(orient="records")
    return [normalize_row_keys(row) for row in rows]
    
def parse_xlsx(path: str) -> List[Dict[str, Any]]:
    df = pd.read_excel(path)
    rows = df.to_dict(orient="records")
    return [normalize_row_keys(row) for row in rows]

def parse_json(path: str) -> List[Dict[str, Any]]:
    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)

    if isinstance(data, list): # lista directa
        return data

    if isinstance(data, dict): # lista adentro
        for value in data.values():
            if isinstance(value, list):
                return value

    raise ValueError("No se encontró una lista válida en el JSON")

# func que los endpoints van a llamar
def parse_file (path: str) -> List[Dict[str, Any]]:
    _, extension = os.path.splitext(path)
    extension = extension.lower()

    if extension == ".csv":
        return parse_csv(path)
    elif extension in [".xls", ".xlsx"]:
        return parse_xlsx(path)
    elif extension == ".json":
        return parse_json(path)
    else:
        raise ValueError("Formato no soportado.")
    


# testing
'''
asumimos que el archivo pasó la validación y probamos qué pasa al parsear'''