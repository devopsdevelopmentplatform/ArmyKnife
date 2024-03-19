# ArmyKnife DevOps CI/CD Framework Development Environment Tier1
## Project for "Makefiles for Cloud/DevOps Engineers"

## Overview
ArmyKnife is an open-source project aimed at providing DevOps engineers with a robust, self-contained development environment. This tool allows for the development and testing of tools and scripts without the need for cloud or production resources. It is divied into three tiers for easy managmenant and support.

### Key Features
- **Tiered Architecture**: The project is structured into three distinct tiers, catering to various aspects of DevOps needs.
    - **Tier-1 (DevOps)** Is the most important part of the stack where it builds the base for the entire project with Hashicorp Vault, Ansible, Geodesic, and ELK Stack. The entire process is automated with Makefiles and various shell/python scripts. After your done setting up Tier-1 your ready to begin your DevOps Development.
    - **Tier-2 (DevSecOps)** This stack is where you setup your CICD Platforms. Gitlab, Gitea(Github Actions Clone), and Jenkins. Minikube is running for local development but you can easily connect your local CICD Platform to the Cloud.
    - **Tier-3 (CyberSecurity)** This is where you take your DevOps Knowledge and apply it to CyberSecurity to automate and remediate pentesting and vulnerability remediation.

- **Scalability**: Designed to handle small to large scale projects with ease.
    - The initial project uses Virtualbox and Vagrant but also uses ProxMox with unlimited Scalability.
- **Isolation**: Develop and test in an environment separate from your production systems.
    - You can connect your local development network to the cloud or anywhere else you like using a simple VPN.

## Getting Started

### Notes
- This only works with MacOS and Linux (Ubuntu) at this time but nothing stopping you from running virtualbox inside a Windows environment or WSL.
- Use Ubuntu for the full experience.
- 90% of the project works on MacOS. Custom Virtualbox Development does not work on MacOS so I added Vagrant development and that works fine.

### Prerequisites
- VSCode, Docker Desktop (Homebrew has a cask for VSCode so you could automate the install if you want to)
- Intel Based Mac or Ubuntu (Arm Based Mac will work for most things but not Virtualbox. I will test vagrant)

- 
### Installation
1. Clone the repo.
2. Inside the repo take the env_sample.txt and rename it to .env
3. Fill out your Github user information inside the .env and update as you go along.
4. You will want to capture the root token for vault and the unseal token. It is kept inside a file on the root of the docker container if you lose it.
5. Create a PAT for Github so you can clone things and update your development environment later.
6. This is mean to be forked. A folder structure is in place for your own scripts and community scripts. but its best to keep pushing to your own repo after you fork it.
7. You can set the upstream to this repo if you want to keep up to date on the changes.
8. Since this is in Beta a lot can go wrong with a project this size and its complexity.
9. The first thing you will want to do is run make import_ova. This will download the Bitnami VirtualBoxes we will be working with so you can Import them. This is automated.
10. The first thing you want to do is stand up your ELK server. Why? Because this captures all the logs from all the servers and its easier to find out what is going wrong by looking through elasticsearch.


## Usage
- How to use ArmyKnife
- Examples of common tasks

## Contributing
We welcome contributions to the ArmyKnife project. Please read our [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on how to contribute.

## Support and Documentation
- For support, please open an issue in the GitHub issue tracker.
- For documentation, please refer to [docs](link to documentation).

## License
This project is licensed under the [LICENSE](LICENSE) - see the file for details.

## Acknowledgments
- List any contributors, third-party libraries, etc.































