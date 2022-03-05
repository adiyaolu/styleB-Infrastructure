terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu-production2.io"
    key     = "production2-analytics-api/terraform.tfstate"
    region  = "ca-central-1"
    profile = "adiyaolu-prod"
  }
}


# These variables are environment unique
# When using this file as a template for a new environment they must change
locals {

  # base_name is used as the prefex of resource names. It is used to identify which environment a resource belongs to in the AWS Console   
  base_name = "prod2-adiyaolu-analytics-api"

  # base_name_short is similar to base_name, There are some resource types which have a 32 char limit
  base_name_short = "prod2-analytics"

  # The prefix for the description field, used to identify which environment a resource belongs to
  base_description = "production2 adiyaolu Analytics API"

  # sub-domain of the  Annalytcis API
  api_domain = "production2-analytics-api.adiyaolu.io"

  # list of web ulrs which are white listed for CORS 
  api_cors_allow_origin = "https://production2.adiyaolu.io, https://production2-canvas.adiyaolu.io, http://localhost:3000, http://localhost:3002"

}


# When using this file as a template for a new environment 
# These variables  are likely to change by may not depending on need
locals {

  # many of the environment var are stored in the Secret Manager.  The is the base name for secrets for example adiyaolu.staging.redshift.   Depending on the needs of the environment this may be the same
  secrets_base = "adiyaolu.production2"

  # The VPC from the base environment it should change if a separate base environment is setup
  vpc_name = "adiyaolu-production2"

  # The Load balancer from the base environment it should change if a separate base environment is setup
  lb_name = "adiyaolu-production2-lb"

  # The name of ECR repository and docker image name
  docker_repository_name = "production2-analytics-api"
  docker_image           = "171943491683.dkr.ecr.ca-central-1.amazonaws.com/${local.docker_repository_name}:latest"

}

# These variables will likely be the same in most environments
locals {

  # region where all the AWS resources will live  
  region = "ca-central-1"

  # AWS profile 
  profile = "adiyaolu-prod"

  # AWS Profile Route53 related information
  dns_testinground

  # the route 53 zone, which is the DNS base domain name it needs
  site_zone = "adiyaolu.io."
}




provider "aws" {
  region  = local.region
  profile = local.profile
}

module "production2-docker-api" {
  source = "../../../infrastructure/analytics-api"

  base_name        = local.base_name
  base_name_short  = local.base_name_short
  profile          = local.profile
  region           = local.region
  base_description = local.base_description
  secrets_base     = local.secrets_base
  node_env         = "production"

  api_domain = local.api_domain

  vpc_name = local.vpc_name

  task_family = "adiyaolu-analytics-api"
  task_cpu    = 512
  task_memory = 1024

  docker_image        = local.docker_image
  container_name      = "adiyaolu"
  container_port      = "3000"
  container_log_group = "adiyaolu"
  lb_name             = local.lb_name
  rule_priority       = 30

  xray_docker_image = "171943491683.dkr.ecr.ca-central-1.amazonaws.com/xray-daemon:latest"

  api_cors_allow_origin = local.api_cors_allow_origin

  health_check_path = "/health_check"

  site_zone = local.site_zone

  dns_profile = local.dns_profile
}

module "container_repository" {
  source          = "../../../modules/ecr"
  repository_name = local.docker_repository_name
}