import json 
from ia.gemini_client import llamar_gemini
from ia.prompts import PROMPT_CATALOGO

RUTA_ENTRADA = "backend/uploads/processed/catalogo.json"
RUTA_SALIDA = "backend/data/catalogo_recomendaciones.json"

def main():
    with open(RUTA_ENTRADA, "r", encoding="utf-8") as f:
        catalogo_raw = json.load(f)

    prompt = PROMPT_CATALOGO + json.dumps(catalogo_raw, ensure_ascii=False, indent=2)

    respuesta = llamar_gemini(prompt)

    #limpieza mínima por si IA devuelve ```json
    respuesta = respuesta.strip()
    if respuesta.startswith("```"):
        respuesta = respuesta.split("```")[1]

    catalogo_recomendaciones = json.loads(respuesta)

    with open (RUTA_SALIDA, "w", encoding="utf-8") as f:
        json.dump(catalogo_recomendaciones, f, ensure_ascii=False, indent=2)

    print("Catálogo de recomendaciones generado. Todo OK")
    

if __name__ == "__main__":
    main()