from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class TranslationRequest(BaseModel):
    text: str
    target_language: str

def prompt(text, target_language):
    # Placeholder for the actual translation logic
    return f"Translated text to {target_language}: {text}"

@app.post("/translate/")
def translate(request: TranslationRequest):
    translated_text = prompt(request.text, request.target_language)
    return {"translated_text": translated_text}