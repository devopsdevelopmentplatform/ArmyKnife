provider "aws" {
  region = var.region
}

data "docker_registry_image" "fattoolbox" {
  name = "quay.io/fatporkrinds/fat-tool-box"
}

#resource "docker_image" "fattoolbox" {
#  name          = data.docker_registry_image.fattoolbox.name
#  pull_triggers = [data.docker_registry_image.fattoolbox.sha256_digest]
#}


resource "docker_image" "fattoolbox" {
  name = "quay.io/fatporkrinds/fat-tool-box:dev"

  build {
    context    = "."
    dockerfile = "Dockerfile" # Specifies the name of the Dockerfile. Default is "Dockerfile".
    #target     = "production" # Specifies the target build stage to build in multi-stage Docker builds.
    tag        = ["quay.io/fatporkrinds/fat-tool-box:develop"]
    #pull     = true  # Always attempt to pull a newer version of the base image.
    #no_cache = false # Do not use cache when building the image.
    #remove   = true  # Remove intermediate containers after a successful build.
    #force_rm = true  # Always remove intermediate containers.
    #docker_registry_image = true
    label = {
      author  = "fatporkrinds@gmail.com"
      project = "ArmyKnife"
    }

  }
}

