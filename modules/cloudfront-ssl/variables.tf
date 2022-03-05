

variable "default_root_object" {
  type    = string
  default = "index.html"
}

variable "forward_query_string" {
  type        = bool
  description = "Forward the query string to the origin"
  default     = false
}

variable "forwarded_headers" {
  description = "Headers to forward to the origin"
  type        = list(string)
  default     = []
}

variable "price_class" {
  type        = string
  description = "CloudFront price class"
  default     = "PriceClass_200"
}

variable "ipv6" {
  type        = bool
  description = "Enable IPv6 on CloudFront distribution"
  default     = false
}

variable "domain" {
  description = "The domain name the cert will be setup for"
  type = string
}

variable "zone" {
  description = "the AWS zone is the root doamin"
  type        = string
}

variable "profile" {
  description = "AWS credentials to use - pick a profile"
  type        = string
}

variable "dns_profile" {
  description = "AWS credentials to for Route 53"
  type        = string
}

variable "origin_id" {
  description = "id of the aws object the origin to connect the cloudfront too"
  type        = string
}

variable "origin_domain_name" {
  description = "domain name the origin to connect the cloudfront too"
  type        = string
}

variable "cloudfront_access_identity_path" {
  description = "full path for the origin access identity to use in CloudFront"
  type        = string
  default     = ""
}

variable "custom_header" {
  description = "domain name the origin to connect the cloudfront too"
  type        = map(string)
  default     = {}
}

variable "allowed_methods" {
  description = "methods for the cdn to allow"
  type        = list(string)
  default     = ["GET", "HEAD", "DELETE", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cached_methods" {
  description = "methods for the cdn to be cached"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

//variable "edge_lambada_names" {
//  description = ""
//  type        = list(string)
//}

//variable "edge_lambada_event_types" {
//  description = ""
//  type        = list(string)
//}










