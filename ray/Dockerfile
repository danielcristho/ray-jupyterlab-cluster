# Base image
FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Jupyter and Ray
RUN pip install jupyterlab ray[default]

# Expose Jupyter ports
EXPOSE 8888

# Expose Ray ports (for head node)
EXPOSE 6379 10001 8265

# Start Jupyter Notebook
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser"]