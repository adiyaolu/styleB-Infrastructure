
### S3 Website with SLL
module "s3-site" {
  source          = "../../modules/s3-site"
  bucket_name = var.site_bucket_name
} 

module "site-ssl-cert" {
  source          = "../../modules/cloudfront-ssl"

  profile = var.profile
  dns_profile = var.dns_profile  

  zone = var.site_zone 
  domain = var.site_domain
  default_root_object = var.site_default_root_object 

  origin_domain_name = module.s3-site.s3_domain_name
  origin_id  = module.s3-site.s3_id

  // edge_lambada_names = ["edge_headers"]
  // edge_lambada_event_types = ["origin-response"]

}



