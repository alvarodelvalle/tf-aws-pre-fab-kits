#./ci-runners/variables.tf
variable "registration_token" {
    description = "The GitLab Runner registration token"
}

variable "timezone" {
    description = "The Timezone for registering GitLab runners"
}

variable "vpc_id" {
    description = "The AWS VPC ID"
}

variable "private_subnets" {
    description = "The VPC private subnets in which to host runners"
}