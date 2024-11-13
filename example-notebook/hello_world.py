import ray
from ray import serve
import requests

# init ray
ray.init("ray://127.0.0.1:10001", ignore_reinit_error=True)
print("Ray connected!")

serve.start(detached=True)
print("Ray Serve started!")

resources = ray.cluster_resources()
print("Cluster Resources:", resources)

@serve.deployment
def hello_world(request):
    return "Hello, Ray Serve!"

serve.run(hello_world.bind())
print("Hello World deployment successful!")

try:
    response = requests.get("http://127.0.0.1:8000/hello_world")
    print("Response from hello_world:", response.text)
except requests.ConnectionError as e:
    print("Failed to connect to the endpoint:", e)
