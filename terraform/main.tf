terraform {
  required_version = ">= 1.5.0"
}

resource "local_file" "example" {
  filename = "hello.txt"
  content  = "Hello again from Terraform\n"
}