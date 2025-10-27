.PHONY: help list stop-all

# This Makefile mirrors ONLY training-provided automation.
# It calls the scripts that came with the labs (start/stop/update).
# It does NOT automate the manual diagnose/fix steps to preserve learning.

EF := exercise-files

help: list
	@:

list:
	@echo "Available scripted labs (from training):"
	@echo "  02_04  -> start, stop"
	@echo "  03_10  -> start, stop"
	@echo "  04_01  -> dns-update (CoreDNS change)"
	@echo "  04_04  -> start (Calico), (no stop script provided)"
	@echo "  04_07  -> start (Ingress), (no stop script provided)"
	@echo "  04_10  -> start (Ingress challenge)"
	@echo "  04_11  -> start (Ingress challenge v2)"
	@echo "  05_03  -> start (kubeconfig certs)"
	@echo "  05_08  -> start (kubelet args + no-CNI)"
	@echo "  05_12  -> start (finalizers namespace)"
	@echo "  utility -> stop-all (delete all kind clusters)"
	@echo
	@echo "Usage: make <target>"

# 02_04 (scripts present in training)
start-02-04:
	@cd $(EF)/02_04_before && ./start_cluster.sh

stop-02-04:
	@cd $(EF)/02_04_before && ./stop_cluster.sh

# 03_10 (scripts present in training)
start-03-10:
	@cd $(EF)/03_10_before && ./start_cluster.sh

stop-03-10:
	@cd $(EF)/03_10_before && ./stop_cluster.sh

# 04_01: DNS update script only (training-provided)
dns-update-04-01:
	@cd $(EF)/04_01_before && ./update_dns.sh

# 04_04: start script provided (installs Calico and applies app)
start-04-04:
	@cd $(EF)/04_04_before && ./start_cluster.sh

# 04_07: start script provided (Ingress controller)
start-04-07:
	@cd $(EF)/04_07_before && ./start_cluster.sh

# 04_10: start script provided (Ingress challenge)
start-04-10:
	@cd $(EF)/04_10_before && ./start_cluster.sh

# 04_11: start script provided (Ingress challenge v2)
start-04-11:
	@cd $(EF)/04_11_before && ./start_cluster.sh

# 05_03: start script provided (kubeconfig cert manipulation)
start-05-03:
	@cd $(EF)/05_03_before && ./start_cluster.sh

# 05_08: start script provided (two clusters and kubelet tweak)
start-05-08:
	@cd $(EF)/05_08_before && ./start_cluster.sh

# 05_12: start script provided (finalizers)
start-05-12:
	@cd $(EF)/05_12_before && ./start_cluster.sh

# Utility: delete all kind clusters (no extra automation)
stop-all:
	@set -e; \
	clusters=$$(kind get clusters); \
	if [ -z "$$clusters" ]; then \
	  echo "No kind clusters found."; \
	else \
	  for c in $$clusters; do \
	    echo "Deleting kind cluster: $$c"; \
	    kind delete cluster --name $$c; \
	  done; \
	fi
