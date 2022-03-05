terraform {
  backend "s3" {
    bucket         = "terrafrom-state.adiyaolu.io"
    key            = "qa-new-canvas-adiyaolu/terraform.tfstate"
    region         = "us-east-1"
    profile        = "adiyaolu"
  }
}

locals {
  base_name = "qa-performance-canvas"
  region = "us-east-1"
 profile = "testinground"
  base_description = "QA Performance New Canvas"
  site_domain = "qa-canvas-performance.adiyaolu.io"
  site_zone = "adiyaolu.io."
}

provider "aws" {
   region = local.region
   profile = local.profile
}

module "qa-site" {
  source = "../../../infrastructure/ember-dashboard"

  profile = local.profile

  ## S3 Web
  dns_profile = local.profile
  site_domain = local.site_domain
  site_bucket_name = local.site_domain
  site_zone = local.site_zone 
  site_default_root_object = "index.html"
}