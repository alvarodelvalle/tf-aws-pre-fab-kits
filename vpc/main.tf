#./vpc
provider "aws" {}

terraform {
  backend "s3" {}
}

data "aws_caller_identity" "current" { }

data "aws_availability_zones" "azs" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.24.0"

  name = var.name
  cidr = "10.10.0.0/16"

  enable_dhcp_options              = var.dhcp_options_enabled
  #Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)
  dhcp_options_domain_name         = var.dhcp_options_domain_name #register a service - consul requirement
  dhcp_options_domain_name_servers = [var.dhcp_options_domain_name_servers]

  azs                 = [data.aws_availability_zones.azs.names[0], data.aws_availability_zones.azs.names[1],
                         data.aws_availability_zones.azs.names[2]]
  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
  elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]
  redshift_subnets    = ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]
  intra_subnets       = ["10.10.51.0/24", "10.10.52.0/24", "10.10.53.0/24"]

  create_database_subnet_group = var.create_database_subnet_group

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway #single shared NAT Gateway across all of your private networks
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  enable_vpn_gateway = var.enable_vpn_gateway

  enable_s3_endpoint       = var.enable_s3_endpoint
  enable_dynamodb_endpoint = var.enable_dynamodb_endpoint

  tags = var.tags
}
