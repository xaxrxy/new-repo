provider "local" {}

resource "local_file" "example" {
  filename = "hello_terraform.txt"
  content  = "This file was created by Terraform!"
}