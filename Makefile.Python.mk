# Variables
VENV_NAME?=venv
VENV_DIR?=./.$(VENV_NAME)
PYTHON=${VENV_DIR}/bin/python
PIP=${VENV_DIR}/bin/pip

# By default, set up the virtual environment and install dependencies
.DEFAULT_GOAL := all
# Create virtual environment
venv:
	test -d $(VENV_DIR) || python3 -m venv $(VENV_DIR)

# Setup the virtual environment with necessary packages
setup: venv
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt
	# Install development tools
	$(PIP) install black pylint pytest mypy isort pylama flake8 radon mccabe bandit

# OLD CONFIG NEEDS TO BE DELETED
config:
	cp config/config.example.json config/config.json
	python3 cli_tool/fprcli.py push-config --config-path config/config.json

# Format code with Black and isort
format:
	$(VENV_NAME)/bin/black .
	$(VENV_NAME)/bin/isort .

# Lint code with multiple tools
python-lint:
	$(VENV_NAME)/bin/pylint $1
	$(VENV_NAME)/bin/flake8 .
	$(VENV_NAME)/bin/isort --check-only .
	$(VENV_NAME)/bin/bandit -r .
	$(VENV_NAME)/bin/pylama

# Run tests with pytest
test:
	$(VENV_NAME)/bin/pytest

# Type checking with Mypy
typecheck:
	$(VENV_NAME)/bin/mypy $1

# Clean up the virtual environment and other generated files
clean:
	rm -rf $(VENV_NAME)
	find . -name "*.pyc" -exec rm {} \;
	find . -name "__pycache__" -exec rm -r {} \;

.PHONY: all venv setup install format python-lint test typecheck clean config
