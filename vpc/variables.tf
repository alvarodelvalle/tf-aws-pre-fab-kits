# ---------------------------------------------------------------------------------------------------------------------
# Without Defaults
# ---------------------------------------------------------------------------------------------------------------------
variable "name" {
  description = "The name of the VPC"
}

variable "timezone" {
  description = "The Timezone for registering GitLab runners eg America/New_York"
}

variable "vpc_id" {
  description = "The AWS VPC ID"
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