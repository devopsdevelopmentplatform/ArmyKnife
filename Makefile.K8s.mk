# Function to download file using curl
define download_file
	echo "Downloading $(2)..."
	curl -Lo $(1) $(2) && chmod +x $(1)
	sudo mv -t /usr/local/bin $(1)
	rm -f $(1)
endef

.PHONY: check-tools-now configure-minikube kubespray-install

# Deploy Cost Optimization Tool and get reports from it








# Check for required tools and download if not present

check-tools-now:
	@if ! command -v kubectl > /dev/null; then \
		echo "kubectl not found, downloading..."; \
		if [ $$(uname) = "Linux" ]; then \
			curl -LO "https://storage.googleapis.com/kubernetes-release/release/$$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"; \
		else \
			curl -LO "https://storage.googleapis.com/kubernetes-release/release/$$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/arm64/kubectl"; \
		fi; \
		chmod +x kubectl && \
		sudo mv kubectl /usr/local/bin/; \
	fi
	@if ! command -v minikube > /dev/null; then \
		echo "minikube not found, downloading..."; \
		if [ $$(uname) = "Linux" ]; then \
			curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64" && \
			chmod +x minikube-linux-amd64 && \
			sudo mv minikube-linux-amd64 /usr/local/bin/minikube; \
		else \
			curl -LO "https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64" && \
			chmod +x minikube-darwin-amd64 && \
			sudo mv minikube-darwin-amd64 /usr/local/bin/minikube; \
		fi; \
	fi


# Start Minikube with Docker driver

configure-minikube: check-tools-now
	echo "Starting Minikube..."
	minikube start --listen-address="0.0.0.0" --driver=docker 2> /dev/null || { echo "Failed to start Minikube. This uses docker. Please make sure Docker is installed"; exit 1; }
	echo "Minikube started successfully."
	echo "Testing Minikube..."
	kubectl get nodes 2> /dev/null || { echo "Failed to connect to Minikube"; exit 1; }
	minikube addons enable ingress 2> /dev/null || { echo "Failed to enable ingress addon"; exit 1; }
	minikube addons enable metrics-server 2> /dev/null || { echo "Failed to enable metrics-server addon"; exit 1; }
	echo "Minikube is ready."


# Setup KubeSpray
kubespray-install:
	@echo "Installing KubeSpray...Needs more testing after the cluster is already up."
	if [ ! -d tools/kubespary ]; then cd tools && git clone https://github.com/kubernetes-sigs/kubespray.git; else echo "KubeSpray already installed"; fi
	cp Vagrantfile tools/kubespray/Vagrantfile
	cd tools/kubespray && python3 -m venv .venv
	cd tools/kubespray/ && sudo chmod 777 .venv && . .venv/bin/activate && pip3 install -r requirements.txt
	cd tools/kubespray && vagrant up --provider virtualbox

kubespray-up:
	@echo "Starting KubeSpray..."
	cd tools/kubespray && vagrant up --provider=virtualbox