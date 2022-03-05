variable "name_prefix" {
  description = "Prefix of resources"
  type        = string
}

variable "base_description" {
  description = "Used to for the description"
  type        = string
} 

variable "extra_tags" {
  description = "Extra tags that will be added to primary resources."
  type        = map(string)
  default     = {}
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

variable "vpc_id" {
  description = "VPC ID where subnets will be created"
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "The list of public subnet IDs for the Ecs"
}

variable "log_bucket" {
  description = "S3 bucket where logs are stored"
  type        = string
}

variable "logs_enabled" {
  description = "emable logging for the load balancer "
  type        = bool
  default     = true
}

variable "sg_ingress_ports" {
  description = "A list of ports open for ingress on security group"
  type        = list(string)
}













