# ArmyKnife DevOps CI/CD Framework Development Environment Tier1
![ArmyKnife Logo](ArmyKnife.png)
## Project for "Makefiles for Cloud/DevOps Engineers"

## Exciting Overview
Dive into the cutting-edge world of DevOps with ArmyKnife, an innovative, open-source project meticulously designed to empower DevOps engineers. ArmyKnife offers a robust, self-contained development environment that revolutionizes the way tools and scripts are developed and tested. Say goodbye to the dependency on cloud or production resources! Crafted with precision, ArmyKnife unfolds in three distinct tiers, each tier specifically architected to streamline management and support, ushering in a new era of efficient and optimized DevOps practice. We cover all five areas of IaC. Ad-Hoc Scripts, Configuration Managment tools, Server Templating Tools,
Orchestration Tools, and Provisioning Tools.

## Transformative Features

### Tiered Mastery
- **Tier-1 (DevOps Nirvana)**: Embark on your DevOps journey with Tier-1, the cornerstone of ArmyKnife. It lays the foundation with a suite of powerhouse tools including Hashicorp Vault, Ansible, Geodesic, and the ELK Stack. Automated with Makefiles alongside versatile shell and Python scripts, setting up Tier-1 paves the path to an exhilarating DevOps development adventure.
- **Tier-2 (DevSecOps Evolution)**: Elevate your setup with Tier-2, the realm where CI/CD platforms come alive. Discover the seamless integration of Gitlab, Gitea (a GitHub Actions Clone), and Jenkins, complemented by Minikube for local development. Connect your CI/CD platform to the cloud with ease, and watch your DevSecOps capabilities soar.
- **Tier-3 (CyberSecurity Frontier)**: Apply your DevOps prowess to the cybersecurity domain in Tier-3. This tier empowers you to automate and remediate pentesting and vulnerability challenges, transforming your cybersecurity efforts with DevOps agility.

### Scalability and Isolation
- ArmyKnife is engineered for versatility, scaling effortlessly from small projects to large enterprises. With initial setups leveraging Virtualbox and Vagrant and the potential to scale up with ProxMox, the sky's the limit.
- Enjoy the freedom of developing and testing in a dedicated environment, ensuring your production systems remain untouched and secure.

## Getting Started Made Simple

### Prerequisites
- Embrace the full ArmyKnife experience on Intel-based Mac or Ubuntu systems. While Arm-based Macs are compatible with most features, Virtualbox exclusions apply. Vagrant offers a seamless alternative for these cases.

1. Login to your Docker Hub account so you can push images.
2. Copy env_sample.txt to .env and fill out settings so you can run the setup-git make target.
3. After setup-workstation is completed install ansible with brew.
4. Before running kubespray update the subnet in the Vagrantfile to match yours. Line 53
5. Before running Kubespary update line 213 with your network interface ip range. mine is 192.168.1

### Quick Installation Guide
1. Kickstart your journey by forking the repository.
2. Transition `env_sample.txt` to `.env` and infuse it with your GitHub essence.
3. Secure your vault's root and unseal tokens, crucial keys to your ArmyKnife kingdom.
4. Forge a GitHub Personal Access Token (PAT) to unlock the full potential of your development environment.
5. Embrace the ethos of ArmyKnife by forking the repository, crafting a domain for your scripts within the communal and personal script sanctuaries.
6. Stay connected with the source of ArmyKnife's evolution by setting an upstream to the original repository.
7. Navigate the beta waters of ArmyKnife, where complexity and size birth groundbreaking opportunities and challenges alike.
8. Initiate your conquest with `make import_ova`, summoning the Bitnami VirtualBoxes to your realm.
9. Prioritize the ELK server's ascent, a beacon that illuminates the path by capturing logs across servers, simplifying the troubleshooting odyssey.

## Usage Unleashed
ArmyKnife is not just a tool; it's your DevOps ally. With comprehensive guides on harnessing its power for everyday tasks, your journey from novice to guru is just beginning.

## Contribute to the Evolution
Join the vibrant ArmyKnife community in its continuous quest for improvement. Your contributions, whether code, documentation, or ideas, fuel the project's relentless innovation.

## Unrivaled Support and Enlightenment
- Encounter a challenge? The ArmyKnife community is here to help. Reach out through our GitHub issue tracker.
- Seek wisdom? Our documentation is a treasure trove of knowledge, waiting to be explored.

## License to Innovate
ArmyKnife is your canvas, offered under a license that encourages innovation. Dive into the details in our [LICENSE](LICENSE) document.

## A Tribute to Pioneers
In our journey, we stand on the shoulders of giants. ArmyKnife is a testament to the spirit of collaboration and innovation, acknowledging every contributor and third-party library that has illuminated our path.
