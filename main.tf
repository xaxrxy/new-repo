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

variable "TF_JIRA_TOKEN" {
  description = "Token for Jira auth"
  type        = string
  sensitive   = true
}


locals {
  effective_jira_token = var.jira_token != "" ? var.jira_token : var.TF_JIRA_TOKEN
}

resource "null_resource" "jira_get_transitions" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<EOT
      echo "Fetching transitions..."
      curl -X GET https://izeno-devops-0325.atlassian.net/rest/api/3/issue/MSD-2/transitions \
        -H "Authorization: Basic ${local.effective_jira_token}" \
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
        -H "Authorization: Basic ${local.effective_jira_token}" \
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
  default     = ""
}

variable "JIRA_ISSUE_KEY" {
  description = "Issuekey for updating the issue"
  type        = string
}

locals {
  effective_jira_username = var.username != "" ? var.username : var.JIRA_ISSUE_KEY
}

output "hello_message" {
  value = "Hello World ${local.effective_jira_username}"
}


