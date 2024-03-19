#!/bin/bash

# Start minikube
    echo "Starting Minikube..."
	minikube start --listen-address="0.0.0.0" --driver=docker 2> /dev/null || { echo "Failed to start Minikube. This uses docker. Please make sure Docker is installed"; exit 1; }
	echo "Minikube started successfully."
	echo "Testing Minikube..."
	kubectl get nodes 2> /dev/null || { echo "Failed to connect to Minikube"; exit 1; }
	minikube addons enable ingress 2> /dev/null || { echo "Failed to enable ingress addon"; exit 1; }
	minikube addons enable metrics-server 2> /dev/null || { echo "Failed to enable metrics-server addon"; exit 1; }