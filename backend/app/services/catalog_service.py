from typing import List, Dict
import os
import json


NAME_KEYS = ["name", "producto", "prenda", "nombre", "item"]
PRICE_KEYS = ["price", "precio", "importe", "costo", "valor"]
STOCK_KEYS = ["stock", "cantidad", "cant", "qty"]
SIZE_KEYS = ["size", "talle", "talla", "talles", "tallas"]
COLOR_KEYS = ["color", "colour"]

COLUMN_MAP = {
    "name": ["name","nombre", "producto", "prenda", "artículo", "article", "item", "descripción", "descripcion", "desc", "detalle"],
    "size": ["talle", "talla", "size", "talles", "tallas"],
    "price": ["precio", "price", "importe", "valor"],
    "color": ["color", "colour"],
    "stock": ["stock", "cantidad", "qty"],
    "imagen": ["imagen", "foto", "img"],
    "sku" : ["id_prenda", "codigo_barra", "código", "id", "sku_prenda", "sku", "code","código_barra", "identification"]
} # dict de normalizacion de col

SIZE_MAP = {
    "xs": "XS",
    "s" : "S",
    "small": "S",
    "m":"M",
    "medium": "M",
    "l":"L",
    "large":"L",
    "xl": "XL",
    "extra large":"XL"
}

######## HELPERS ##########

def pick_value(row: dict, possible_keys: list):
    for key in possible_keys:
        if key in row and row[key] not in (None, ""):
            return row[key]
    return None

def clean_string(value): # normalizar strings
    if not value:
        return None
    return str(value).strip().title()

def normalize_price(value): # normalizar precios
    try:
        return int(float(value))
    except (ValueError, TypeError):
        return None

def normalize_stock(value): # normalizar stock
    try:
        return int(value)
    except (ValueError, TypeError):
        return 0

def normalize_sizes(value): # normalizar talles
    if not value:
        return []
    
    raw = str(value).lower()
    parts = raw.replace("/", ",").split(",")

    sizes = []
    for part in parts:
        key = part.strip()
        if key in SIZE_MAP:
            sizes.append(SIZE_MAP[key])
        else:
            sizes.append(key.upper())

    return list(set(sizes))
  
def normalize_row_keys(row: dict) -> dict:
    return {
        str(k).strip().lower(): v
        for k, v in row.items()
    }

def normalize_images(value):
    if not value:
        return []
    return [v.strip() for v in str(value).split(",") if v.strip()]

def normalize_sku(value):
    if value is None:
        return None
    return str(value).strip()

def normalize_catalog(rows: List[dict]) -> list[dict]:
    # normaliza todas las filas del catalogo
    normalized = []

    for row in rows:

        product = {
            "name": clean_string(row.get("name")),
            "price": normalize_price(row.get("price")),
            "stock": normalize_stock(row.get("stock")),
            "sizes": normalize_sizes(row.get("size")),
            "imagen": clean_string(row.get("imagen")),
            "sku": clean_string(row.get("sku")),
            "colors": [clean_string(row.get("color"))] 
                    if row.get("color") else [],
            "tags": []
    }

        if not product["name"]:
            normalized.append(product)
    
    print("ROW NORMALIZADA:", row)

    return normalized


def get_value(row, possible_keys):
    for key in possible_keys:
        if key in row and row[key] not in (None, ""):
            return row[key]
    return None


####### VALIDACIONES POR PROD ######

def is_valid_product(product:Dict) -> bool:
    if not product.get("name"):
        return False
    
    return True


'''
dado un archivo ya parseado + normalizado + validado 
queremos guardar un archivo final consumible en flutter en:
    uploads/processed/{marca}/{sucursal}/catalogo.json
'''

BASE_PROCESSED_DIR = "uploads/processed"
# normaliza nombres y crea carpetas si no existen 
def ensure_catalog_dir(brand: str, branch: str) -> str:
    brand = brand.lower().strip()
    branch = branch.lower().strip()

    path = os.path.join(BASE_PROCESSED_DIR, brand, branch)
    os.makedirs(path, exist_ok=True)

    return path

def save_catalog_json(products: List[Dict], brand: str, branch: str) -> str:
    folder = ensure_catalog_dir(brand, branch)
    file_path = os.path.join(folder, "catalogo.json")

    with open(file_path, "w", encoding="utf-8") as f:
        json.dump(products, f, ensure_ascii=False, indent=2)
                            # tildes bien^          ^que sea legible
    return file_path

'''
FLUJO
archivoSubido -> file_parser.py -> normalize_catalog() -> save_catalog_json()
'''



