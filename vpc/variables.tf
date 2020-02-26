# ---------------------------------------------------------------------------------------------------------------------
# Without Defaults
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of the VPC"
}

variable "registration_token" {
  description = "The GitLab Runner registration token"
}

variable "timezone" {
  description = "The Timezone for registering GitLab runners eg America/New_York"
}

variable "vpc_id" {
  description = "The AWS VPC ID"
}

variable "private_subnets" {
  description = "The VPC private subnets in which to host runners"
}

variable "provider_region" {
  description = "The AWS region eg: us-east-1 for the provider block"
}

variable "provider_version" {
  description = "The AWS provider version to use eg: 2.47.0"
}

variable "aws_profile" {
  description = "The credential profile to use to call AWS API's"
}

variable "region" {
  description = "The region to deploy to"
}

variable "environment" {
  description = "Identifies the environment, used as prefix and for tagging."
}

variable "runners_name" {
  description = "Name of the runner, will be used in the runner config.toml."
}

variable "gitlab_group" {
  description = "Group of projects in GitLab"
}

variable "backend_bucket" {}

variable "backend_key" {}

variable "backend_region" {}

# ---------------------------------------------------------------------------------------------------------------------
# With Defaults
# ---------------------------------------------------------------------------------------------------------------------
variable "dhcp_options_enabled" {
  description = "Enables VPC DHCP options for custom domain names"
  default = false
  type = bool
}

variable "dhcp_options_domain_name_servers" {
  default = ""
  type = list(string)
}

variable "dhcp_options_domain_name" {
  default = ""
}

variable "create_database_subnet_group" {
  default = false
  type = bool
}

variable "enable_nat_gateway" {
  default = true
  type = bool
}

variable "single_nat_gateway" {
  default = true
  type = bool
}

variable "one_nat_gateway_per_az" {
  default = false
  type = bool
}

variable "enable_vpn_gateway" {
  default = false
  type = bool
}

variable "enable_s3_endpoint" {
  default = false
  type = bool
}

variable "enable_dynamodb_endpoint" {
  default = false
  type = bool
}

variable "tags" {
  type = object({
    Owner = number
    Environment = string
    Name = string
  })
}
# ---------------------------------------------------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------------------------------------------------