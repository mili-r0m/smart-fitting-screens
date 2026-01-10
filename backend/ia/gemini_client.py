import google.generativeai as genai
import os 


# cuando migemos a otra IA, solo se modifica este archivo

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

def llamar_gemini(prompt: str) -> str:
    model = genai.GenerativeModel("gemini-1.5-flash")
    response = model.generate_content(prompt)

    return response.text