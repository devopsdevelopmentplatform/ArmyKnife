# Stage 1: Build stage for downloading and installing dependencies
FROM public.ecr.aws/amazonlinux/amazonlinux:2 as installer
ARG EXE_FILENAME=awscli-exe-linux-x86_64.zip
ARG BIN_DIR=/usr/local/bin
ARG INSTALL_DIR=/usr/local/aws-cli
ARG UPDATE=--update

RUN yum install -y unzip curl && \
    curl "https://awscli.amazonaws.com/${EXE_FILENAME}" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install --bin-dir ${BIN_DIR} --install-dir ${INSTALL_DIR} ${UPDATE}

# Stage 2: Create a minimal runtime image and install the remaining cloud CLIs
FROM python:3.11-slim

COPY --from=installer /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=installer /usr/local/bin/ /usr/local/bin/


# Set the working directory in the container
WORKDIR /usr/src/app

# # Install system packages
RUN apt-get update && apt-get install -y \
     curl \
     gnupg \
     lsb-release \
     && rm -rf /var/lib/apt/lists/*

# Add the Google Cloud SDK distribution URI as a package source
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud public key
RUN mkdir -p /usr/share/keyrings \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor > /usr/share/keyrings/cloud.google.gpg

# Install Google Cloud SDK
RUN apt-get update -y && apt-get install google-cloud-sdk -y

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Verify installations and show versions for debugging purposes
RUN aws --version && gcloud --version && az --version

# Install the AWS SAM CLI
RUN pip install aws-sam-cli


# Install Helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

# Install tools from apt where available (e.g. Terraform, Packer, Ansible, Docker, Docker Compose, etc.)
RUN apt-get update && apt-get install -y wget curl unzip npm git kubectl ansible docker.io docker-compose && \
    rm -rf /var/lib/apt/lists/* && \
    docker --version && \
    docker-compose --version && \
    ansible --version && \
    helm version --short && \
    npm --version && \
    kubectl version --client --short


# Install the AWS Copilot CLI
RUN curl -Lo copilot https://github.com/aws/copilot-cli/releases/latest/download/copilot-linux && chmod +x copilot && mv copilot /usr/local/bin/copilot && copilot --help

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip \
    && unzip terraform_1.1.7_linux_amd64.zip -d /usr/local/bin/ \
    && rm terraform_1.1.7_linux_amd64.zip

# Install Vault
RUN wget https://releases.hashicorp.com/vault/1.9.3/vault_1.9.3_linux_amd64.zip \
    && unzip vault_1.9.3_linux_amd64.zip -d /usr/local/bin/ \
    && rm vault_1.9.3_linux_amd64.zip

# Install Packer
RUN wget https://releases.hashicorp.com/packer/1.7.8/packer_1.7.8_linux_amd64.zip \
    && unzip packer_1.7.8_linux_amd64.zip -d /usr/local/bin/ \
    && rm packer_1.7.8_linux_amd64.zip

# Install Consul
RUN wget https://releases.hashicorp.com/consul/1.10.4/consul_1.10.4_linux_amd64.zip \
    && unzip consul_1.10.4_linux_amd64.zip -d /usr/local/bin/ \
    && rm consul_1.10.4_linux_amd64.zip

# Verify installations
RUN terraform version && vault version && packer version && consul version

RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.18.1
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# confirm installation
RUN node -v && npm -v

# Install Serverless Framework
RUN npm install -g serverless && serverless --version

# Install the AWS CDK
RUN npm install -g aws-cdk

# Install the Azure Functions Core Tools
RUN npm install -g azure-functions-core-tools@3 --unsafe-perm true

# Make sure the local bin directory is in the PATH
ENV PATH="/root/.local/bin:/usr/local/bin:/usr/local/nvm:${PATH}"


# Set the default command for the container
CMD [ "/bin/bash" ]








