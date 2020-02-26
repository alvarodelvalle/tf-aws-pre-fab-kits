# ---------------------------------------------------------------------------------------------------------------------
# Without Defaults
# ---------------------------------------------------------------------------------------------------------------------

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

# ---------------------------------------------------------------------------------------------------------------------
# With Defaults
# ---------------------------------------------------------------------------------------------------------------------
variable "docker_machine_spot_price_bid" {
    description = "Spot price bid."
    type        = string
    default     = "0.06"
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------------------------------------------------