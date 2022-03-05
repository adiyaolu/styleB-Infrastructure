terraform {
  backend "s3" {
    bucket  = "terrafrom-state.adiyaolu-staging2.io"
    key     = "staging2-new-canvas-adiyaolu/terraform.tfstate"
    region  = "us-west-2"
   profile = "testinground"
  }
}

locals {
  base_name        = "staging2-canvas"
  region           = "us-west-2"
  profile          = "adiyaolu"
  base_description = "staging2 New Canvas"
  site_domain      = "staging2-canvas.adiyaolu.io"
  site_zone        = "adiyaolu.io."
}

provider "aws" {
  region  = local.region
  profile = local.profile
}

module "staging2-site" {
  source = "../../../infrastructure/ember-dashboard"

  profile = local.profile

  ## S3 Web
  // dns_profile = local.profile
  dns_profile              = "adiyaolu"
  site_domain              = local.site_domain
  site_bucket_name         = local.site_domain
  site_zone                = local.site_zone
  site_default_root_object = "index.html"
}