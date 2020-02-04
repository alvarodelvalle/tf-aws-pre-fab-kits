#AWS Modules
* VPC
#GitLab Runners
Configuration: 
* t3.micro - Agent
* m5a.large - docker+machine
##AWS Configuration
###VPC Subnets
private_subnets\
["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]\
public_subnets\
["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]\
database_subnets\
["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]\
elasticache_subnets\
["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]\
redshift_subnets\
["10.10.41.0/24", "10.10.42.0/24", "10.10.43.0/24"]\
intra_subnets\
["10.10.51.0/24", "10.10.52.0/24", "10.10.53.0/24"]\