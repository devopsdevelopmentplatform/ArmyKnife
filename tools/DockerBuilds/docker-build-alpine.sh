#!/bin/bash

# Set default values if not already set
DOCKER_DRIVER=${DOCKER_DRIVER:-overlay2}
USE_DOCKER_CACHE=${USE_DOCKER_CACHE:-true}
CI_DOCKER_REGISTRY_USER=${CI_DOCKER_REGISTRY_USER:-fatporkrinds}
CI_DOCKER_REGISTRY_PASSWORD="${CI_DOCKER_REGISTRY_PASSWORD:-$(cat ../../.env | grep DOCKER_HUB | cut -d '=' -f2)}"
CI_QUAY_REGISTRY_USER=${CI_QUAY_REGISTRY_USER:-fatporkrinds}
CI_QUAY_REGISTRY_PASSWORD="${CI_QUAY_REGISTRY_PASSWORD:-$(cat ../../.env | grep QUAY_TOKEN | cut -d '=' -f2)}"
REGISTRY_DOCKER=${REGISTRY_DOCKER:-index.docker.io/v1/}
REGISTRY_QUAY=${REGISTRY_QUAY:-quay.io/v2/}

# Ensure .env exists
if [ ! -f "../../.env" ]; then
  echo ".env file not found!"
  exit 1
fi

# Login to the CI Docker Registry
#echo $CI_DOCKER_REGISTRY_PASSWORD | docker login -u $CI_DOCKER_REGISTRY_USER --password-stdin $CI_DOCKER_REGISTRY
echo $CI_QUAY_REGISTRY_PASSWORD | docker login -u $CI_QUAY_REGISTRY_USER --password-stdin $CI_QUAY_REGISTRY

# Prepare multiarch building
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes

# Create and use a new builder instance
docker buildx create --use

# Conditional builds based on registry
if [ "$REGISTRY_QUAY" = "quay.io/v2/" ]; then
    echo "Building for Docker Registry"
    REGISTRY=$REGISTRY_QUAY docker buildx bake --progress plain --push -f bake.hcl default
fi
