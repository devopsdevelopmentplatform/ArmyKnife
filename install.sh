# Warning!! This script is not tested and should be used with caution.
#!/bin/bash

# Ensure Make is installed
if ! command -v make &>/dev/null; then
    echo "Make is not installed. Please install make to proceed."
    # Provide guidance for installing make based on the OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "Try installing make using: sudo apt-get install -y make (for Debian/Ubuntu) or sudo yum install -y make (for CentOS/RHEL)"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "Try installing make using: brew install make"
    fi
    exit 1
fi

# Copy over .bashrc or .zshrc if it doesn't exist depending on if MacOS or Linux.
if [ "`uname`" = "Darwin" ]; then \
    cp support/.zshrc ~/.zshrc; \
else \
    cp support/.bashrc ~/.bashrc; \
fi



# Copy env_sample.txt to .env if it doesn't exist
if [ ! -f .env ]; then
    if [ -f env_sample.txt ]; then
        cp env_sample.txt .env
        echo ".env file created from env_sample.txt. Now is a good time to fill out username and email for Git Settings"
    else
        echo "env_sample.txt does not exist. Please ensure env_sample.txt is in the current directory."
        exit 1
    fi
else
    echo ".env file already exists. Now is a good time to fill out username and email for Git Settings"
fi

# Function to run a Make target
run_make_target() {
    target=$1
    echo "Running make target: $target . You may be prompted for your password. You may need to run it multiple times until you see a Success message."
    make $target
    if [ $? -ne 0 ]; then
        echo "Failed to execute make target: $target"
        exit 1
    fi
}

# Run necessary Make targets
run_make_target setup-workstation
# Add more targets as necessary

echo "Setup completed successfully."
