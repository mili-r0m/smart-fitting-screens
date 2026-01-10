import json 
from ia.gemini_client import llamar_gemini
from ia.prompts import PROMPT_PREGUNTAS

RUTA_SALIDA = "data/preguntas.json"

def main():
    respuesta = llamar_gemini(PROMPT_PREGUNTAS)

    respuesta = respuesta.strip()
    if respuesta.startswith("```"):
        respuesta = respuesta.split("```")[1]

    preguntas = json.loads(respuesta)

    with open(RUTA_SALIDA, "w", encoding="utf-8") as f:
        json.dump(preguntas, f, ensure_ascii=False, indent=2)

    print("Preguntas generadas. Todo OK")

if __name__ == "__main__":
    main()