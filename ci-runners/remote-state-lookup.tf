variable "terraform_state_aws_region" {
  description = "The region where the terraform state lives."
}

variable "terraform_state_s3_bucket" {
  description = "The bucket where the terraform state lives."
}

variable "state_file_key" {
  description = "Location of the state file for the vpc"
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    region = var.terraform_state_aws_region
    bucket = var.terraform_state_s3_bucket
    key    = var.state_file_key
  }
}