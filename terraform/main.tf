terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.6"
    }
  }

  cloud {
    organization = "THORIET-CLOUD"

    workspaces {
      name = "devops-course-terraform"
    }
  }
}

resource "local_file" "example" {
  filename = var.filename
  content  = var.message
}

resource "local_file" "summary" {
  filename = "summary.txt"
  content  = <<EOF
Created file: ${local_file.example.filename}
ID: ${local_file.example.id}
EOF
}