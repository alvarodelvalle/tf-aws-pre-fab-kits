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

variable "runners_idle_count" {
    description = "The number of active runners during non-off peak time"
}

# ---------------------------------------------------------------------------------------------------------------------
# With Defaults
# ---------------------------------------------------------------------------------------------------------------------
variable "docker_machine_instance_type"{
    description = "The instance type to run ci builds"
    default = "a1.large"
}

variable "docker_machine_spot_price_bid" {
    description = "Spot price bid; default is set to most recent on-demand price"
    type        = string
    default     = "0.05"
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

variable "gitlab_cache_bucket" {
    default = ""
}

variable "create_cache_bucket" {
    default = false
}
# ---------------------------------------------------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------------------------------------------------