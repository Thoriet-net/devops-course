terraform {
  required_version = ">= 1.5.0"
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