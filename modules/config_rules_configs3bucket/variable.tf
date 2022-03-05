
variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket to create."
}

variable "config-role" {
  type        = string
  description = "The name of the config role."
}


variable "config_rules_with_execution_frequency" {
  description = "(optional) describe your variable"
  type = map(object({
    description                 = string
    owner                       = string
    source_identifier           = string
    maximum_execution_frequency = string
  }))

  default = {
    "root-account-mfa-enabled" = {
      description                 = "Ensure root AWS account has MFA enabled"
      owner                       = "AWS"
      source_identifier           = "ROOT_ACCOUNT_MFA_ENABLED"
      maximum_execution_frequency = "TwentyFour_Hours"
    }

  }
}

variable "config_rules_without_execution_frequency" {
  description = "(optional) describe your variable"
  type = map(object({
    description       = string
    owner             = string
    source_identifier = string
  }))

  default = {
    "cloudwatch_log_group-encrypted" = {
      description       = "Checks whether a log group in Amazon CloudWatch Logs is encrypted. The rule is NON_COMPLIANT if CloudWatch Logs has a log group without encryption enabled"
      owner             = "AWS"
      source_identifier = "CLOUDWATCH_LOG_GROUP_ENCRYPTED"
    },
    "rds-storage-encrypted" = {
      description       = "Checks whether storage encryption is enabled for your RDS DB instances."
      owner             = "AWS"
      source_identifier = "RDS_STORAGE_ENCRYPTED"
    },
    "ec2-volume-inuse-check" = {
      description       = "Checks whether EBS volumes are attached to EC2 instances"
      owner             = "AWS"
      source_identifier = "EC2_VOLUME_INUSE_CHECK"
    },
    "eip" = {
      description       = "Check if Eip is attached to instance"
      owner             = "AWS"
      source_identifier = "EIP_ATTACHED"
    },
    "BACKUP_RECOVERY_ENCRYPTED" = {
      description       = "Check if backups are encrypted"
      owner             = "AWS"
      source_identifier = "BACKUP_RECOVERY_POINT_ENCRYPTED"
    },
    "cloudtrail-check" = {
      description       = "Checks if cloudtrail are enabled"
      owner             = "AWS"
      source_identifier = "CLOUD_TRAIL_ENABLED"
    },
    "DB_BACKUP_ENABLED" = {
      description       = "Check if DB backup is enabled"
      owner             = "AWS"
      source_identifier = "DB_INSTANCE_BACKUP_ENABLED"
    }
    "EC2_STOPPED_INSTANCE" = {
      description       = "Check if there are stopped EC2"
      owner             = "AWS"
      source_identifier = "EC2_STOPPED_INSTANCE"
    },
    "AUTOSCALING_GROUP_ELB_HEALTHCHECK_REQUIRED" = {
      description       = "check if ASG elb healthcheck required"
      owner             = "AWS"
      source_identifier = "AUTOSCALING_GROUP_ELB_HEALTHCHECK_REQUIRED"
    },
    "EC2_EBS_ENCRYPTION_BY_DEFAULT" = {
      description       = "Check if ec2 Ebs encryption is enabed "
      owner             = "AWS"
      source_identifier = "EC2_EBS_ENCRYPTION_BY_DEFAULT"
    },
    "ELB_LOGGING_ENABLED" = {
      description       = ""
      owner             = "AWS"
      source_identifier = "ELB_LOGGING_ENABLED"
    },
    "IAM_USER_GROUP_MEMBERSHIP" = {
      description       = "Check if iam belongs to a group"
      owner             = "AWS"
      source_identifier = "IAM_USER_GROUP_MEMBERSHIP_CHECK"
    },
    "INSTANCES_IN_VPC-check" = {
      description       = "Check if instance is connected to a vpc"
      owner             = "AWS"
      source_identifier = "INSTANCES_IN_VPC"
    }

  }
}