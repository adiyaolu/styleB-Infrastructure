#the id will have to be changed everytime infrastructure is destroyed and redeployed 
data "aws_subnet" "adiyaolu_private_subnet_1" {
  id = "subnet-0783e7701c2113c77"

}

#the id will have to be changed everytime infrastructure is destroyed and redeployed 
data "aws_subnet" "adiyaolu_private_subnet_2" {
  id = "subnet-098a10528e4a7380f"
}


resource "aws_redshift_subnet_group" "adiyaolu" {
  name       = var.base_name
  subnet_ids = [data.aws_subnet.adiyaolu_private_subnet_1.id, data.aws_subnet.adiyaolu_private_subnet_2.id]

  tags = {
    environment = "env"
  }
}


#the id will have to be changed everytime infrastructure is destroyed and redeployed 
data "aws_security_group" "backend" {
  id = "sg-00219931cb2f329d4"
}


resource "aws_redshift_cluster" "adiyaolu" {
  cluster_identifier           = var.base_name
  node_type                    = var.cluster_node_type
  number_of_nodes              = var.cluster_number_of_nodes
  cluster_type                 = var.cluster_number_of_nodes
  database_name                = "adiyaolu_redshift"
  master_username              = var.cluster_master_username
  master_password              = var.cluster_master_password
  cluster_subnet_group_name    = aws_redshift_subnet_group.adiyaolu.id
  cluster_parameter_group_name = aws_redshift_parameter_group.adiyaolu.id
  vpc_security_group_ids       = [data.aws_security_group.backend.id]

  publicly_accessible = var.publicly_accessible
  encrypted           = var.encrypted
}


resource "aws_redshift_parameter_group" "adiyaolu" {
  name   = "parameter-group-test-terraform"
  family = var.redshift_parameter_family

  parameter {
    name  = "require_ssl"
    value = "false"
  }

  parameter {
    name  = "auto_analyze"
    value = "true"
  }

  parameter {
    name  = "enable_user_activity_logging"
    value = "false"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_metric_alarm" "redshift_disk_space_alarm" {
  alarm_name          = "${var.application}-redshift-${var.environment}-disk-alarm"
  alarm_description   = "Remaining Redshift disk space below threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  period              = 60
  threshold           = 75 # Redshift metric is in percentage already
  namespace           = "AWS/Redshift"
  metric_name         = "PercentageDiskSpaceUsed"
  statistic           = "Average"

  dimensions = {
    ClusterIdentifier = "${aws_redshift_cluster.adiyaolu.id}"
  }

  alarm_actions = ["arn:aws:sns:us-east-1:859456250655:adiyaolu-test-slack-notifications-test"]
  ok_actions = [

  ]
}

resource "aws_iam_role" "sns_notify_slack_lambda_role" {
  name = "${var.application}-sns-notify-slack-${var.environment}-lambda-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.environment}-${var.application}-lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.sns_notify_slack_lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}



resource "aws_sns_topic" "sns_notify_slack_topic" {
  name = "${var.application}-slack-notifications-${var.environment}"
}

resource "aws_sns_topic_subscription" "sns_notify_slack_subscription" {
  topic_arn = aws_sns_topic.sns_notify_slack_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.sns_notify_slack_lambda.arn
}


module "metric_alarmCPUUltilization" {
  source = "./module/metric_alarm"

  alarm_name          = "Redshift-CPUUltilization-alarm"
  alarm_description   = "cpu-ultilization-for-redshift"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 75
  period              = 60
  unit                = "Count"

  namespace           = "AWS/Redshift"
  metric_name         = "CPUUtilization"
  statistic           = "Average"

  alarm_actions = ["arn:aws:sns:us-east-1:859456250655:adiyaolu-test-slack-notifications-test"]


 dimensions = {
    ClusterIdentifier = "${aws_redshift_cluster.adiyaolu.id}"
  }
}


module "metric_alarmHealth" {
  source = "./module/metric_alarm"

  alarm_name          = "Redshift-health-alarm"
  alarm_description   = "HealthStatus-for-redshift"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 75
  period              = 60
  unit                = "Count"

  namespace           = "AWS/Redshift"
  metric_name         = "HealthStatus"
  statistic           = "Average"

  alarm_actions = ["arn:aws:sns:us-east-1:859456250655:adiyaolu-test-slack-notifications-test"]


 dimensions = {
    ClusterIdentifier = "${aws_redshift_cluster.adiyaolu.id}"
  }
}


module "metric_alarmWriteThroughput" {
  source = "./module/metric_alarm"

  alarm_name          = "Redshift-WriteThroughput"
  alarm_description   = "WriteThroughput-for-redshift"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 75
  period              = 60
  unit                = "Count"

  namespace           = "AWS/Redshift"
  metric_name         = "WriteThroughput"
  statistic           = "Average"

  alarm_actions = ["arn:aws:sns:us-east-1:859456250655:adiyaolu-test-slack-notifications-test"]


 dimensions = {
    ClusterIdentifier = "${aws_redshift_cluster.adiyaolu.id}"
  }
}


module "metric_alarmWriteLatency" {
  source = "./module/metric_alarm"

  alarm_name          = "Redshift-WriteLatency"
  alarm_description   = "WriteLatency-for-redshift"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 75
  period              = 60
  unit                = "Count"

  namespace           = "AWS/Redshift"
  metric_name         = "WriteLatency"
  statistic           = "Average"

  alarm_actions = ["arn:aws:sns:us-east-1:859456250655:adiyaolu-test-slack-notifications-test"]


 dimensions = {
    ClusterIdentifier = "${aws_redshift_cluster.adiyaolu.id}"
  }
}





module "metric_alarmReadThroughput" {
  source = "./module/metric_alarm"

  alarm_name          = "Redshift-ReadThroughput"
  alarm_description   = "ReadThroughput-for-redshift"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 75
  period              = 60
  unit                = "Count"

  namespace           = "AWS/Redshift"
  metric_name         = "ReadThroughput"
  statistic           = "Average"

  alarm_actions = ["arn:aws:sns:us-east-1:859456250655:adiyaolu-test-slack-notifications-test"]


 dimensions = {
    ClusterIdentifier = "${aws_redshift_cluster.adiyaolu.id}"
  }
}