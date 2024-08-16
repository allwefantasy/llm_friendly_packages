from fastapi import FastAPI
from pydantic import BaseModel
from llm_friendly import prompt

app = FastAPI()

class TranslationRequest(BaseModel):
    text: str
    target_language: str

@app.post("/translate")
async def translate(request: TranslationRequest):
    translated_text = prompt(f"""
    Translate the following text to {request.target_language}:
    {request.text}
    
    Translated text:
    """)
    
    return {"translated_text": translated_text}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)