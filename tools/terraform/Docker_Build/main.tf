provider "aws" {
  region = var.region
}

data "docker_registry_image" "fattoolbox" {
  name = "quay.io/fatporkrinds/fat-tool-box"
}

resource "docker_image" "fattoolbox" {
  name          = data.docker_registry_image.fattoolbox.name

  build {
    context    = "."
    dockerfile = "Dockerfile" 
    tag        = ["quay.io/fatporkrinds/fat-tool-box:develop"]
    no_cache = false 
    remove   = true  
    force_remove = true  
    label = {
      author  = "fatporkrinds@gmail.com"
      project = "ArmyKnife"
    }
  }
  

}

