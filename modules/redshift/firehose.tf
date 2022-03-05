data "aws_region" "current" {}

resource "aws_s3_bucket" "adiyaolus-3_bucket" {
  bucket = "${var.base_name}.test-firehose-pipeline"
  acl    = "private"
}

resource "aws_iam_role" "adiyaolu_pipeline_role" {
  name = "firehose_test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "firehose.amazonaws.com",
          "redshift.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "adiyaolu-firehose_pipeline_role_policy" {
  name   = "pipeline_test_role_policy"
  role   = aws_iam_role.adiyaolu_pipeline_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.adiyaolus-3_bucket.arn}",
        "${aws_s3_bucket.adiyaolus-3_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords"
      ],
      "Resource": "${aws_kinesis_stream.tracker-events.arn}"
    }
  ]
}
EOF
}



resource "aws_kinesis_firehose_delivery_stream" "api-calls" {
  name        = "api-calls"
  destination = "redshift"

  s3_configuration {
    role_arn           = aws_iam_role.adiyaolu_pipeline_role.arn
    bucket_arn         = aws_s3_bucket.adiyaolus-3_bucket.arn
    buffer_interval    = "300"
    buffer_size        = "128"
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = "/aws/kinesisfirehose/api-calls"
      log_stream_name = "S3Delivery"
    }
  }

  server_side_encryption {
    enabled  = "false"
    key_type = "AWS_OWNED_CMK"
  }

  redshift_configuration {
    role_arn        = aws_iam_role.adiyaolu_pipeline_role.arn
    cluster_jdbcurl = "jdbc:redshift://${aws_redshift_cluster.adiyaolu.endpoint}/${aws_redshift_cluster.adiyaolu.database_name}"
    username        = var.cluster_master_username
    password        = var.cluster_master_password
    data_table_name = "api_calls"
    copy_options    = "json 'auto'"
  }
}



resource "aws_kinesis_stream" "tracker-events" {
  encryption_type  = "NONE"
  name             = "tracker-events"
  retention_period = "24"
  shard_count      = "3"
}


resource "aws_kinesis_firehose_delivery_stream" "tracker-events" {
  name        = "tracker-events"
  destination = "redshift"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.tracker-events.arn
    role_arn           = aws_iam_role.adiyaolu_pipeline_role.arn
  }


  redshift_configuration {
    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = "/aws/kinesisfirehose/tracker-events"
      log_stream_name = "RedshiftDelivery"
    }
    role_arn        = aws_iam_role.adiyaolu_pipeline_role.arn
    cluster_jdbcurl = "jdbc:redshift://${aws_redshift_cluster.adiyaolu.endpoint}/${aws_redshift_cluster.adiyaolu.database_name}"
    username        = var.cluster_master_username
    password        = var.cluster_master_password
    data_table_name = "tracker_events"
    copy_options    = "json 'auto'"



    processing_configuration {
      enabled = "false"
    }
  }

  s3_configuration {
    role_arn           = aws_iam_role.adiyaolu_pipeline_role.arn
    bucket_arn         = aws_s3_bucket.adiyaolus-3_bucket.arn
    buffer_interval    = "300"
    buffer_size        = "128"
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = "/aws/kinesisfirehose/tracker-event"
      log_stream_name = "S3Delivery"
    }
  }



}



resource "aws_iam_role" "adiyaolu_tracker-profile_role" {
  name = "firehose_tracker-profile_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "firehose.amazonaws.com",
          "redshift.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "adiyaolu-firehose_tracker-profile_role_policy" {
  name   = "pipeline_tracker-profile_role_policy"
  role   = aws_iam_role.adiyaolu_tracker-profile_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.adiyaolus-3_bucket.arn}",
        "${aws_s3_bucket.adiyaolus-3_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords"
      ],
      "Resource": "${aws_kinesis_stream.tracker-profile-attributes.arn}"
    }
  ]
}
EOF
}


resource "aws_kinesis_stream" "tracker-profile-attributes" {
  encryption_type  = "NONE"
  name             = "tracker-profile-attributes"
  retention_period = "24"
  shard_count      = "3"
}

resource "aws_kinesis_firehose_delivery_stream" "tfer--tracker-profile-attributes-7f1f2c74-201c-4755-817a-4865b5d8d6f0" {
  destination = "redshift"
  name        = "tracker-profile-attributes"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.tracker-profile-attributes.arn
    role_arn           = aws_iam_role.adiyaolu_tracker-profile_role.arn
  }



  redshift_configuration {
    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = "/aws/kinesisfirehose/tracker-profile-attributes"
      log_stream_name = "RedshiftDelivery"
    }
    role_arn        = aws_iam_role.adiyaolu_tracker-profile_role.arn
    cluster_jdbcurl = "jdbc:redshift://${aws_redshift_cluster.adiyaolu.endpoint}/${aws_redshift_cluster.adiyaolu.database_name}"
    username        = var.cluster_master_username
    password        = var.cluster_master_password
    data_table_name = "tracker_profile_attributes"
    copy_options    = "json 'auto'"
    processing_configuration {
      enabled = "false"
    }
  }
  s3_configuration {
    role_arn           = aws_iam_role.adiyaolu_tracker-profile_role.arn
    bucket_arn         = aws_s3_bucket.adiyaolus-3_bucket.arn
    buffer_interval    = "300"
    buffer_size        = "128"
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = "/aws/kinesisfirehose/tracker_profile_attributes"
      log_stream_name = "S3Delivery"
    }
  }
}


resource "aws_iam_role" "adiyaolu_tracker-sessions_role" {
  name = "firehose_tracker-sessions_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "firehose.amazonaws.com",
          "redshift.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "adiyaolu-firehose_tracker-sessions_role_policy" {
  name   = "pipeline_tracker-sessions_role_policy"
  role   = aws_iam_role.adiyaolu_tracker-sessions_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.adiyaolus-3_bucket.arn}",
        "${aws_s3_bucket.adiyaolus-3_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords"
      ],
      "Resource": "${aws_kinesis_stream.tracker-sessions.arn}"
    }
  ]
}
EOF
}


resource "aws_kinesis_stream" "tracker-sessions" {
  encryption_type  = "NONE"
  name             = "tracker-sessions"
  retention_period = "24"
  shard_count      = "2"
}

resource "aws_kinesis_firehose_delivery_stream" "tracker-sessions" {
  destination = "redshift"
  name        = "tracker-sessions"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.tracker-sessions.arn
    role_arn           = aws_iam_role.adiyaolu_tracker-sessions_role.arn
  }



  redshift_configuration {
    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = "/aws/kinesisfirehose/tracker-sessions"
      log_stream_name = "RedshiftDelivery"
    }
    role_arn        = aws_iam_role.adiyaolu_tracker-profile_role.arn
    cluster_jdbcurl = "jdbc:redshift://${aws_redshift_cluster.adiyaolu.endpoint}/${aws_redshift_cluster.adiyaolu.database_name}"
    username        = var.cluster_master_username
    password        = var.cluster_master_password
    copy_options    = "json 'auto'"
    data_table_name = "tracker_sessions"
    processing_configuration {
      enabled = "false"
    }
  }

  s3_configuration {
    role_arn           = aws_iam_role.adiyaolu_tracker-sessions_role.arn
    bucket_arn         = aws_s3_bucket.adiyaolus-3_bucket.arn
    buffer_interval    = "300"
    buffer_size        = "128"
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = "/aws/kinesisfirehose/tracker-sessions"
      log_stream_name = "S3Delivery"
    }
  }
}





resource "aws_iam_role" "adiyaolu_tracker-steps_role" {
  name = "firehose_tracker-steps_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "firehose.amazonaws.com",
          "redshift.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "adiyaolu-firehose_tracker-steps_role_policy" {
  name   = "pipeline_tracker-sessions_role_policy"
  role   = aws_iam_role.adiyaolu_tracker-steps_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "s3:AbortMultipartUpload",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.adiyaolus-3_bucket.arn}",
        "${aws_s3_bucket.adiyaolus-3_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords"
      ],
      "Resource": "${aws_kinesis_stream.tracker-steps.arn}"
    }
  ]
}
EOF
}


resource "aws_kinesis_stream" "tracker-steps" {
  encryption_type  = "NONE"
  name             = "tracker-steps"
  retention_period = "24"
  shard_count      = "5"
}

resource "aws_kinesis_firehose_delivery_stream" "tracker-steps" {
  destination = "redshift"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.tracker-steps.arn
    role_arn           = aws_iam_role.adiyaolu_tracker-steps_role.arn
  }

  name = "tracker-steps"

  redshift_configuration {
    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = "/aws/kinesisfirehose/tracker-steps"
      log_stream_name = "RedshiftDelivery"
    }
    role_arn        = aws_iam_role.adiyaolu_tracker-steps_role.arn
    cluster_jdbcurl = "jdbc:redshift://${aws_redshift_cluster.adiyaolu.endpoint}/${aws_redshift_cluster.adiyaolu.database_name}"
    username        = var.cluster_master_username
    password        = var.cluster_master_password
    copy_options    = "json 'auto'"
    data_table_name = "tracker_steps"
    processing_configuration {
      enabled = "false"
    }
  }

  s3_configuration {
    role_arn           = aws_iam_role.adiyaolu_tracker-steps_role.arn
    bucket_arn         = aws_s3_bucket.adiyaolus-3_bucket.arn
    buffer_interval    = "300"
    buffer_size        = "128"
    compression_format = "GZIP"

    cloudwatch_logging_options {
      enabled         = "true"
      log_group_name  = "/aws/kinesisfirehose/tracker_steps"
      log_stream_name = "S3Delivery"
    }
  }
}


resource "aws_cloudwatch_log_group" "tracker-events" {
  name = "/aws/kinesisfirehose/tracker-events"
}

resource "aws_cloudwatch_log_stream" "tracker-events" {
  name           = "RedshiftDelivery"
  log_group_name = aws_cloudwatch_log_group.tracker-events.name


}

resource "aws_cloudwatch_log_group" "tracker-profile-attributes" {
  name = "/aws/kinesisfirehose/tracker-profile-attributes"
}

resource "aws_cloudwatch_log_stream" "tracker-profile-attributes" {
  name           = "RedshiftDelivery"
  log_group_name = aws_cloudwatch_log_group.tracker-profile-attributes.name
}

resource "aws_cloudwatch_log_group" "tracker-sessions" {
  name = "/aws/kinesisfirehose/tracker-sessions"
}

resource "aws_cloudwatch_log_stream" "tracker-sessions" {
  name           = "RedshiftDelivery"
  log_group_name = aws_cloudwatch_log_group.tracker-sessions.name
}

resource "aws_cloudwatch_log_group" "tracker-steps" {
  name = "/aws/kinesisfirehose/tracker-steps"
}

resource "aws_cloudwatch_log_stream" "tracker-steps" {
  name           = "RedshiftDelivery"
  log_group_name = aws_cloudwatch_log_group.tracker-steps.name
}
