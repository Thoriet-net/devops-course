terraform {
  required_version = ">= 1.5.0"

  required_providers {
  random = {
    source  = "hashicorp/random"
    version = "~> 3.6"
  }
}

  cloud {
    organization = "THORIET-CLOUD"

    workspaces {
      name = "devops-course-terraform"
    }
  }
}

resource "random_pet" "name" {
  length = 2
}

resource "random_id" "suffix" {
  byte_length = 4
}