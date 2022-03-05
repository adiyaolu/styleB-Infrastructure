
variable "base_name" {
  description = "Prefix of resources"
  type        = string
}

variable "base_name_short" {
  description = "Prefix of resources"
  type        = string
}

variable "base_description" {
  description = "Used to for the description"
  type        = string
}

variable "region" {
  description = "Region were resources will be created"
  type        = string
}

variable "profile" {
  description = "AWS credentials to use - pick a profile"
  type        = string
}

variable "api_domain" {
  description = "The domain name the cert will be setup for"
  type = string
}

variable "dns_profile" {
  description = "AWS credentials to for Route 53"
  type        = string
}

variable "vpc_name" {
  description = "VPC name in the tags"
  type        = string
}

variable "lb_name" {
  description = "Load balancer name"
  type        = string
}

variable "extra_tags" {
  description = "Extra tags that will be added to all resources"
  default     = {}
  type        = map(string)
}

variable "secrets_base" {
  description = "the base name for items in secrets manager"
  type        = string
}

variable "api_cors_allow_origin" {
  description = "CORS for the Lambda API"
  type = string
}

variable "site_zone" {
  type    = string
  description = "zone in Route 53"
}

variable "task_family" {
  description = "A unique name for your task definition"
  type        = string
}

variable "task_cpu" {
    description =  "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    type        = number
  }

variable "task_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    type        = number
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

variable "container_name" {
  description = "name of the container"
  type        = string
}

variable "container_port" {
  description = "port used buy the container"
  type        = string
}

variable "container_log_group" {
  description = "log group for the container"
  type        = string
}

variable "container_environment" {
  default     = {}
  description = "The environment variables to pass to a container"
  type        = map(string)
}

variable "rule_priority" {
  description = "Listiner Rule Priority, these need to be diffrent"
  type        = number
}

variable "health_check_enabled" {
  description = "Indicates whether health checks are enabled"
  type        = bool
  default     = true
}

variable "health_check_interval" {
  description = "The approximate amount of time, in seconds, between health checks of an individual target. Minimum value 5 seconds, Maximum value 300 seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response means a failed health check."
  type        = number
  default     = 5
}

variable "health_check_path" {
  description = "The destination for the health check request"
  type        = string
  default     = "/"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive health check failures required before considering the target unhealthy"
  type        = number
  default     = 3
}

variable "warmup_time" {
  description = "The amount time for targets to warm up before the load balancer sends them a full share of requests. The range is 30-900 seconds or 0 to disable. The default value is 0 seconds"
  type        = number
  default     = 0
}

variable "node_env" {
  description = "the env in which node will operate"
  type        = string
}