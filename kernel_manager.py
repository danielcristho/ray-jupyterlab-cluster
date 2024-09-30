from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

KERNEL_GATEWAY_URL = "http://localhost:8888"

@app.route('/kernels', methods=['GET'])
def list_kernels():
    response = requests.get(f"{KERNEL_GATEWAY_URL}/api/kernels")
    return jsonify(response.json())

@app.route('/kernels', methods=['POST'])
def create_kernel():
    response = requests.post(f"{KERNEL_GATEWAY_URL}/api/kernels")
    return jsonify(response.json())

@app.route('/kernels/<kernel_id>', methods=['DELETE'])
def delete_kernel(kernel_id):
    response = requests.delete(f"{KERNEL_GATEWAY_URL}/api/kernels/{kernel_id}")
    return '', response.status_code

@app.route('/kernels/<kernel_id>/execute', methods=['POST'])
def execute_code(kernel_id):
    code = request.json['code']
    response = requests.post(
        f"{KERNEL_GATEWAY_URL}/api/kernels/{kernel_id}/channels",
        json={"header": {"msg_type": "execute_request"},
              "content": {"code": code, "silent": False}}
    )
    return jsonify(response.json())

if __name__ == '__main__':
    app.run(debug=True)