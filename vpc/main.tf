#./vpc
provider "aws" {
  version = "2.46.0"
  region = "us-east-1"
  profile = "terraform-test"
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

  enable_dhcp_options              = true
  #Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)
  dhcp_options_domain_name         = "service.consul" #register a service - consul requirement
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  azs                 = [data.aws_availability_zones.azs.names[0], data.aws_availability_zones.azs.names[1],
                         data.aws_availability_zones.azs.names[2]]
  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
  elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]
  redshift_subnets    = ["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]
  intra_subnets       = ["10.10.51.0/24", "10.10.52.0/24", "10.10.53.0/24"]

  create_database_subnet_group = false

  enable_nat_gateway = true
  single_nat_gateway = true #single shared NAT Gateway across all of your private networks

  enable_vpn_gateway = true

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  tags = {
    Owner       = data.aws_caller_identity.current.account_id
    Environment = "ops"
    Name        = "n-stack-ops" #'vpcname-owner
  }
}
