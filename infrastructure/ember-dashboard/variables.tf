

## --------------
## S3 Website
## --------------


variable "profile" {
  description = "AWS credentials to use - pick a profile"
  type        = string
}

variable "dns_profile" {
  description = "AWS credentials to for Route 53"
  type        = string
}

variable "site_domain" {
  type = string
}

variable "site_zone" {
  type    = string
}

variable "site_bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create."
}

variable "site_default_root_object" {
  type    = string
  default = "index.html"
}




