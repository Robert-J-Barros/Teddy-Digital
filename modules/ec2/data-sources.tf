# Arquivo data-sources.tf (leitura dos outputs da VPC)
data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../networking/terraform.tfstate"
  }
}