# Variables for Docker image
DOCKER_IMAGE_NAME=fatporkrinds/fat-tool-box
DOCKER_IMAGE_VERSION=latest
DOCKER_REGISTRIES=docker.io quay.io 
VAULT_ADDR=HTTP://127.0.0.1:8200

# Include Vault token from .env file
# Copy example file env_sample.txt to .env before running setup
include .env
export

# Phony targets for specific workflow steps
.PHONY: all build_cloud_cli_image test_cloud_cli_image login_to_registries push_cloud_cli_image_to_registries run_local

# Default target to execute the full workflow
all: build_cloud_cli_image test_cloud_cli_image login_to_registries push_cloud_cli_image_to_registries

## Build the Docker image with cloud CLIs
build_cloud_cli_image:
	@echo "Building Docker image $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)..."
	cd tools/CICD/cloud-image && docker buildx build -t quay.io/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) --push .

	
	

## Test the Docker image to ensure cloud CLIs are working
test_cloud_cli_image:
	@echo "Testing Docker image $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)..."
	# Example: check the version of installed CLIs. Replace or extend these with real tests.
	docker run --rm $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) aws --version
	docker run --rm $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) az --version
	docker run --rm $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) gcloud --version

## Login to Docker Registries using credentials from HashiCorp Vault
login_to_registries:
	@echo "Logging in to Docker Registries..."
	@$(foreach REGISTRY, $(DOCKER_REGISTRIES), \
		DOCKER_USERNAME=$$(curl -s --header "X-Vault-Token: $$VAULT_TOKEN" $(VAULT_ADDR)/v1/secret/data/docker/$$REGISTRY/username | jq -r .data.data.username) ; \
		DOCKER_PASSWORD=$$(curl -s --header "X-Vault-Token: $$VAULT_TOKEN" $(VAULT_ADDR)/v1/secret/data/docker/$$REGISTRY/password | jq -r .data.data.password) ; \
		echo $$DOCKER_PASSWORD | docker login $$REGISTRY --username $$DOCKER_USERNAME --password-stdin ; \
	)

## Push the Docker image to specified registries for redundancy
push_cloud_cli_image_to_registries: login_to_registries
	@$(foreach REGISTRY, $(DOCKER_REGISTRIES), \
		echo "Tagging and pushing $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) to $$REGISTRY..." ; \
		docker tag $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) $$REGISTRY/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) ; \
		docker push $$REGISTRY/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) ; \
	)

## Run the Docker image locally with the user's home directory mounted
run_local:
	@echo "Running $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION) with local home directory mounted..."
	docker run -it --rm -v ${HOME}:/root $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)



