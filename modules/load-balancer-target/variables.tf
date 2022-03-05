variable "name_prefix" {
  description = "Prefix of resources"
  type        = string
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

variable "lb_name" {
  description = "Load balancer name"
  type        = string
}

variable "target_group_port" {
  description = "Port of the load balancer target group"
  type        = string
}

variable "target_type" {
  description = "load balancer target type: ip, lambda"
  type        = string
  default     = "ip"
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