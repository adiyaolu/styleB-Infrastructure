terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu-staging2.io"
    key     = "terraform-staging2.tfstate"
    region  = "us-west-2"
   profile = "testinground"
  }
}


locals {
  base_name        = "adiyaolu-staging2"
  region           = "us-west-2"
  profile          = "adiyaolu"
  dns_profile      = "adiyaolu"
  base_description = "adiyaolu-Staging2"
  site_zone        = "adiyaolu.io."
  lb_domain        = "lb.staging2.adiyaolu.io"
  config-role      = "adiyaolu-config"
  guardduty_bucket = "adiyaolu-staging2-guardduty"
}


provider "aws" {
 profile = "testinground"
  region  = "us-west-2"
}

module "base_infra" {
  source = "../../infrastructure/vpc"

  base_name        = local.base_name
  region           = local.region
  profile          = local.profile
  base_description = local.base_description

  vpc_cidr               = "10.1.0.0/16"
  public_subnet_cidrs    = ["10.1.32.0/20", "10.1.48.0/20"]
  private_subnet_cidrs   = ["10.1.0.0/20", "10.1.16.0/20"]
  vpc_availability_zones = ["us-west-2", "ca-central-1", "us-east-1b"]
}


module "main-s3-logs" {
   source      = "../../modules/s3-logs"
   bucket_name = "${local.base_name}-logs"
}


module "main-lb" {
  source = "../../modules/load-balancer"

  name_prefix = local.base_name

  base_description = local.base_description

  vpc_id     = module.base_infra.vpc_id
  subnet_ids = module.base_infra.subnet_ids

  log_bucket       = module.main-s3-logs.s3_id
  profile          = local.profile
  dns_profile      = local.dns_profile
  zone             = local.site_zone
  domain           = local.lb_domain
  sg_ingress_ports = [443, 80, 3000, 3002, 4002]
}


# module "aws_config_and_configs3" {
#   source      = "../../modules/config_rules_configs3bucket"
#   config-role = "${local.config-role}-config-staging2"
#   bucket_name = "${local.base_name}-config"
# }

# module "aws_guardduty" {
#   source      = "../../modules/Guardduty"
# }

// module "clouwatch_dashboard" {
//   source      = "../../modules/cloudwatch-dashboard"
//   base_name = local.base_name
//   region = local.region
// }


// module "aws_cloudtrail" {
//   source      = "../../modules/cloudtrail"
//   bucket_name = "${local.base_name}-cloudtrail-staging2"
//   profile     = "adiyaolu"
// }