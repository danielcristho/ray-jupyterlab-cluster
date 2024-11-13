import asyncio
import logging
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from transformers import AutoModelForCausalLM, AutoTokenizer, TextIteratorStreamer
from ray import serve
import ray

ray.init("ray://127.0.0.1:10001", ignore_reinit_error=True)

serve.start()

# Set up logging
logger = logging.getLogger("ray.serve")

# Initialize FastAPI app
app = FastAPI()

@serve.deployment
@serve.ingress(app)
class Chatbot:
    def __init__(self, model_id: str):
        self.loop = asyncio.get_running_loop()
        self.model_id = model_id
        self.model = AutoModelForCausalLM.from_pretrained(self.model_id)
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_id)

    @app.websocket("/chat")
    async def chat(self, websocket: WebSocket):
        await websocket.accept()
        try:
            while True:
                data = await websocket.receive_text()
                logger.info(f"Received message: {data}")
                response = await self.generate_response(data)
                await websocket.send_text(response)
        except WebSocketDisconnect:
            logger.info("Client disconnected")

    async def generate_response(self, prompt: str) -> str:
        inputs = self.tokenizer(prompt, return_tensors="pt")
        streamer = TextIteratorStreamer(self.tokenizer)

        # Generate response in a background thread
        await self.loop.run_in_executor(None, self.model.generate, **inputs, streamer=streamer)

        # Collect generated tokens
        response = ""
        for token in streamer:
            response += token

        return response

# Bind and run the deployment
chatbot_app = Chatbot.bind("microsoft/DialoGPT-small")  # Replace with your model ID
serve.run(chatbot_app)