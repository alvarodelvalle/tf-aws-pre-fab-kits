# ---------------------------------------------------------------------------------------------------------------------
# Without Defaults
# ---------------------------------------------------------------------------------------------------------------------

variable "registration_token" {
    description = "The GitLab Runner registration token"
}

variable "timezone" {
    description = "The Timezone for registering GitLab runners eg America/New_York"
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

variable "cache_bucket" {
    description = "The cache location for runners to use"
}
# ---------------------------------------------------------------------------------------------------------------------
# With Defaults
# ---------------------------------------------------------------------------------------------------------------------
variable "docker_machine_spot_price_bid" {
    description = "Spot price bid."
    type        = string
    default     = "0.06"
}

variable "gitlab_url" {
    description = "URL of the gitlab instance to connect to."
    type        = string
    default     = "https://gitlab.com"
}

variable "gitlab_runner_tag_list" {
    description = "The gitlab runners' tags as defined by 'tags:' in pipeline config"
    type = string
    default = "gid-group-runner, docker-spot-runner"
}
# ---------------------------------------------------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------------------------------------------------