variable "adiyaolu_db" {
  default     = "string"
  description = "database name"
}

variable "base_name" {
  default     = "string"
  description = "base name"
}


variable "data_public_subnet" {
  default     = "string"
  description = "public subnet where nat is sitting"
}




variable "subnet_group" {
  default     = "string"
  description = "database subnet group"
}


variable "vpc_id" {
  default     = "string"
  description = "vpc id"
}

variable "private_subnet_cidrs_1" {
  default     = "string"
  description = "private cidr block"
}

variable "private_subnet_cidrs_2" {
  default     = "string"
  description = "private cidr block"
}


variable "cluster_name" {
  default     = "adiyaolu_db"
  description = "cluster name"
}


variable "alerts_email" {
  default     = "string"
  description = "notification email"
}

