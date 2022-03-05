terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu.io"
    key     = "base/terraform.tfstate"
    region  = "us-east-1"
   profile = "testinground"
  }
}

# When using this file as a template for a new environment 
# These variables  are likely to change by may not depending on need
locals {

  # base_name is used as the prefex of resource names. It is used to identify which environment a resource belongs to in the AWS Console       
  base_name = "adiyaolu"

  # The prefix for the description field, used to identify which environment a resource belongs to
  base_description = "adiyaolu"

  # the sub-domain
  lb_domain = "lb.adiyaolu.io"
}


# These variables will likely be the same in most environments
locals {
  # region where all the AWS resources will live  
  region = "ca-central-1"

  # AWS profile 
 profile = "testinground"

  # The DNS may be setup in a diffrent AWS account,  AWS profile for Route 53
  dns_testinground

  # the route 53 zone, which is the DNS base domain name it needs
  site_zone = "adiyaolu.io."

}





provider "aws" {
  region  = local.region
  profile = local.profile
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
  vpc_availability_zones = ["ca-central-1", "us-east-1b", "us-west-1"]

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
  sg_ingress_ports = [443, 80, 3000, 3002, 4002, 3001]
}