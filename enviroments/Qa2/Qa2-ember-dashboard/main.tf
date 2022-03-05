terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu-qa2.io"
    key     = "qa2-ember-dashboard-adiyaolu/terraform.tfstate"
    region  = "us-west-1"
   profile = "testinground"
  }
}

locals {
  base_name        = "qa-performance"
  region           = "us-west-1"
  profile          = "adiyaolu"
  base_description = "qa Performance Ember Dashboard"
  site_domain      = "qa2-performance.adiyaolu.io"
  site_zone        = "adiyaolu.io."
}

provider "aws" {
  region  = local.region
  profile = local.profile
}

module "qa-site" {
  source = "../../../infrastructure/ember-dashboard"

  profile = local.profile

  ## S3 Web
  // dns_profile = local.profile
  dns_testinground

  site_domain              = local.site_domain
  site_bucket_name         = local.site_domain
  site_zone                = local.site_zone
  site_default_root_object = "index.html"
}