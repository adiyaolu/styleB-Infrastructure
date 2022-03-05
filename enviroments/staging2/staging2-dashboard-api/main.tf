terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu-staging2.io"
    key     = "staging2-dashboard-api/terraform.tfstate"
    region  = "us-west-2"
   profile = "testinground"
  }
}

locals {
  base_name        = "staging2-adiyaolu-dashboard-api"
  base_name_short  = "staging2-dashboard"
  region           = "us-west-2"
  profile          = "adiyaolu"
  base_description = "staging2 adiyaolu Dashboard API"

  site_zone    = "adiyaolu.io."
  secrets_base = "adiyaolu.staging2"

  api_domain = "staging2-dashboard-api.adiyaolu.io"

  vpc_name = "adiyaolu-staging2"

  allowed_file_types = [".jpg", ".jpeg", ".png", ".heic", ".wav", ".mp3", ".mp4", ".pdf"]
}

provider "aws" {
  region  = local.region
  profile = local.profile
}

module "staging2-docker-api" {
  source = "../../../infrastructure/dashboard-api"

  base_name        = local.base_name
  base_name_short  = local.base_name_short
  profile          = local.profile
  region           = local.region
  base_description = local.base_description
  secrets_base     = local.secrets_base

  api_domain = local.api_domain

  vpc_name = local.vpc_name

  task_family = "adiyaolu-api"
  task_cpu    = 512
  task_memory = 1024

  docker_image        = "859456250655.dkr.ecr.us-west-2.amazonaws.com/staging2-dashboard-api:latest"
  container_name      = "adiyaolu"
  container_port      = "3002"
  container_log_group = "adiyaolu"
  lb_name             = "adiyaolu-staging2-lb"
  rule_priority       = 31

  xray_docker_image = "859456250655.dkr.ecr.ca-central-1.amazonaws.com/xray-daemon:latest"

  api_cors_allow_origin = "https://staging2.adiyaolu.io, https://staging2-canvas.adiyaolu.io, http://localhost:3000, http://localhost:3002"

  health_check_path = "/health_check"

  site_zone   = local.site_zone
  dns_testinground

  // dns_profile = local.profile
}

module "container_repository" {
  source          = "../../../modules/ecr"
  repository_name = "staging2-dashboard-api"
}