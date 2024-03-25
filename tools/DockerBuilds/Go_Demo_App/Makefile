# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get

# Main package name
MAIN=main.go

# Binary names
BINARY_NAME=myapp

# Versioning
VERSION=1.0.0

# Build flags
LDFLAGS=-ldflags "-X main.Version=$(VERSION)"

all: clean test build

build:
	$(GOBUILD) $(LDFLAGS) -o $(BINARY_NAME) $(MAIN)

test:
	$(GOTEST) ./...

clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)

run:
	$(GOBUILD) $(LDFLAGS) -o $(BINARY_NAME) $(MAIN)
	./$(BINARY_NAME)

.PHONY: all build test clean run
