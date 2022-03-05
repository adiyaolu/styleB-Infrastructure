terraform {
  backend "s3" {
    bucket         = "terrafrom-state.adiyaolu-test.io"
    key            = "testing-ember-dashboard-adiyaolu/terraform.tfstate"
    region         = "us-east-1"
    profile        = "adiyaolu"
  }
}



locals {
  base_name = "testing-performance"
  region = "us-east-1"
 profile = "testinground"
  base_description = "Testing Performance Ember Dashboard"
  site_domain = "testing-performance.adiyaolu.io"
  site_zone = "adiyaolu.io."
}

provider "aws" {
   region = local.region
   profile = local.profile
}

module "testing-site" {
  source = "../../../infrastructure/ember-dashboard"

  profile = local.profile

  ## S3 Web
  // dns_profile = local.profile
  dns_testinground

  site_domain = local.site_domain
  site_bucket_name = local.site_domain
  site_zone = local.site_zone 
  site_default_root_object = "index.html"
}

resource "time_sleep" "wait_30_seconds" {
depends_on = [module.testing-site] ## if you are using resource block you can change
destroy_duration = "1200s"
}
resource "null_resource" "next" {
depends_on = [time_sleep.wait_30_seconds]
}