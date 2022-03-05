// variable "cluster_identifier" {
//   description = "Custom name of the cluster"
//   type        = string
// }

variable "data_private_subnet_1" {
  description = "private subnet 1"
  type        = string
  default     = ""
}

variable "data_private_subnet_2" {
  description = "private subnet 2"
  type        = string
  default     = ""
}


variable "cluster_node_type" {
  description = "Node Type of Redshift cluster"
  type        = string
  # Valid Values: dc1.large | dc1.8xlarge | dc2.large | dc2.8xlarge | ds2.xlarge | ds2.8xlarge | ra3.xlplus | ra3.4xlarge | ra3.16xlarge.
  # http://docs.aws.amazon.com/cli/latest/reference/redshift/create-cluster.html
}

variable "cluster_number_of_nodes" {
  description = "Number of nodes in the cluster (values greater than 1 will trigger 'cluster_type' of 'multi-node')"
  type        = number
}

// variable "cluster_database_name" {
//   description = "The name of the database to create"
//   type        = string
// }

variable "cluster_master_username" {
  description = "Master username"
  type        = string
}

variable "cluster_master_password" {
  description = "Password for master user"
  type        = string
}

variable "cluster_port" {
  description = "Cluster port"
  type        = number
}



variable "publicly_accessible" {
  description = "Determines if Cluster can be publicly available (NOT recommended)"
  type        = bool

}

variable "redshift_subnet_group_name" {
  description = "The name of a cluster subnet group to be associated with this cluster. If not specified, new subnet will be created."
  type        = string
  default     = ""
}

variable "parameter_group_name" {
  description = "The name of the parameter group to be associated with this cluster. If not specified new parameter group will be created."
  type        = string
  default     = ""
}

variable "redshift_parameter_family" {
  type = string
}

variable "base_name" {
  type = string
}

variable "encrypted" {
  description = "(Optional) If true , the data in the cluster is encrypted at rest."
  type        = bool
}

variable "application" {
  default = "string"
}

variable "environment" {
  default = "string"
}

variable "slack_emoji" {
  default = "string"
}

variable "slack_webhook" {
  default = "string"
}


#cloudwatch variables

