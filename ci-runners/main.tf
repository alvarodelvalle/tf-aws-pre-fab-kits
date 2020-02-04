#./ci-runners/main.tf
module "gitlab-runner" {
    source  = "npalm/gitlab-runner/aws"
    version = "4.10.0"

  aws_region  = "us-east-1"
  environment = "ops"

  runners_name             = "group-yaka2020-runners"
  enable_runner_ssm_access = true
  enable_eip               = true

  vpc_id                        = var.vpc_id
  subnet_id_runners             = element(var.private_subnets, 0)
  subnet_ids_gitlab_runner      = var.private_subnets
  docker_machine_instance_type  = "m5a.large"
  docker_machine_spot_price_bid = "0.04"

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
    "Name"                                   = "ci-group-yaka2020-runners"
    "tf-aws-gitlab-runner:group"             = "group-yaka2020-runners"
    "tf-aws-gitlab-runner:instancelifecycle" = "spot:yes"
  }

  runners_off_peak_timezone   = var.timezone
  runners_off_peak_periods    = "[\"* * 0-7,20-23 * * mon-sun *\"]"
  runners_off_peak_idle_count = 0
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