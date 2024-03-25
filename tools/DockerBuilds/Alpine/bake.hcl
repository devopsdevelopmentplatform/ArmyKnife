variable "REGISTRY" {
  default = ""
}

variable "REGISTRY_DOCKER" {
  default = ""
}
variable "REGISTRY_QUAY" {
  default = ""
}

group "default" {
  targets = ["alp-3-18"]
}

group "ubuntu" {
  targets = ["ubuntu-base"]
}

group "golang" {
  targets = ["go-1-22"]
}

group "alpine" {
  targets = ["alp-3-18"]
}

target "go-1-19" {
  dockerfile = "./Dockerfile"
  tags = ["fatporkrinds/golang:1.19", "fatporkrinds/golang:1.19-alpine"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    IMAGE = "golang:1.19.3-alpine3.16"
  }
}

target "go-1-18" {
  dockerfile = "./Dockerfile"
  tags = ["fatporkrinds/golang:1.18", "fatporkrinds/golang:1.18-alpine"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    IMAGE = "golang:1.18.7-alpine3.16"
  }
}

target "go-1-17" {
  dockerfile = "./Dockerfile"
  tags = ["fatporkrinds/golang:1.17", "fatporkrinds/golang:1.17-alpine"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    IMAGE = "golang:1.17-alpine3.14"
  }
}

target "go-1-22" {
  dockerfile = "./Dockerfile.alpine"
  tags = ["quay.io/fatporkrinds/golang:1.22.1-alpine3.18"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    IMAGE = "golang:1.22.1-alpine3.18"
  }
}


target "alp-3-18" {
  inherits = ["image"]
  dockerfile = "./Dockerfile.alpine"
  tags = ["docker.io/fatporkrinds/alpine:3.18.6-custom"]
  platforms = ["linux/amd64", "linux/arm64"]
  args = {
    IMAGE = "docker.io/fatporkrinds/alpine:3.18.6"
  }
}

target "image" {
 context = "."
 dockerfile = "Dockerfile.alpine"
 cache-from = ["type=registry,ref=docker.io/fatporkrinds/alpine:3.18.6"]
 cache-to = ["type=inline"]
 labels = {
   "org.opencontainers.image.title" = "alpine:3.18.6"
   "org.opencontainers.image.ref" = "https://docker.io/fatporkrinds/alpine:3.18.6"   
   "org.opencontainers.image.description" = "Alpine Base Docker Image",
   "org.opencontainers.image.url" = "https://docker.io/fatporkrinds/alpine:3.18.6",
   "org.opencontainers.image.source" = "https://docker.io/fatporkrinds/alpine:3.18.6",
   "org.opencontainers.image.version" = "0.1.0",
   "org.opencontainers.image.created" = "2023-10-03T00:30:00.000Z",
   "org.opencontainers.image.revision" = "20231003",
   "org.opencontainers.image.licenses" = "MIT"
 }
 output = ["type=registry"]
}
