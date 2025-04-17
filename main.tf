output "hello_world" {
  value = "Hello, Ary"
}

terraform {
  required_providers {
    restapi = {
      source  = "Mastercard/restapi"
      version = "1.18.0"
    }
  }
}

provider "restapi" {
  uri = "https://izeno-devops-0325.atlassian.net"
  headers = {
    Authorization = "Basic ${var.jira_token}"  # base64 encoded "email:api_token"
    Content-Type  = "application/json"
  }
}