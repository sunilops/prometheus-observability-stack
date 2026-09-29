# Usage: make all SERVER_IP=<ec2-public-ip>
# If SERVER_IP is not passed, we try to auto-detect the machine's public IP.

SERVER_IP ?= $(shell curl -s ifconfig.me)

.PHONY: all update-prometheus-config update-targets show-ip

all: update-prometheus-config update-targets
	@echo "Prometheus config patched with SERVER_IP=$(SERVER_IP)"

update-prometheus-config:
	@sed -i.bak "s/SERVER_IP/$(SERVER_IP)/g" prometheus/prometheus.yml
	@echo "Updated prometheus/prometheus.yml -> alertmanager target = $(SERVER_IP):9093"

update-targets:
	@sed -i.bak "s/SERVER_IP/$(SERVER_IP)/g" prometheus/targets.json
	@echo "Updated prometheus/targets.json -> node-exporter target = $(SERVER_IP):9100"

show-ip:
	@echo "Detected/used SERVER_IP=$(SERVER_IP)"
