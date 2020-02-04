##./main.tf
# terraform {
#   backend "s3" {
#     bucket = "tf-wallet-state"
#     key    = "engineering/terraform.tfstate"
#     region = "us-west-2"
#   }
# }

# provider "aws" {
#   version                 = "2.46.0"
#   shared_credentials_file = "$HOME/.aws/credentials"
#   profile                 = "yaka"
#   region                  = "us-east-1"
# }

# data "terraform_remote_state" "engineering" {
#   backend = "s3"
#   config  = {
#     bucket = "tf-wallet-state"
#     key    = "engineering/terraform.tfstate"
#     region = "us-west-2"
#   }
# }
terraform {
  backend "local" {}
}

provider "aws" {
  version = "2.46.0" 
  region = "us-east-1"
  profile = "terraform-test"
}

module "vpc" {
  source = "./vpc"
  name = "n-tier-app"
}

module "gitlab_runners" {
  source = "./ci-runners"

  private_subnets = module.vpc.private_subnets
  registration_token = "thisisatoken"
  timezone = "America/New_York"
  vpc_id = module.vpc.vpc_id
}