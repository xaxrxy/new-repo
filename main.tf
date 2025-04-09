provider "null" {}

resource "null_resource" "example" {}

output "test_output" {
  value = "Plan executed successfully!"
}