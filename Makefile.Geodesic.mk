# Makefile.Docker.mk

# Variables
IMAGE_NAME := localhost:5000/frisbee
TAG := latest
DOCKERFILE_DIR := tools/geodesic
ORG_IMAGE_NAME := cloudposse/geodesic
ORGTAG := dev
DOCKERFILE_DIR := tools/geodesic

# Commands
#BUILD_CMD := docker build -t $(IMAGE_NAME):$(TAG) -f $(DOCKERFILE_DIR)/Dockerfile.debian .
BUILD_CMD := make all
#TAG_CMD := docker tag $(ORG_IMAGE_NAME):$(ORGTAG) $(IMAGE_NAME):$(TAG)
TAG_CMD := docker tag cloudposse/geodesic:dev localhost:5000/frisbee:latest
PUSH_CMD := docker push $(IMAGE_NAME):$(TAG)

# Default target
.PHONY: all connect-to-geodesic build-geodesic
all: build-geodesic connect-to-geodesic
	@echo "All targets completed."

# Build the Docker image
build-geodesic:
	@echo "Building Geodesic"
	cd $(DOCKERFILE_DIR) && make build && $(TAG_CMD) && $(PUSH_CMD)
	@echo "Geodesic build completed."


connect-to-geodesic:
ifeq ($(shell uname), Darwin)
	osascript -e 'tell application "Terminal" to activate' -e 'tell application "Terminal" to do script "~/localprojects/ArmyKnife/community/bash/frisbee.sh"'
else
	gnome-terminal -- /bin/bash -c "community/bash/frisbee.sh"
endif