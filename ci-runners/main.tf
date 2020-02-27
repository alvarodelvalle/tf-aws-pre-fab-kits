#./ci-runners/main.tf
terraform {
  backend "s3" {}
}

module "gitlab-runner" {
    source  = "npalm/gitlab-runner/aws"
    version = "4.11.1"

  aws_region  = var.region
  environment = var.environment

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
    tag_list           = "docker_spot_runner"
    description        = "runner default - auto"
    locked_to_project  = "true"
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

resource "null_resource" "cancel_spot_requests" {
  # Cancel active and open spot requests, terminate instances
  triggers = {
    environment = var.environment
  }

  provisioner "local-exec" {
    when    = destroy
    command = "../../ci/bin/cancel-spot-instances.sh ${self.triggers.environment}"
  }
}

resource "aws_iam_service_linked_role" "spot" {
  aws_service_name = "spot.amazonaws.com"
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix = "tf-ci"
}