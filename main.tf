terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "http" {}

variable "jira_token" {
  description = "Jira token from env"
  type        = string
  sensitive   = true
  default     = ""
}

resource "null_resource" "jira_get_transitions" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Fetching transitions..."
      curl -X GET https://izeno-devops-0325.atlassian.net/rest/api/3/issue/MSD-2/transitions \
        -H "Authorization: Basic ${var.jira_token}" \
        -H "Content-Type: application/json"
    EOT
  }
}

resource "null_resource" "jira_change_transitions" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Fetching transitions..."
      curl -X POST https://izeno-devops-0325.atlassian.net/rest/api/2/issue/MSD-2/transitions \
        -H "Authorization: Basicc ${var.jira_token}" \
        -H "Content-Type: application/json" \
        -d '{"transition": {"id": 21}}'
    EOT
  }
}



resource "local_file" "example" {
  filename = "hello_terraform2.txt"
  content  = "This file was created by Terraform!!"
}

variable "username" {
  description = "The username to greet"
  type        = string
  default     = "Ferdinand"
}

output "hello_message" {
  value = "Hello World ${var.username}"
}

