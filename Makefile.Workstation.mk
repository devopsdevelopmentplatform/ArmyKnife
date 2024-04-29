# Define the default target when you run `make` without arguments
.DEFAULT_GOAL := help

# Define the path to the local projects directory
LOCALPROJECT := ~/localprojects/python_test_project

ARMYKNIFE := ~/localprojects/ArmyKnife

# Define the packages to be installed via Homebrew (common packages for both)

COMMON_PACKAGES := wget curl jq 

# Define Python development tools
PYTHON_DEV_TOOLS := pipenv pytest flake8 isort sphinx tox twine pylint autopep8 black mypy bandit poetry

# Define Kubernetes tools
KUBERNETES_TOOLS := kubectl kustomize helm

# Define GitHub tools
GITHUB_TOOLS := gh git-lfs git-secrets git-crypt git-extras git-flow git-gui

# Define Visual Studio Code (VSCode)
VSCODE := visual-studio-code

# Define the dotfile manager
DOTFILE_MANAGER := stow

.PHONY: macos-setup-homebrew install-common-packages install-python-tools install-kubernetes-tools install-jenkins-tools install-github-cli install-vscode setup-dotfile-manager generate-ssh-keys install-essential-dev-tools update-shell-config setup-macos setup-ubuntu setup ubuntu-setup-packages install-amix-vimrc install-full-vim-ubuntu install-oh-my-zsh install-oh-my-bash install-go-support-tools install-rust-support-tools setup-linux	

# Check if homebrew is already installed by checking if the homebrew folder exists /home/linuxbrew
# Tested and working properly
setup-homebrew:
	@if ! which brew &>/dev/null; then \
		echo "Homebrew not found. Installing..." && /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	fi


# Define the target for installing packages using Homebrew (common for both)
install-common-packages:
	brew install $(COMMON_PACKAGES)

# Define the target for installing Python development tools (common for both)
install-python-tools:
	@echo "Installing Python development tools..."
	mkdir -p $(LOCALPROJECT); \
	cp requirements.txt $(LOCALPROJECT); \
	cd ~/localprojects/python_test_project && $(MAKE) -d -f $(ARMYKNIFE)/Makefile.Python.mk setup; \
	brew install pyinstaller pyenv virtualenv

# Install Conda for Python but does not support cask
install-conda:
	wget https://repo.anaconda.com/archive/Anaconda-latest-Linux-x86_64.sh; \
	bash Anaconda-latest-Linux-x86_64.sh

# Define the target for installing Kubernetes tools (common for both)
install-kubernetes-tools:
	brew install $(KUBERNETES_TOOLS)

# Define the target for installing GitHub CLI (common for both)
install-github-cli:
	brew install $(GITHUB_TOOLS)

# Define the target for installing Visual Studio Code (VSCode) (common for both)
install-vscode:
	brew install --cask $(VSCODE)

# Define the target for setting up the dotfile manager (common for both)
setup-dotfile-manager:
	brew install $(DOTFILE_MANAGER)

# Define the target for setting up packages using APT on Ubuntu
# Tested and working properly
ubuntu-setup-packages:
	sudo apt update && sudo apt upgrade -y && sudo apt remove -y minidlna
	sudo apt install -y git make wget curl jq qemu-system-x86 qemu-utils cloud-guest-utils cloud-init virtualbox cloud-utils build-essential vim virtualbox libvirt-daemon-system libvirt-clients  libvirt-daemon bridge-utils virt-manager libguestfs-tools libosinfo-bin libguestfs-tools virt-top virtinst libvirt-doc wget curl jq make zsh git libz-dev vim vim-gtk3 gnome-terminal gnome-tweaks gnome-shell-extensions gnome-shell-extension-ubuntu-dock python3.10-venv 
# Define the target to generate SSH keys
# Make sure you update the keys in vagrant and virtualbox cloud-init files
create-ssh-keys:
	mkdir -p keys
	ssh-keygen -t rsa -b 4096 -f keys/armyknife -C "fatporkrinds@gmail.com"

# Define the target to check and install essential development tools
install-essential-dev-tools:
	echo "Skipping essential development tools installation..."
	@if ! which cargo &>/dev/null; then \
		echo "Cargo not found. Installing..." && brew install rust; \
	fi
	@if ! which go &>/dev/null; then \
		echo "Go not found. Installing..." && brew install golang; \
	fi


# Define the target to update .bashrc and .zshrc files with tool-specific settings
update-shell-config:
	@echo "Updating shell configuration..."
	@if [ "$(shell uname)" = "Darwin" ]; then \
		echo 'export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"' >> ~/.bashrc; \
		echo 'export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"' >> ~/.zshrc; \
		echo 'eval "$$(/usr/local/bin/brew shellenv)"' >> ~/.bashrc; \
		echo 'eval "$$(/usr/local/bin/brew shellenv)"' >> ~/.zshrc; \
	fi
	@if [ -f "/home/$(USER)/.bashrc" ]; then \
		sudo echo 'eval "$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc; \
	fi
	@if [ -f "/home/$(USER)/.zshrc" ]; then \
		sudo echo 'eval "$$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc; \
	fi
	@if [ ! -d "/usr/local/opt/go/bin" ]; then \
		echo 'export PATH="/usr/local/opt/go/bin:$${PATH}"' >> ~/.bashrc; \
		echo 'export PATH="/usr/local/opt/go/bin:$${PATH}"' >> ~/.zshrc; \
	fi
	@if [ ! -d "/usr/local/opt/rust/bin" ]; then \
		echo 'export PATH="/usr/local/opt/rust/bin:$${PATH}"' >> ~/.bashrc; \
		echo 'export PATH="/usr/local/opt/rust/bin:$${PATH}"' >> ~/.zshrc; \
	fi
	# Additions for GOPATH, GOBIN, and GOROOT
	@if [ ! -d "/usr/local/opt/go/bin" ]; then \
		echo 'export GOPATH=$$HOME/go' >> ~/.bashrc; \
		echo 'export GOPATH=$$HOME/go' >> ~/.zshrc; \
		echo 'export GOBIN=$$GOPATH/bin' >> ~/.bashrc; \
		echo 'export GOBIN=$$GOPATH/bin' >> ~/.zshrc; \
		echo 'export GOROOT="$$(brew --prefix golang)/libexec"' >> ~/.bashrc; \
		echo 'export GOROOT="$$(brew --prefix golang)/libexec"' >> ~/.zshrc; \
		echo 'export PATH=$$PATH:$$GOPATH/bin' >> ~/.bashrc; \
		echo 'export PATH=$$PATH:$$GOPATH/bin' >> ~/.zshrc; \
		echo 'export PATH=$$PATH:$$GOROOT/bin' >> ~/.bashrc; \
		echo 'export PATH=$$PATH:$$GOROOT/bin' >> ~/.zshrc; \
		echo 'export PATH=$$PATH:/usr/local/opt/go/bin' >> ~/.bashrc; \
		echo 'export PATH=$$PATH:/usr/local/opt/go/bin' >> ~/.zshrc; \
	fi
	@echo 'source ~/.bashrc' >> ~/.zshrc


		

# Define the target to install amix/vimrc configuration for Vim
install-amix-vimrc:
	if [ -d "/home/$$USER/.vim_runtime" ]; then \
		echo "amix/vimrc already installed. Skipping..."; \
	else \
		echo "Installing amix/vimrc..."; \
		git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime; \
		sh ~/.vim_runtime/install_awesome_vimrc.sh; \
	fi

# Define the target to install full Vim suite on Ubuntu
install-full-vim-ubuntu:
	sudo apt update
	sudo apt install -y vim vim-gtk3

# Define the target to install Oh My Zsh
install-oh-my-bash:
	if [ "`uname`" = "Darwin" ]; then \
        if [ ! -d "/Users/$(USER)/.oh-my-zsh" ]; then \
            sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; \
        fi \
    else \
        if [ ! -d "/home/$(USER)/.oh-my-bash" ]; then \
            bash -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"; \
        fi \
    fi

		

# Define the target to install support tools for Go
install-go-support-tools:
	go install github.com/goreleaser/goreleaser@latest
	echo "Installing Go support tools..."

# Define the target to install support tools for Rust
install-rust-support-tools:
	cargo install ytop
	cargo install cargo-update
	cargo install cargo-make




# Define the target to install Docker on Ubuntu
install-docker-ubuntu:
	# If docker is not installed then install it
	@if ! command -v docker &>/dev/null; then \
		echo "Adding Docker's official GPG key..."; \
		sudo apt-get update && \
		sudo apt-get install -y ca-certificates curl gnupg; \
		sudo install -m 0755 -d /etc/apt/keyrings && \
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg; \
		sudo chmod a+r /etc/apt/keyrings/docker.gpg; \
		echo "Adding the Docker repository to Apt sources..."; \
		echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list; \
		sudo apt-get update; \
		echo "Installing Docker..."; \
		sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose; \
		sudo usermod -aG docker $$USER; \
		echo "Please log out and back in to apply the necessary Docker group changes."; \
	else \
		echo "Docker is already installed."; \
	fi

install-vagrant:
	@which vagrant || (sudo apt update && sudo apt install -y gpg wget apt-transport-https; \
	sudo wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg; \
	sudo gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint | grep -q "798A EC65 4E5C 1542 8C8E 42EE AA16 FCBC A621 E701"; \
	echo "deb [arch=$$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $$(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list; \
	sudo apt update && sudo apt install -y vagrant vault terraform)

# Main target for setting up the development workstation on MacOS
#setup-macos: setup-homebrew install-common-packages setup-dotfile-manager install-python-tools install-kubernetes-tools install-github-cli install-vscode install-essential-dev-tools update-shell-config install-amix-vimrc install-oh-my-zsh install-go-support-tools install-rust-support-tools	
setup-macos: setup-homebrew update-shell-config install-common-packages install-kubernetes-tools install-github-cli setup-dotfile-manager install-essential-dev-tools install-amix-vimrc install-go-support-tools install-rust-support-tools install-oh-my-bash 
# Main target for setting up the development workstation on Ubuntu
setup-ubuntu: ubuntu-setup-packages setup-homebrew update-shell-config install-common-packages setup-dotfile-manager install-kubernetes-tools install-github-cli install-essential-dev-tools install-full-vim-ubuntu install-oh-my-bash install-go-support-tools install-rust-support-tools install-docker-ubuntu update-shell-config setup-vscode

# Example 
setup-vscode:
	@echo "Setting up Linux Workstation..."
	@echo "--------------------------------------------------------------------------------"
	@echo " ArmyKnife DevOps CI/CD Framework Development Environment Setup for Linux"
	@echo "--------------------------------------------------------------------------------"
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing OS packages and Oh My Zsh..."
	# Not needed @$(MAKE) -f Makefile.Workstation.mk ubuntu-setup-packages
	# Not needed @$(MAKE) -f Makefile.Workstation.mk install-oh-my-bash
	# Not needed @$(MAKE) -f Makefile.Workstation.mk setup-homebrew
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing essential development tools..."
	# Not needed @$(MAKE) -f Makefile.Workstation.mk install-essential-dev-tools
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing common packages..."
	# Not needed @$(MAKE) -f Makefile.Workstation.mk install-common-packages
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing dotfile manager..."
	# Not needed @$(MAKE) -f Makefile.Workstation.mk setup-dotfile-manager
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing Kubernetes tools..."
	# Not needed @$(MAKE) -f Makefile.Workstation.mk install-kubernetes-tools
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing GitHub CLI..."
	# Not needed @$(MAKE) -f Makefile.Workstation.mk install-github-cli
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing Rust"
	# Not needed @$(MAKE) -f Makefile.Workstation.mk install-rust-support-tools
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing Go"
	# Not needed @$(MAKE) -f Makefile.Workstation.mk install-go-support-tools
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing Python tools..."
	# Not needed @$(MAKE) -f Makefile.Workstation.mk install-python-tools
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing Visual Studio Code..."
	@wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	@sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
	@sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	@sudo apt install -y apt-transport-https
	@sudo apt update
	@sudo apt install -y code
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing Docker..."
	# Not needed @$(MAKE) -f Makefile.Workstation.mk install-docker-ubuntu
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing Vim..."
	# @$(MAKE) -f Makefile.Workstation.mk install-full-vim-ubuntu
	@echo "--------------------------------------------------------------------------------"
	@echo "Installing amix/vimrc..."
	# @$(MAKE) -f Makefile.Workstation.mk install-amix-vimrc
	@echo "--------------------------------------------------------------------------------"


	


