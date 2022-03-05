/**
 * ## VPC w/ DHCP Options
 *
 * This module creates the basic VPC and DHCP options resources.
 * Use this module in combination with the `subnet`, `nat-gateway`,
 * and related network modules.
 *
 */

locals {
  domain_name = (var.domain_name != "" ? var.domain_name : "${var.region}.compute.internal")
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    {
      "Name" = var.name_prefix
    },
    var.extra_tags,
  )
}


resource "aws_vpc_dhcp_options" "main" {
  domain_name         = local.domain_name
  domain_name_servers = var.dns_servers
  ntp_servers         = var.ntp_servers

  tags = merge(
    {
      "Name" = var.name_prefix
    },
    var.extra_tags,
  )
}

resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.main.id
}


resource "aws_cloudwatch_log_group" "vpc" {
    name = "/aws/vpc/${aws_vpc.main.id}"
    retention_in_days = 30
}


resource "aws_flow_log" "vpc" {
  count = var.flow_log_traffic_type == "NONE" ? 0 : 1
  iam_role_arn    = aws_iam_role.vpc.arn
  log_destination = aws_cloudwatch_log_group.vpc.arn
  traffic_type    = var.flow_log_traffic_type
  vpc_id          = aws_vpc.main.id
  
  log_format = "$${account-id} $${vpc-id} $${subnet-id} $${interface-id} $${srcaddr} $${srcport}  $${dstaddr} $${dstport} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"
}



resource "aws_iam_role" "vpc" {
  name = "${var.name_prefix}-vpc-iam-policy"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc" {
  name = "${var.name_prefix}-vpc-iam-role"
  role = aws_iam_role.vpc.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}





