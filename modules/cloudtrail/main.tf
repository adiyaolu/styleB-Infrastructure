

### cloudtrail


data "aws_caller_identity" "current" {}


data "aws_kms_alias" "kms" {
  count = var.kms_alias != "" ? 1 : 0    
  name = "alias/${var.kms_alias}"
}

locals {
  kms_id = var.kms_alias != "" ? data.aws_kms_alias.kms[0].target_key_arn : ""
}



resource "aws_cloudtrail" "main" {
  name = "master-cloudtrail"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  s3_key_prefix  = "cloudtrail"
  kms_key_id = local.kms_id
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail = var.is_multi_region_trail
  
  enable_logging = var. enable_logging
  enable_log_file_validation = var.enable_log_file_validation
#  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloudwatch.arn
#  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail.arn
  
  
}


resource "aws_cloudtrail" "lambda" {
  name  = "lambda-cloudtrail"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  s3_key_prefix = "lambda"
  kms_key_id = local.kms_id  
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail = var.is_multi_region_trail
  
  enable_logging = var. enable_logging
  enable_log_file_validation = var.enable_log_file_validation
#  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloudwatch.arn
#  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::Lambda::Function"
      values = ["arn:aws:lambda"]
    }
  }

}


resource "aws_cloudtrail" "s3bucket" {
  name = "s3bucket-cloudtrail"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  s3_key_prefix = "s3bucket"
  kms_key_id = local.kms_id  
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail = var.is_multi_region_trail
  
  enable_logging = var. enable_logging
  enable_log_file_validation = var.enable_log_file_validation
#  cloud_watch_logs_group_arn = aws_cloudwatch_log_group.cloudwatch.arn
#  cloud_watch_logs_role_arn = aws_iam_role.cloudtrail.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]
    }
  }

}


resource "aws_s3_bucket" "cloudtrail" {
  bucket        = var.bucket_name
  force_destroy = true
  acl    = "private"
  
  server_side_encryption_configuration {
     rule {
       apply_server_side_encryption_by_default {
         sse_algorithm     = "AES256"
       }
     }
  }

}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = "${data.aws_iam_policy_document.cloudtrail.json}"
}

# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:GetBucketAcl",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}",
    ]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = [
        "bucket-owner-full-control",
      ]
    }
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch" {
  name              =  "cloudwatch"
  retention_in_days = 3
}


resource "aws_iam_role" "cloudtrail" {
  name = "cloudtrail-to-cloudwatch"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

