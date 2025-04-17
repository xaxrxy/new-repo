terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "http" {}

resource "local_file" "example" {
  filename = "hello_terraform.txt"
  content  = "This file was created by Terraform!!"
}

resource "null_resource" "jira_post_request" {
  provisioner "local-exec" {
    command = <<EOT
      curl -X POST https://izeno-devops-0325.atlassian.net/rest/api/2/issue/MSD-2/transitions \
        -H "Authorization: Basic YXJ5LnN1d2FuZGlAaXplbm8uY29tOkFUQVRUM3hGZkdGMDY2YUpTVW4tcVk1OFJJLWhZSUVuejk2a2I1X1pueXhpbmc2QXFDOG5qOUFaV1RQY0ZZUTJYOXBPdE93U0sxWktRVXlaTGFZdHFGTDVFSFNqZVZTdndmcWtTRjZxak5YS3cxVXhyN25Say03Qzl5MWJUVW5WYjF0VHdPUzlBb2M2akJ3ZzBZb18tS3Vfa3ZSZFJBY21uTnBRRUljOEI2YTRhaWxxaUJuT19BVT0yRThCQjY3OA==" \
        -H "Content-Type: application/json" \
        -d '{"transition": {"id": 21}}'
    EOT
  }
}

data "external" "git_commit" {
  program = ["bash", "-c", <<EOT
    echo "{\"message\": \"$(git log -1 --pretty=%B | tr -d '\n' | sed 's/\"/\\"/g')\"}"
  EOT
  ]
}

output "current_commit_message" {
  value = data.external.git_commit.result.message
}
