FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    adduser \
    libfontconfig1 \
    musl \
    nano \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ray

COPY requirements.txt install_monitoring.sh /ray/

RUN chmod 777 install_monitoring.sh

RUN pip install -r requirements.txt && ./install_monitoring.sh

EXPOSE 8888

EXPOSE 6379 10001 8265

EXPOSE 3000 9090

CMD ["/bin/bash", "-c", "jupyter lab --ip=0.0.0.0 --allow-root & \
    ray start --head --metrics-export-port=8080 --dashboard-host=0.0.0.0 & \
    tail -f /dev/null"]