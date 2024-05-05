# What is ArmyKnife?

![ArmyKnife](ArmyKnife.png){ border-effect="line" thumbnail="true" width="321"}

ArmyKnife is a DevOps Development Platform for Linux and MacOS.

## How and why was it created?

I started creating a class on Makefiles to teach how to create and use them because I felt they were not being utilized 
in the DevOps world as much as they should. Then one thing led to another and pretty soon an entire platform was born.

## Why not just sit down and write code? Why is all this needed?

When I was creating the Makefile class, I went to start writing some code to show students how to create Makefiles,
and I realized I was missing dependencies. For example, how can you write Terraform code that reaches out to Vault and
a Kubernetes cluster if it does not exist on your local? Your probably thinking "My Company provides a Dev Environment
for this kind of stuff". That is really great for you but not all of us have that luxury. You should always test everything
thoroughly before pushing up code. You should not depend on CI/CD to do all your work for you. This puts too much strain
on the process and is a domino effect that creates work for other Team Members.

## What is included in ArmyKnife?

Here are the current Makefiles and the status of each. So far if it says "Done", then it is working on Linux and MacOS.


- include Makefile.Libs.mk # Done and Stable on Linux Not tested on MacOS
- include Makefile.Vault.mk # Done Stable on Linux and MacOS
- include Makefile.Git.mk # Done Stable on Linux and MacOS
- include Makefile.K8s.mk # Done Stable on Linux and MacOS
- include Makefile.VBox.mk # Done on Linux, Needs work on MacOS
- include Makefile.Workstation.mk # Done stable on Linux and MacOS
- include Makefile.Vagrant.mk # Done stable on Linux and MacOS
- include Makefile.Geodesic.mk # Done Stable on Linux and MacOS
- include Makefile.Docker.mk # Done need to check MacOS
- include Makefile.Python.mk # Done need to check MacOS
- include Makefile.Ansible.mk # Needs more testing
- include Makefile.Terraform.mk # Needs Tested
- include Makefile.Packer.mk # WIP
- include Makefile.CICD.mk # WIP
- include Makefile.Setup.mk # Part of main setup-workstation target
- include Makefile.K8s-Admin.mk # WIP but smoke test is working on Linux
- include Makefile.ELK.mk # WIP
- include Makefile.Security.mk # WIP
- include Makefile.BashLib.mk # Done Stable on Linux and MacOS
- include Makefile.Registry.mk # Done Stable on Linux and MacOS

Many Makefile targets are undocumented and not included in the general setup processes but are vey useful. For example
the ingest-secrets-into-vault Makefile target in the Makefile.Vault.mk file is very handy to take all your secrets in
your .env file and ingest them into vault.

## How was it designed to run and setup everything?

It depends on if your running on Mac or Linux. 75% of the testing has been done on Linux but Mac is working now it just
needs some love and testing.

### Linux Ubuntu Jammy 22.04 LTS

## Tier 1 (DevOps)

1. My recommendation is to create a folder called localprojects on your $HOME root and clone the repo into it.
  ```bash
    mkdir -p $HOME/localprojects
   ```
2. Pull down the repo https://github.com/ArmyKnifeAI/ArmyKnife.git
  ```bash
    cd $HOME/localprojects
    git clone https://github.com/ArmyKnifeAI/ArmyKnife.git
   ```
3. Make sure you have all the dependencies installed. sudo apt-get install make git curl wget jq
4. Copy the env_setup.txt to .env and update yor git username and email.
  ```bash
    cp env_setup.txt .env
   ```
* Edit .env to reflect your username and email for git.

5. Run the first Makefile target setup-workstation like this.
  ```bash
     make setup-workstation
   ```
6. Run the second Makefile target.
  ```bash
     make setup-git
   ```
7. Run the third Makefile target. (This will be incorporated into the main workflow soon.)
  ```bash
     make build-local-registry
   ```
9. Run the fourth Makefile target. When you're done you can run `make connect-to-vault`.
  ```bash
     make seutp-vault
   ```
10. Run the fifth Makefile target. When you're done you can run `make connect-to-geodesic`
```bash
     make build-custom-geodesic
   ```
10. Run the sixth Makefile target. (This will be incorporated in the main Makefile soon)
  ```bash
     make -f Makefile.BashLib.mk all
   ```
12. Run the seventh Makefile target. If you have plenty of RAM and CPU then run kubespray.
  ```bash
     make install-kubepsray or make install-minikube
   ```
* I plan on renaming targets and streamlining the install process with a script. Testing has already started.

### MacOS

## Tier 1 (DevOps)

* MacOS needs a few tools installed Manually before running. I plan to automate this in the future.

1. Install Docker Desktop for MacOS.
2. Install VSCode if you want a front end for the Makefiles.
3. I usually install ITerm2.
4. Follow the instructions for Linux.

## Tier 2 (DevSecOPs)

* Install the Bitnami Virtualbox Version of Jenkins, GitEA, and GitLab along with local runners

## Tier 3 (CyberSecurity)

* Setup VMs for Vulnerability and Penetration testing along with multiple networks to simulate production network connections.



### RoadMap for 2024

![ArmyKnife](FatPorkRinds.png){ border-effect="line" thumbnail="true" width="321"}

- Get all the Makefile targets cleaned up and streamlined so they make more sense.
- Update the help menu so it reflects the install order.
- Get everything working on Linux and MacOS.
- Finish building out the current Makefile targets and add new modern DevOps tools.
- Convert the large makefile targets to Bash, Python, Go, or Rust
- Add Fedora as an option
- Test on Windows with WSL


# Demo Hardware Used

#### Here is the list of hardware used for testing.



[Wo-We Mini PC](https://www.amazon.com/wowe-Excavator-Supports-Pre-Installed-Activation/dp/B0CLRPKC7R/ref=sr_1_4?crid=FJRUBJ50D9V7&dib=eyJ2IjoiMSJ9.9kqemli2As4HNQBmCqmYTUd51ebgFbxOHOjGIjKP9n6yBxEFAyTBOEUZi6I3OwHVqYY0PLAyxyehosdKqM8fhBIo3QcebZWlCEjhf9hJHKmSIn5KfyUbkP_fKUyyHBFv0BJJpc8m9JZFoNv0Gabhw1UAtaFpXIsbfSfaS5zXQAuOQ5U544TlkJI0PYHrgUfsTqS30Yef9CoMTCRuTBZIUo3wkcTXhxGajeH9DdWoyfYzLoQPdcuCJ8qrML-Ui9pBd8bpGgwuDKJartK2j_0ILHgJ6GG9LAK6tklApT-dSe4.WqApNZjB22w8mD7TzWtYkNExrHdwt28pGcHJTsd445Q&dib_tag=se&keywords=wo-we&qid=1713520370&sprefix=wo-we%2Caps%2C116&sr=8-4
){ border-effect="line" thumbnail="true" width="321"}

[Mac Mini 2018](https://www.amazon.com/Apple-3-0GHz-Intel-Storage-Renewed/dp/B0BWGBCGFL/ref=sr_1_9?dib=eyJ2IjoiMSJ9.Ifr3Dte0gXQH4sZT3jMszXqe_n14arC-Zw-IjBANNkWbE27UlbPrAvnRY9umZDO9gFc-sg-o0akQGKrYanDDwiKBjBsR3NUUrDkGaX4-Ruzm8o0-yepIqL-_Oh70le-D5eCEF7gmjN-TVqKTMcK2K1otrcFW_UnyQP3Zaw_wT4EpdL8E7UreEWCADEfssLVHK9qQugUX2z1CKAmbcyzbKY8vz1w4EkK5eQaK1Cjxzow.RG9b3kP3K6GxD7SNAgDnLQS_k3v4_1QJdonzuTcvB9g&dib_tag=se&keywords=2018+Apple+Mac+Mini&qid=1713520501&sr=8-9
){ border-effect="line" thumbnail="true" width="321"}

<seealso>
    <category ref="fpr">
        <a href="https://github.com/ArmyKnifeAI/ArmyKnife/blob/main/README.md">ArmyKnife README.md</a>
    </category>
</seealso>