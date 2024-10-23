import json
from typing import Dict

import torch
from starlette.requests import Request

import ray
from ray import serve
from ray.serve.drivers import DAGDriver

from sentence_transformers import SentenceTransformer


# Asynchronous function to resolve incoming JSON requests
async def json_resolver(request: Request) -> dict:
    """
    Resolve incoming JSON requests asynchronously.

    Args:
        request: The incoming HTTP request containing JSON data.

    Returns:
        A dictionary representing the parsed JSON data.
    """
    return await request.json()


# Step 1: Wrap the pretrained sentiment analysis model in a Serve deployment.
@serve.deployment
class ModelDeployment:
    def __init__(self):
        """
        Initialize the ModelDeployment class.

        This constructor initializes the class and loads the pretrained sentiment analysis model.
        """
        self._model = SentenceTransformer('sentence-transformers/all-mpnet-base-v2')

    def __call__(self, data: dict) -> Dict:
        """
        Embed texts using sentence transformers.

        Args:
            data: The input data containing a list of texts to embed.

        Returns:
            A dictionary containing embeddings of input texts, each represented as a list of floats.
        """
        input_texts = json.loads(data)['input']
        embeddings = [torch.from_numpy(self._model.encode(text, convert_to_numpy=True)).tolist() for text in input_texts]
        response = {'data': embeddings}
        return response


# Step 2: Deploy the model deployment.
ray.init(address='ray://localhost:10001')
serve.run(DAGDriver.bind(ModelDeployment.bind(), http_adapter=json_resolver), host="0.0.0.0", port=8888)