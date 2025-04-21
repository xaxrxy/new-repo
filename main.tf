terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

variable "username" {
  description = "The username to greet"
  type        = string
}

output "hello_message" {
  value = "Hello World ${var.username}"
}

provider "http" {}

resource "local_file" "example" {
  filename = "hello_terraform.txt"
  content  = "This file was created by Terraform!!"
}


resource "null_resource" "jira_post_request" {
   provisioner "local-exec" {
     command = <<EOT
       set -e
       echo "Sending POST request to JIRA..."
       RESPONSE=$(curl -s -w "\\nHTTP_STATUS_CODE:%{http_code}" -X POST https://izeno-devops-0325.atlassian.net/rest/api/2/issue/MSD-2/transitions \
         -H "Authorization: Basic YXJ5LnN1d2FuZGlAaXplbm8uY29tOkFUQVRUM3hGZkdGMDY2YUpTVW4tcVk1OFJJLWhZSUVuejk2a2I1X1pueXhpbmc2QXFDOG5qOUFaV1RQY0ZZUTJYOXBPdE93U0sxWktRVXlaTGFZdHFGTDVFSFNqZVZTdndmcWtTRjZxak5YS3cxVXhyN25Say03Qzl5MWJUVW5WYjF0VHdPUzlBb2M2akJ3ZzBZb18tS3Vfa3ZSZFJBY21uTnBRRUljOEI2YTRhaWxxaUJuT19BVT0yRThCQjY3OA==" \
         -H "Content-Type: application/json" \
         -d '{"transition": {"id": 21}}')
       echo "$RESPONSE"
     EOT
   }
}

data "external" "git_commit" {
  program = ["bash", "-c", <<EOT
    COMMIT_MSG=$(git log -1 --pretty=%B 2>/dev/null | tr -d '\n' | sed 's/\"/\\"/g')
    if [ -z "$COMMIT_MSG" ]; then
      echo "{\"message\": \"No commit found\"}"
    else
      echo "{\"message\": \"$COMMIT_MSG\"}"
    fi
  EOT
  ]
}

output "current_commit_message" {
  value = data.external.git_commit.result.message
}


