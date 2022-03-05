

variable "bucket_name" {
  description = "Bucket name where the cloud trail logs will be stored"
  type    = string
}

variable "profile" {
  description = "AWS credentials to use - pick a profile"
  type        = string
}

variable "kms_alias" {
  description = "Alias to KMS key for DB encryption"
  type        = string
  default     = ""
}

variable "include_global_service_events" {
  description = "Whether the trail is publishing events from global services such as IAM to the log files"
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Whether the trail is created in the current region or in all regions"
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Whether log file integrity validation is enabled"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enables logging for the trail"
  type        = bool
  default     = true
}
