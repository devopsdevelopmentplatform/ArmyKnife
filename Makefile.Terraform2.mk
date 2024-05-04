.PHONY: all install tfsec tflint terrascan checkov kics infracost driftctl pike

# Set the default target to run all tests
all: tfsec tflint terrascan checkov kics infracost driftctl pike

# Install all necessary tools
install:
	@echo "Installing all necessary tools..."
	go install github.com/Fugue/regula@latest

# tfsec target
tfsec:
	@echo "Running tfsec..."
	command -v tfsec || curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install.sh | sh
	tfsec .

# tflint target
tflint:
	@echo "Running tflint..."
	command -v tflint || brew install tflint
	tflint

# terrascan target
terrascan:
	@echo "Running terrascan..."
	command -v terrascan || brew install terrascan
	terrascan scan

# checkov target
checkov:
	@echo "Running checkov..."
	command -v checkov || pip install checkov
	checkov -d .

# kics target
kics:
	@echo "Running KICS..."
	command -v kics || npm install -g @checkmarx/kics
	kics scan --path .

# infracost target
infracost:
	@echo "Running infracost..."
	command -v infracost || (brew tap infracost/infracost && brew install infracost)
	infracost breakdown --path . --format table

# driftctl target
driftctl:
	@echo "Running driftctl..."
	command -v driftctl || curl -fsSL https://driftctl.com/install.sh | bash
	driftctl scan

# pike target
pike:
	@echo "Running Pike..."
	command -v pike || go install github.com/Fugue/regula@latest
	pike run -f .

