# Default action is to run all stages
.PHONY: docker-build docker-test docker-deploy build-go-demo-app scan-with-trivy scan-with-grype scan-with-syft scan-with-dockle lint-dockerfiles install-notary docker-build-alpine-golang

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

docker-build-alpine-golang:
	@echo "Building application..."
	cd tools/DockerBuilds/Go_Demo_App && ./docker-build-alpine-golang.sh

build-go-demo-app:
	@echo "Building Go Demo App..."
	cd tools/DockerBuilds/Go_Demo_App && docker buildx bake --platform linux/amd64,linux/arm64 -t quay.io/fatporkrinds/mygoapp --push .

lint-dockerfiles:
	@echo "Linting Dockerfiles..."
	hadolint tools/DockerBuilds/Go_Demo_App/Dockerfile --config tools/DockerBuilds/config.yaml

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

install-notary:
	@echo "Installing Notary...Work in Progress..."
	go get github.com/theupdateframework/notary/v2/cmd/notary