# Translation REST Service

This is a simple translation REST service built with FastAPI. It uses the `prompt` function from the `llm_friendly` package to perform translations.

## Setup

1. Install the required packages:
   ```
   pip install -r requirements.txt
   ```

2. Run the server:
   ```
   python main.py
   ```

The server will start on `http://0.0.0.0:8000`.

## Usage

Send a POST request to the `/translate` endpoint with a JSON payload containing the text to translate and the target language.

Example using curl:

```
curl -X POST "http://localhost:8000/translate" \
     -H "Content-Type: application/json" \
     -d '{"text": "Hello, world!", "target_language": "French"}'
```

The response will be a JSON object containing the translated text.

## API Documentation

Once the server is running, you can access the automatic API documentation at `http://localhost:8000/docs`.