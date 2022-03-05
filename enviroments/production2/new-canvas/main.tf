terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu-production2.io"
    key     = "production2-new-canvas-adiyaolu/terraform.tfstate"
    region  = "ca-central-1"
    profile = "adiyaolu-prod"
  }
}

locals {
  base_name        = "production2-canvas"
  region           = "ca-central-1"
  profile          = "adiyaolu-prod"
  dns_profile      = "adiyaolu"
  base_description = "production2 New Canvas"
  site_domain      = "production2-canvas.adiyaolu.io"
  site_zone        = "adiyaolu.io."
  site_default_root_object = "index.html"
}

provider "aws" {
  region  = local.region
  profile = local.profile
}

module "production2-site" {
  source = "../../../infrastructure/ember-dashboard"

  profile = local.profile

  ## S3 Web
  dns_profile              = local.dns_profile
  site_domain              = local.site_domain
  site_bucket_name         = local.site_domain
  site_zone                = local.site_zone
  site_default_root_object = local.site_default_root_object
}