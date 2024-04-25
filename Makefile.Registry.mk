# Makefile.Registry.mk
# Variable Definitions
DOCKER_REGISTRY_DIR := Docker_Registry
HTPASSWD_FILE := $(DOCKER_REGISTRY_DIR)/auth/htpasswd
USER_NAME := armyknife-user
USER_PASS := armyknife
REGISTRY_CONTAINER_NAME := registry
REGISTRY_PORT := 5000
OS := $(shell uname -s)

# Default target
all: create_dir setup_htpasswd run_registry login-registry

# Create directory for Docker registry credentials
create_dir:
	@mkdir -p $(DOCKER_REGISTRY_DIR)/auth
	@echo "Directory $(DOCKER_REGISTRY_DIR)/auth created for Docker registry credentials."

# Setup htpasswd file for authentication
setup_htpasswd: create_dir
	@docker run --rm --entrypoint htpasswd httpd:2 -Bbn $(USER_NAME) $(USER_PASS) > $(HTPASSWD_FILE)
	@echo "htpasswd file setup for Docker registry authentication."

# Run the Docker registry container with authentication
run_registry: setup_htpasswd
	@docker stop $(REGISTRY_CONTAINER_NAME) > /dev/null 2>&1 || true
	@docker rm $(REGISTRY_CONTAINER_NAME) > /dev/null 2>&1 || true
	@docker run -itd \
        -p $(REGISTRY_PORT):$(REGISTRY_PORT) \
        --name $(REGISTRY_CONTAINER_NAME) \
        -v "$(shell pwd)/$(HTPASSWD_FILE)":/auth/htpasswd \
        -e "REGISTRY_AUTH=htpasswd" \
        -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
        -e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
        registry
	@echo "Docker registry container running with authentication."


login-registry:
	@docker login localhost:$(REGISTRY_PORT) -u $(USER_NAME) -p $(USER_PASS)

# Target to bring up containers and login to the registry after reboot
start-after-reboot: registry-clean configure_docker_daemon run_registry login-registry

# Clean up resources
registry-clean:
	@docker stop $(REGISTRY_CONTAINER_NAME) > /dev/null 2>&1 || true
	@docker rm $(REGISTRY_CONTAINER_NAME) > /dev/null 2>&1 || true
	@rm -rf $(HTPASSWD_FILE)
	@echo "Cleaned up resources."

.PHONY: all create_dir configure_docker_daemon setup_htpasswd run_registry clean start-after-reboot



