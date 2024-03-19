# Define the directory structure for libraries
LIBRARIES_DIR := libraries
BASH_DIR := $(LIBRARIES_DIR)/bash
PYTHON_DIR := $(LIBRARIES_DIR)/python
GO_DIR := $(LIBRARIES_DIR)/go
RUST_DIR := $(LIBRARIES_DIR)/rust


# Define the initial version (adjust as needed)
INITIAL_VERSION := 0.1.0

# Define the target version file (used to store and increment the version)
VERSION_FILE := VERSION

# Targets
.PHONY: create-libraries create-version-files increment-version-file verify-version-file push-libraries


create-libraries:
	mkdir -p $(BASH_DIR) $(PYTHON_DIR) $(GO_DIR) $(RUST_DIR)
	touch $(LIBRARIES_DIR)/.gitkeep
	git add $(LIBRARIES_DIR)/.gitkeep


create-version-files:
	@for dir in $(BASH_DIR) $(PYTHON_DIR) $(GO_DIR) $(RUST_DIR); do \
		if [ ! -f $$dir/$(VERSION_FILE) ]; then \
			echo $(INITIAL_VERSION) > $$dir/$(VERSION_FILE); \
			git add $$dir/$(VERSION_FILE); \
			echo "Created and staged $(VERSION_FILE) in $$dir"; \
		fi; \
	done

increment-version-file:
	@for dir in $(BASH_DIR) $(PYTHON_DIR) $(GO_DIR) $(RUST_DIR); do \
		if [ -f $$dir/$(VERSION_FILE) ]; then \
			CURRENT_VERSION=$$(cat $$dir/$(VERSION_FILE)); \
			MAJOR=$$(echo $$CURRENT_VERSION | cut -d. -f1); \
			MINOR=$$(echo $$CURRENT_VERSION | cut -d. -f2); \
			PATCH=$$(echo $$CURRENT_VERSION | cut -d. -f3); \
			if [ "$(INCREMENT)" = "major" ]; then \
				NEW_VERSION="$$((MAJOR + 1)).0.0"; \
			elif [ "$(INCREMENT)" = "minor" ]; then \
				NEW_VERSION="$$MAJOR.$$((MINOR + 1)).0"; \
			else \
				NEW_VERSION="$$MAJOR.$$MINOR.$$((PATCH + 1))"; \
			fi; \
			echo $$NEW_VERSION > $$dir/$(VERSION_FILE); \
		else \
			echo "$(VERSION_FILE) not found in $$dir. Run make create-version-files first."; \
		fi; \
	done

# Manual Testing
verify-version-file:
	@if [ -f $(VERSION_FILE) ]; then \
		CURRENT_VERSION=$$(cat $(VERSION_FILE)); \
		if echo $$CURRENT_VERSION | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$$'; then \
			echo "$(VERSION_FILE) is valid: $$CURRENT_VERSION"; \
		else \
			echo "$(VERSION_FILE) contains an invalid version: $$CURRENT_VERSION"; \
			exit 1; \
		fi; \
	else \
		echo "$(VERSION_FILE) not found."; \
		exit 1; \
	fi

push-libraries:
	@for dir in $(BASH_DIR) $(PYTHON_DIR) $(GO_DIR) $(RUST_DIR); do \
		echo "Checking $$dir for changes"; \
		if [ -n "$$(git -C $$dir status --porcelain)" ]; then \
			git -C $$dir add .; \
			echo "Changes detected in $$dir"; \
			NEW_VERSION=$$(cat $$dir/$(VERSION_FILE)); \
			MAJOR=$$(echo $$NEW_VERSION | cut -d. -f1); \
			MINOR=$$(echo $$NEW_VERSION | cut -d. -f2); \
			PATCH=$$(echo $$NEW_VERSION | cut -d. -f3); \
			NEW_VERSION="$$MAJOR.$$MINOR.$$((PATCH + 1))"; \
			echo $$NEW_VERSION > $$dir/$(VERSION_FILE); \
			git -C $$dir add $(VERSION_FILE); \
			git -C $$dir commit -S -m "Increment version in $$dir to $$NEW_VERSION"; \
			LIBRARY_NAME=$$(basename $$dir); \
			git -C $$dir tag "$${LIBRARY_NAME}_v$$NEW_VERSION"; \
		else \
			echo "No changes in $$dir"; \
		fi; \
	done
	git push origin main --tags
