from flask import Flask, jsonify, request
import requests

app = Flask(__name__)
jupyter_base_url = "http://localhost:8888"

@app.route('/start_kernel', methods=['POST'])
def start_kernel():
    response = requests.post(f'{jupyter_base_url}/api/kernels')
    return jsonify(response.json())

@app.route('/stop_kernel/<kernel_id>', methods=['DELETE'])
def stop_kernel(kernel_id):
    response = requests.delete(f'{jupyter_base_url}/api/kernels/{kernel_id}')
    return jsonify({"status": "stopped", "kernel_id": kernel_id})

@app.route('/kernels', methods=['GET'])
def list_kernels():
    response = requests.get(f'{jupyter_base_url}/api/kernels')
    return jsonify(response.json())

if __name__ == '__main__':
    app.run(port=5000)
