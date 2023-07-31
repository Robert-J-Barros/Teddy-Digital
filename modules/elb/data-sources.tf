data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../networking/terraform.tfstate"
  }
}
data "terraform_remote_state" "ec2" {
  backend = "local"

  config = {
    path = "../ec2/terraform.tfstate"
  }
}
