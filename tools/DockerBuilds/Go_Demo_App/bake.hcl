variable "REGISTRY" {
  default = "docker.io"
}

variable "GO_VERSION" {
  default = "1.22.1"
}

variable "ALPINE_VERSION" {
  default = "3.18.6"
}

variable "CUSTOM_TAG" {
  default = "latest"
}

group "default" {
  targets = ["alpine-base", "go-app"]
}

target "alpine-base" {
  context = "."
  dockerfile = "Dockerfile.alpine"
  tags = ["fatporkrinds/alpine:${ALPINE_VERSION}-custom"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    ALPINE_VERSION = "${ALPINE_VERSION}"
    IMAGE = "docker.io/fatporkrinds/alpine:${ALPINE_VERSION}"
  }
  cache-from = ["type=registry,ref=quay.io/fatporkrinds/alpine:${ALPINE_VERSION}-custom"]
  cache-to = ["type=inline"]
  labels = {
    "org.opencontainers.image.title" = "alpine:${ALPINE_VERSION}"
    "org.opencontainers.image.description" = "Alpine Base Docker Image",
    "org.opencontainers.image.version" = "${CUSTOM_TAG}",
    "org.opencontainers.image.licenses" = "MIT"
  }
  output = ["type=registry"]
}

target "go-app" {
  inherits = ["alpine-base"]
  context = "."
  dockerfile = "Dockerfile"
  tags = ["fatporkrinds/golang-app:${GO_VERSION}-alpine-${ALPINE_VERSION}"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    GO_VERSION = "${GO_VERSION}",
    ALPINE_VERSION = "${ALPINE_VERSION}"
  }
  cache-from = ["type=registry,ref=docker.io/fatporkrinds/alpine:${ALPINE_VERSION}-custom"]
  cache-to = ["type=inline"]
  labels = {
    "org.opencontainers.image.title" = "Go Application",
    "org.opencontainers.image.description" = "A Go application based on Alpine",
    "org.opencontainers.image.version" = "${CUSTOM_TAG}",
    "org.opencontainers.image.licenses" = "MIT"
  }
  output = ["type=registry"]
}
