# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  backend "remote" {
    organization = "Tu-Demo"

  workspaces {
      name = "nomad-consul-cluster"
    }
  }
  required_version = ">= 0.12.26"
}

provider "aws" {
  alias = "west"
  region = "us-west-2"
}

