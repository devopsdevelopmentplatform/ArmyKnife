# Default action is to run all stages
.PHONY: docker-build docker-test docker-deploy

# Build stage
docker-build:
	@echo "Building application..."
	cd tools/DockerBuilds && ./docker-build-golang.sh

# Test stage
docker-test:
	@echo "Running tests..."

# Deploy stage
docker-deploy:
	@echo "Deploying application..."

# You can define more targets here for other actions

