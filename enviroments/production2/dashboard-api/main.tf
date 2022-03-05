terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu-production2.io"
    key     = "production2-dashboard-api/terraform.tfstate"
    region  = "ca-central-1"
    profile = "adiyaolu-prod"
  }
}

locals {
  base_name        = "prod2-adiyaolu-dashboard-api"
  base_name_short  = "prod2-dashboard"
  region           = "ca-central-1"
  profile          = "adiyaolu-prod"
  dns_testinground
  base_description = "production2 adiyaolu Dashboard API"

  site_zone    = "adiyaolu.io."
  secrets_base = "adiyaolu.production2"

  api_domain = "production2-dashboard-api.adiyaolu.io"

  vpc_name = "adiyaolu-production2"

  allowed_file_types = [".jpg", ".jpeg", ".png", ".heic", ".wav", ".mp3", ".mp4", ".pdf"]
}

provider "aws" {
  region  = local.region
  profile = local.profile
}

module "production2-docker-api" {
  source = "../../../infrastructure/dashboard-api"

  base_name        = local.base_name
  base_name_short  = local.base_name_short
  profile          = local.profile
  region           = local.region
  base_description = local.base_description
  secrets_base     = local.secrets_base
  node_env         = "production"

  api_domain = local.api_domain

  vpc_name = local.vpc_name

  task_family = "adiyaolu-api"
  task_cpu    = 512
  task_memory = 1024

  docker_image        = "171943491683.dkr.ecr.ca-central-1.amazonaws.com/production2-dashboard-api:latest"
  container_name      = "adiyaolu"
  container_port      = "3002"
  container_log_group = "adiyaolu"
  lb_name             = "adiyaolu-production2-lb"
  rule_priority       = 31

  xray_docker_image = "171943491683.dkr.ecr.ca-central-1.amazonaws.com/xray-daemon:latest"

  api_cors_allow_origin = "https://production2.adiyaolu.io, https://production2-canvas.adiyaolu.io, http://localhost:3000, http://localhost:3002"

  health_check_path = "/health_check"

  site_zone   = local.site_zone
  dns_profile = local.dns_profile
  
}

module "container_repository" {
  source          = "../../../modules/ecr"
  repository_name = "production2-dashboard-api"
}