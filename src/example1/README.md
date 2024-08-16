# Translation REST Service

This is a simple REST service that provides translation functionality using the deepseek_chat model.

## Setup

1. Install the required dependencies:

```bash
pip install fastapi uvicorn byzerllm
```

2. Make sure you have the deepseek_chat model set up and available.

## Running the Service

To run the service, navigate to the `src/example1` directory and run:

```bash
python main.py
```

The service will start on `http://0.0.0.0:8000`.

## API Usage

The service exposes a single endpoint:

### POST /translate

Request body:

```json
{
    "text": "Hello, world!",
    "target_language": "French"
}
```

Response:

```json
{
    "translated_text": "Bonjour, le monde!"
}
```

## Example

Using curl:

```bash
curl -X POST "http://localhost:8000/translate" \
     -H "Content-Type: application/json" \
     -d '{"text": "Hello, world!", "target_language": "French"}'
```

This should return the translated text in French.

## Note

This service uses the deepseek_chat model for translation. The quality of the translation may vary depending on the model's capabilities and the complexity of the input text.