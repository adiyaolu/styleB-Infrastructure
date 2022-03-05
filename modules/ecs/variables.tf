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

variable "region" {
  description = "Region were resources will be created"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key,  used by x-ray"
  type        = string
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS secret key,  used by x-ray"
  type        = string
  default     = ""
}

variable "security_groups" {
  description = "Security groups used by the containers"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets used by the containers"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign a public IP address to the ENI"
  type        = bool
}

variable "task_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    type        = number
  }

variable "task_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    type        = number
}

variable "task_family" {
  description = "A unique name for your task definition"
  type        = string
}

variable "docker_image" {
  description = "Image name in the container registery"
  type        = string
}

variable "xray_docker_image" {
  description = "Image name in the container registery for AWS xray"
  type        = string
  default     = ""
}

variable "max_capacity" {
  description = "Maximum container count"
  type        = string
}

variable "min_capacity" {
  description = "Minimum container count"
  type        = string
}

variable "appautoscaling_target_cpu" {
  description = "Minimum container count"
  type        = number
  default     = 90
}


variable "appautoscaling_scale_in_cooldown" {
  description = "Minimum container count"
  type        = number
  default     = 300
}

variable "appautoscaling_scale_out_cooldown" {
  description = "Minimum container count"
  type        = number
  default     = 300
}

variable "deployment_maximum_percent" {
  description = "Countainer deployment maximum percent"
  type        = number
}

variable "deployment_minimum_healthy_percent" {
  description = "Countainer deployment minimim healthy percent"
  type        = number
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown"
  type        = number
  default     = 30
}

variable "container_name" {
  description = "name of the container"
  type        = string
}

variable "container_port" {
  description = "Port used buy the containe"
  type        = string
}

variable "lb_target_group_arn" {
  description = "Load blancer target group"
  type        = string
}

variable "container_environment" {
  default     = {}
  description = "The environment variables to pass to a container"
  type        = map(string)
}

variable "container_secrets" {
  default     = {}
  description = "The secrets environment variables to pass to a container"
  type        = map(string)
}

variable "secret_arns" {
  default     = []
  description = "The secrets environment variables to pass to a container"
  type        = list(string)
}











