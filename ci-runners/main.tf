#./ci-runners/main.tf
terraform {
  backend "s3" {}
}

data "aws_s3_bucket" "gitlab_cache" {
  bucket = var.gitlab_cache_bucket
}

data "template_file" "docker_machine_cache_policy" {
  template = file("${path.module}/policies/cache.json")

  vars = {
    s3_cache_arn = data.aws_s3_bucket.gitlab_cache.arn
  }
}

module "gitlab-runner" {
    source  = "github.com/alvarodelvalle/terraform-aws-gitlab-runner.git"
//    version = "4.11.1"

  aws_region  = var.region
  environment = var.environment

  cache_bucket = {
    create = var.create_cache_bucket
    policy = concat(aws_iam_policy.docker_machine_cache.*.arn, [""])[0]
    bucket = var.gitlab_cache_bucket
  }

  vpc_id                   = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids_gitlab_runner = data.terraform_remote_state.vpc.outputs.private_subnets
  subnet_id_runners        = element(data.terraform_remote_state.vpc.outputs.private_subnets, 0)

  runners_name             = var.runners_name
  runners_gitlab_url       = var.gitlab_url
  enable_runner_ssm_access = true
  enable_eip               = true

  docker_machine_spot_price_bid = "0.06"

  gitlab_runner_registration_config = {
    registration_token = var.registration_token
    tag_list           = var.gitlab_runner_tag_list
    description        = "runner default - auto"
    locked_to_project  = "false"
    run_untagged       = "false"
    maximum_timeout    = "3600"
  }

  tags = {
    "Name"                                   = var.runners_name
    "Environment"                            = var.environment
    "tf-aws-gitlab-runner:executor"          = "docker-machine"
    "tf-aws-gitlab-runner:instancelifecycle" = "spot:yes"
  }

  runners_off_peak_timezone   = var.timezone
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
  # working 9 to 5 :)
  runners_off_peak_periods = "[\"* * 0-9,17-23 * * mon-fri *\", \"* * * * * sat,sun *\"]"
}

resource "aws_iam_service_linked_role" "spot" {
  aws_service_name = "spot.amazonaws.com"
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix = "tf-ci"
}

resource "aws_iam_policy" "docker_machine_cache" {
  count = var.create_cache_bucket ? 1 : 0

  name        = "${var.environment}-docker-machine-cache"
  path        = "/"
  description = "Policy for docker machine instance to access cache"

  policy = data.template_file.docker_machine_cache_policy.rendered
}