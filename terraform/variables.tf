variable "filename" {
  type        = string
  description = "Output filename"
  default     = "hello.txt"
}

variable "message" {
  type        = string
  description = "File content"
  default     = "Hello from Terraform\n"
}