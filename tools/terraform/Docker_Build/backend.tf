terraform {
  backend "s3" {
    bucket  = "fatporkrinds-s3-terraform-state"
    encrypt = true
    key     = "terraform/state"
    region  = "us-east-1"
  }
}
