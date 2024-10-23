# Base image
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Jupyter, Ray, and other necessary packages
RUN pip install jupyterlab notebook ray[default]

# Download Grafana
RUN wget https://dl.grafana.com/oss/release/grafana-9.5.5.linux-amd64.tar.gz \
    && tar -xvf grafana-9.5.5.linux-amd64.tar.gz \
    && mv grafana-9.5.5 /opt/grafana \
    && rm grafana-9.5.5.linux-amd64.tar.gz

# Expose Jupyter ports
EXPOSE 8888

# Expose Ray ports (for head node)
EXPOSE 6379 10001 8265

# Expose monitoring ports
EXPOSE 3000 9090

# Command to start all services
CMD ["/bin/bash", "-c", "jupyter lab --ip=0.0.0.0 --allow-root & \
    ray start --head --metrics-export-port=8080 --dashboard-host=0.0.0.0 & \
    ray metrics launch-prometheus & \
    /opt/grafana/bin/grafana-server --config /tmp/ray/session_latest/metrics/grafana/grafana.ini --homepath=/opt/grafana & \
    tail -f /dev/null"]