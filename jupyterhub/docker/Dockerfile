FROM jupyterhub/jupyterhub:4.1

RUN apt-get update \
    && apt-get install -y gcc  python3-dev git \
    && python3 -m pip install --upgrade pip
# RUN pip install --upgrade setuptools

WORKDIR /jupyter
COPY config/requirements.txt .
RUN pip install -r ./requirements.txt
COPY config/jupyterhub_config.py /srv/

ENTRYPOINT jupyterhub --log-level=DEBUG -f /srv/jupyterhub_config.py