# Default action is to run all stages
.PHONY: docker-build docker-test docker-deploy build-go-demo-app scan-with-trivy scan-with-grype scan-with-syft scan-with-dockle

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

build-go-demo-app:
	@echo "Building Go Demo App..."
	cd tools/DockerBuilds/Go_Demo_App && docker buildx build --platform linux/amd64,linux/arm64 -t quay.io/fatporkrinds/mygoapp --push .

scan-with-trivy:
	@echo "Pulling and testing Go Demo App..."
	trivy image quay.io/fatporkrinds/mygoapp

scan-with-grype:
	@echo "Scanning Go Demo App with Grype..."
	grype quay.io/fatporkrinds/mygoapp

scan-with-syft:
	@echo "Scanning Go Demo App with Syft..."
	syft packages --scope all-layers quay.io/fatporkrinds/mygoapp

scan-with-dockle:
	@echo "Scanning Go Demo App with Dockle..."
	dockle quay.io/fatporkrinds/mygoapp