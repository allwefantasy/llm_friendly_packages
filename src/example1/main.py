from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import byzerllm

app = FastAPI()
llm = byzerllm.ByzerLLM.from_default_model("deepseek_chat")

class TranslationRequest(BaseModel):
    text: str
    target_language: str

@byzerllm.prompt()
def translate(text: str, target_language: str) -> str:
    """
    请将以下文本翻译成{{ target_language }}：

    {{ text }}

    只需要返回翻译后的文本，不要添加任何解释或额外的信息。
    """

@app.post("/translate")
async def translate_text(request: TranslationRequest):
    try:
        translated_text = translate.with_llm(llm).run(text=request.text, target_language=request.target_language)
        return {"translated_text": translated_text}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)