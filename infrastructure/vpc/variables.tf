##  vpc-database


variable "base_name" {
  description = "Prefix of resources"
  type        = string
  default     = "ollon_base"
}

variable "region" {
  description = "Region were VPC will be created"
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "AWS credentials to use - pick a profile"
  type        = string
}

variable "base_description" {
  description = "Used to for the description"
  type        = string
} 

### VPC

variable "vpc_cidr" {
  description = "CIDR range of VPC. eg: 192.168.0.0/16"
  type        = string
  default     = "192.168.0.0/16"
}

variable "enable_dns_hostnames" {
  default     = true
  description = "boolean, enable/disable VPC attribute, enable_dns_hostnames"
  type        = bool
}

variable "enable_dns_support" {
  default     = true
  description = "boolean, enable/disable VPC attribute, enable_dns_support"
  type        = bool
}

variable "extra_tags" {
  description = "Extra tags that will be added to all resources"
  default     = {}
  type        = map(string)
}

variable "private_subnet_cidrs" {
  description = "A list of private subnet CIDRs to deploy inside the VPC. Should not be higher than public subnets count"
  type        = list(string)
  default     = ["192.168.128.0/24"]
}

variable "public_subnet_cidrs" {
  description = "A list of private subnet CIDRs to deploy inside the VPC. Should not be higher than public subnets count"
  type        = list(string)
  default     = ["192.168.129.0/24"]
}

variable "vpc_availability_zones" {
  description = "A list of private subnet CIDRs to deploy inside the VPC. Should not be higher than public subnets count"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}




