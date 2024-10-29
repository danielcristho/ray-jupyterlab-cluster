ray metrics launch-prometheus
wget https://dl.grafana.com/oss/release/grafana_11.0.0_amd64.deb
dpkg -i grafana_11.0.0_amd64.deb
grafana-server --config /tmp/ray/session_latest/metrics/grafana/grafana.ini --homepath /usr/share/grafana