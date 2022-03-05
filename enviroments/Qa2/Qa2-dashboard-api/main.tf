terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu-qa2.io"
    key     = "qa2-dashboard-api/terraform.tfstate"
    region  = "us-west-1"
   profile = "testinground"
  }
}

locals {
  base_name        = "qa2-adiyaolu-dashboard-api"
  base_name_short  = "qa2-dashboard"
  region           = "us-west-1"
  profile          = "adiyaolu"
  base_description = "qa2 adiyaolu Dashboard API"

  site_zone    = "adiyaolu.io."
  secrets_base = "adiyaolu.Qa2"

  api_domain = "qa2-dashboard-api-performance.adiyaolu.io"

  vpc_name = "adiyaolu-qa2"

  allowed_file_types = [".jpg", ".jpeg", ".png", ".heic", ".wav", ".mp3", ".mp4", ".pdf"]
}

provider "aws" {
  region  = local.region
  profile = local.profile
}

module "Qa2-docker-api" {
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
  task_cpu    = 256
  task_memory = 512

  docker_image        = "859456250655.dkr.ecr.us-west-1.amazonaws.com/qa2-dashboard-api:latest"
  container_name      = "adiyaolu"
  container_port      = "3002"
  container_log_group = "adiyaolu"
  lb_name             = "adiyaolu-qa2-lb"
  rule_priority       = 31

  xray_docker_image = "859456250655.dkr.ecr.ca-central-1.amazonaws.com/xray-daemon:latest"

  api_cors_allow_origin = "https://qa2-performance.adiyaolu.io, https://qa2-canvas-performance.adiyaolu.io, http://localhost:3000, http://localhost:3002"

  health_check_path = "/health_check"

  site_zone   = local.site_zone
  dns_testinground

  // dns_profile = local.profile
}

module "container_repository" {
  source          = "../../../modules/ecr"
  repository_name = "qa2-dashboard-api"
}