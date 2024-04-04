# ArmyKnife DevOps CI/CD Framework Development Environment Tier1
![ArmyKnife Logo](ArmyKnife.png)

[![GitHub license](https://img.shields.io/github/license/devopsdevelopmentplatform/repository.svg)](https://github.com/username/repository/blob/master/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/devopsdevelopmentplatform/repository.svg)](https://github.com/username/repository/issues)
[![GitHub stars](https://img.shields.io/github/stars/devopsdevelopmentplatform/repository.svg)](https://github.com/username/repository/stargazers)


## Project for "Makefiles for Cloud/DevOps Engineers"

## Exciting Overview
Dive into the cutting-edge world of DevOps with ArmyKnife, an innovative, open-source project meticulously designed to empower DevOps engineers. ArmyKnife offers a robust, self-contained development environment that revolutionizes the way tools and scripts are developed and tested. Say goodbye to the dependency on cloud or production resources! Crafted with precision, ArmyKnife unfolds in three distinct tiers, each tier specifically architected to streamline management and support, ushering in a new era of efficient and optimized DevOps practice. We cover all five areas of IaC. Ad-Hoc Scripts, Configuration Managment tools, Server Templating Tools,
Orchestration Tools, and Provisioning Tools.

Here is the short list of tools we are presenting in this platform. This will probably change but here it is for now. 

1. **Ansible**: Ansible is a powerful automation tool that simplifies the process of managing configurations and orchestrating deployments across various systems. Its importance in DevOps lies in its ability to streamline repetitive tasks, enforce consistency in infrastructure, and facilitate continuous delivery. By utilizing Ansible within ArmyKnife, users can learn how to automate provisioning, configuration management, and application deployment, thus enhancing their efficiency as DevOps practitioners.

2. **Continuous Integration and Continuous Deployment (CICD) Platforms**: Platforms like GitHub Actions, GitHub, Jenkins, and Bitbucket are essential components of a DevOps pipeline, enabling seamless integration, testing, and deployment of code changes. ArmyKnife provides comprehensive guidance and examples on configuring and optimizing CICD workflows using these platforms, empowering users to implement efficient automation practices and foster collaboration within their teams.

3. **Docker**: Docker revolutionized the way applications are deployed and managed by providing lightweight, portable containers. In the context of DevOps, Docker facilitates consistent environments across development, testing, and production, leading to smoother workflows and faster deployments. ArmyKnife equips users with the knowledge and tools to leverage Docker for containerization, enabling them to build, ship, and run applications efficiently in any environment.

4. **ELK Stack**: The ELK (Elasticsearch, Logstash, Kibana) Stack is a powerful combination of tools for log management and analytics. DevOps teams rely on ELK for monitoring and troubleshooting applications, infrastructure, and security incidents. ArmyKnife offers guidance on setting up and configuring the ELK Stack, enabling users to gain valuable insights into their systems and improve their overall operational efficiency.

5. **Geodesic**: Geodesic is a cloud automation shell that provides a consistent environment for DevOps workflows across different cloud providers. By incorporating Geodesic into ArmyKnife, users can learn how to standardize their development and deployment processes, ensuring portability and scalability across diverse cloud environments.

6. **Git and Source Code Management**: Git is the de facto standard for version control and source code management in DevOps. ArmyKnife emphasizes the importance of Git proficiency for collaboration, versioning, and tracking changes in codebases. Through comprehensive tutorials and examples, users can master Git workflows and best practices, fostering efficient collaboration and code management within their teams.

7. **Kubernetes (K8s) Clusters**: Kubernetes has become the industry standard for container orchestration, enabling automated deployment, scaling, and management of containerized applications. ArmyKnife provides comprehensive resources for setting up and managing Kubernetes clusters, empowering users to harness the full potential of containerization and microservices architecture in their DevOps workflows.

8. **Packer from HashiCorp**: Packer is a tool for creating identical machine images for multiple platforms from a single source configuration. ArmyKnife demonstrates the importance of Packer in building consistent, reproducible infrastructure images, which are essential for maintaining uniformity across development, testing, and production environments.

9. **Python**: Python is a versatile programming language widely used in DevOps for automation, scripting, and building infrastructure as code. ArmyKnife offers tutorials and examples on using Python for various DevOps tasks, empowering users to automate workflows, develop custom tooling, and integrate with other technologies effectively.

10. **DevSecOps**: DevSecOps integrates security practices into the DevOps pipeline, ensuring that security is built into every stage of the software development lifecycle. ArmyKnife promotes a security-first mindset by providing guidance on implementing security controls, vulnerability scanning, and compliance automation within DevOps workflows, thus fostering a culture of continuous security improvement.

11. **Terraform**: Terraform is a popular infrastructure as code tool for provisioning and managing cloud resources. ArmyKnife demonstrates the importance of Terraform in achieving infrastructure automation, enabling users to define infrastructure configurations as code and provision resources reliably across different cloud platforms.

12. **Vagrant**: Vagrant simplifies the setup and management of development environments by providing lightweight, reproducible VMs. ArmyKnife showcases the versatility of Vagrant for creating consistent development environments, enabling users to quickly spin up isolated environments for testing and development purposes.

13. **Vault from HashiCorp**: Vault is a tool for managing secrets and protecting sensitive data in modern infrastructure. ArmyKnife highlights the critical role of Vault in securing credentials, API keys, and other sensitive information, empowering users to implement robust security practices and compliance standards within their DevOps workflows.

14. **VirtualBox**: VirtualBox is a powerful virtualization platform that enables users to run multiple operating systems on a single host machine. ArmyKnife demonstrates the utility of VirtualBox for creating isolated development environments, enabling users to experiment, test, and debug their applications in a controlled environment before deployment.

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

1. log in to your Docker Hub account so you can push images.
2. Copy `env_sample to .env so that the makefiles can find your secrets file
3. run make setup-workstation
4. You may have to run make setup-workstation several times because of the configuration that is added to ~/.bashrc
5. Reboot to enable docker and a few other settings.
6. Run make help to run some of the tools
7. Make sure to fill out your username and email before running make git-setup
8. Working on documenting install orders so that dependencies are satisfied. For example, install the local docker registry before building docker images.
