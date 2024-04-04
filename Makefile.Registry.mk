# Makefile.Registry.mk
# docker login  localhost:5000 -u armyknife-user -p armyknife
# Variable Definitions
DOCKER_REGISTRY_DIR := Docker_Registry
HTPASSWD_FILE := $(DOCKER_REGISTRY_DIR)/auth/htpasswd
USER_NAME := armyknife-user
USER_PASS := armyknife
REGISTRY_CONTAINER_NAME := registry
REGISTRY_PORT := 5000

# Default target
all: create_dir configure_docker_daemon setup_htpasswd run_registry

# Create directory for Docker registry credentials
create_dir:
	@mkdir -p $(DOCKER_REGISTRY_DIR)/auth
	@echo "Directory $(DOCKER_REGISTRY_DIR)/auth created for Docker registry credentials."

# Add Docker daemon configuration for insecure registry and restart Docker
configure_docker_daemon:
	@echo '{ "insecure-registries":["localhost:$(REGISTRY_PORT)"] }' | sudo tee /etc/docker/daemon.json > /dev/null
	@sudo systemctl daemon-reload
	@sudo systemctl restart docker
	@echo "Docker daemon configured for insecure registry and restarted."

# Setup htpasswd file for authentication
setup_htpasswd: create_dir
	@docker run --rm --entrypoint htpasswd httpd:2 -Bbn $(USER_NAME) $(USER_PASS) > $(HTPASSWD_FILE)
	@echo "htpasswd file setup for Docker registry authentication."

# Run the Docker registry container with authentication
run_registry: setup_htpasswd
	@docker run -itd \
		-p $(REGISTRY_PORT):$(REGISTRY_PORT) \
		--name $(REGISTRY_CONTAINER_NAME) \
		-v "$(shell pwd)/$(HTPASSWD_FILE)":/auth/htpasswd \
		-e "REGISTRY_AUTH=htpasswd" \
		-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
		-e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
		registry
	@echo "Docker registry container running with authentication."

# Clean up resources
clean:
	@docker stop $(REGISTRY_CONTAINER_NAME) > /dev/null 2>&1 || true
	@docker rm $(REGISTRY_CONTAINER_NAME) > /dev/null 2>&1 || true
	@rm -rf $(HTPASSWD_FILE)
	@echo "Cleaned up resources."

.PHONY: all create_dir configure_docker_daemon setup_htpasswd run_registry clean



