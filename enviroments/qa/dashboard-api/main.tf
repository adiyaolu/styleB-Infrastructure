terraform {
  backend "s3" {
    bucket         = "terrafrom-state.adiyaolu.io"
    key            = "qa-dashboard-api/terraform.tfstate"
    region         = "us-east-1"
    profile        = "adiyaolu"
  }
}

locals {
  base_name = "qa-adiyaolu-dashboard-api"
  base_name_short = "stage-dashboard"  
  region = "ca-central-1"
 profile = "testinground"
  base_description = "QA adiyaolu Dashboard API"
  
  site_zone = "adiyaolu.io."
  secrets_base = "adiyaolu.staging"

  api_domain = "qa-dashboard-api-performance.adiyaolu.io"
  
  vpc_name = "adiyaolu"

  allowed_file_types = [".jpg", ".jpeg", ".png", ".heic", ".wav", ".mp3", ".mp4", ".pdf"]
}

provider "aws" {
  region = local.region
  profile = local.profile
}

module "qa-docker-api" {
  source = "../../../infrastructure/dashboard-api"

  base_name = local.base_name
  base_name_short = local.base_name_short
  profile = local.profile
  region = local.region
  base_description = local.base_description 
  secrets_base = local.secrets_base

  api_domain = local.api_domain

  vpc_name = local.vpc_name 

  task_family = "adiyaolu-api"
  task_cpu = 256
  task_memory = 512
  
  docker_image = "859456250655.dkr.ecr.ca-central-1.amazonaws.com/staging-dashboard-api:latest"
  container_name = "adiyaolu"
  container_port = "3002"
  container_log_group = "adiyaolu"
  lb_name = "adiyaolu-lb"
  rule_priority = 31

  xray_docker_image = "859456250655.dkr.ecr.ca-central-1.amazonaws.com/xray-daemon:latest"
  
  api_cors_allow_origin = "https://qa-performance.adiyaolu.io, https://qa-canvas-performance.adiyaolu.io, http://localhost:3000, http://localhost:3002"
 
  health_check_path = "/health_check"
 
  site_zone = local.site_zone
  
  dns_profile = local.profile
}

module "container_repository" {
  source = "../../../modules/ecr"
  repository_name = "staging-dashboard-api"
}