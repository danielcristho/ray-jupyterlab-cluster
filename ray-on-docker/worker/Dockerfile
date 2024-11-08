FROM python:3.12-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ray

COPY requirements.txt /ray/

RUN pip install -r requirements.txt

EXPOSE 8888

EXPOSE 6379 10001 8265

# Start Jupyter Notebook
CMD ["jupyter", "lab", "--ip=0.0.0.0","--port=8888", "--allow-root"]