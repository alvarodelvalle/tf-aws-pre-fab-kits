#./ci-runners/main.tf
terraform {
  backend "s3" {}
}

module "gitlab-runner" {
    source  = "npalm/gitlab-runner/aws"
    version = "4.10.0"

  aws_region  = var.region
  environment = var.environment

  runners_name             = var.runners_name
  enable_runner_ssm_access = true
  enable_eip               = true

  vpc_id                        = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_id_runners             = element(data.terraform_remote_state.vpc.outputs.private_subnets, 0)
  subnet_ids_gitlab_runner      = data.terraform_remote_state.vpc.outputs.private_subnets
  docker_machine_instance_type  = "m5a.large"
  docker_machine_spot_price_bid = var.docker_machine_spot_price_bid

  runners_gitlab_url                = "https://gitlab.com/"
  runners_token                     = var.registration_token
  gitlab_runner_registration_config = {
    registration_token = var.registration_token
    tag_list           = "docker_spot_runner"
    description        = "runner default - auto"
    locked_to_project  = "false"
    run_untagged       = "true"
    maximum_timeout    = "3600"
  }

  tags = {
    "Name"                                   = "gid-gitlab-${var.gitlab_group}-runner"
    "tf-aws-gitlab-runner:group"             = var.gitlab_group
    "tf-aws-gitlab-runner:instancelifecycle" = "spot:yes"
  }

  runners_off_peak_timezone   = var.timezone
  runners_off_peak_periods    = "[\"* * 0-7,20-23 * * mon-sun *\"]"
  runners_off_peak_idle_count = 1
  runners_off_peak_idle_time  = 60

  runners_privileged         = "true"
  runners_additional_volumes = ["/certs/client"]

  runners_volumes_tmpfs = [
    { "/var/opt/cache" = "rw,noexec" },
  ]

  runners_services_volumes_tmpfs = [
    { "/var/lib/mysql" = "rw,noexec" },
  ]
}

resource "aws_iam_service_linked_role" "spot" {
  aws_service_name = "spot.amazonaws.com"
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix = "tf-ci"
}