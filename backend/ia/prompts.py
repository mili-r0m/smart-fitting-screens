PROMPT_CATALOGO = """
Sos un asistente que genera datos estructurados para un sistema de recomendaciones de indumentaria.
A partir del siguiente catálogo de productos en formato JSON, generá una versión optimizada para recomendaciones.

Para cada producto:
- mantené id, nombre y categoría
- agregá a la clave "tags", una lista de strings
- los tags deben presentar: estación, estilo, ocasión de uso y contexto.
- usá entre 4 y 8 tags por producto
- no inventes datos que no se desprenden del texto

Devolvé únicamente un JSON válido con esta estructura:

{
    "version":"1.0",
    "productos": [...]
}

Catálogo de entrada: ...

"""


PROMPT_PREGUNTAS = """
Sos un asistente que diseña preguntas para un sistema de recomendaciones de indumentaria en pantallas interactivas.
Generá un conjunto de preguntas claras, simples y no invasivas para ayudar a recomendar productos.

Reglas:
- entre 2 y 4 preguntas
- cada pregunta debe tener opciones cerradas
- cada opción debe mapearse a uno o más tags
- los tags deben coincidir con los usados en el catálogo
- las preguntas deben ser genéricas (no por producto)

Devolvé únicamente un JSON válido con la sigueinte estructura:

{
    "contexto": "recomendacion_indumentaria",
    "verison": "1.0",
    "preguntas" : [ ... ]
}

"""