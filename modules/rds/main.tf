
data "aws_vpc" "adiyaolu" {
  id = var.vpc_id
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = data.aws_vpc.adiyaolu.id
  availability_zone = "us-east-1a"
  cidr_block        = var.private_subnet_cidrs_1


  tags = {
    Name = "adiyaolu_private_subnet1"
  }

}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = data.aws_vpc.adiyaolu.id
  availability_zone = "us-east-1b"
  cidr_block        = var.private_subnet_cidrs_2
  tags = {
    Name = "adiyaolu_private_subnet2"
  }
}

data "aws_subnet" "adiyaolu_public_subnet" {
  id = var.data_public_subnet

}

resource "aws_nat_gateway" "adiyaolu_nat" {
  connectivity_type = "private"
  subnet_id         = data.aws_subnet.adiyaolu_public_subnet.id

  tags = {
    Name = "adiyaolu_nat"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.adiyaolu.id

  route {
    cidr_block     = "0.0.0.0/0"
   nat_gateway_id = aws_nat_gateway.adiyaolu_nat.id
  }
  tags = {
    Name = "adiyaolu_private_routetable"
  }
}



resource "aws_route_table_association" "nated_subnet_association" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "nated_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_db_subnet_group" "adiyaolu_subnetgroup" {
  name       = "var.subnet_group"
  subnet_ids = ["${aws_subnet.private_subnet_1.id}", "${aws_subnet.private_subnet_2.id}"]

  tags = {
    Name = "adiyaolu_subnetgroup"
  }
}


resource "aws_security_group" "adiyaolu_db-rules" {
  name   = "backend-sg"
  description = "backend rules"
  vpc_id = var.vpc_id

  ingress {
    description = "aurora-postgres"
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/20", "10.1.16.0/20"]
  }

  ingress {
    description = "redshift"
    from_port   = "5439"
    to_port     = "5439"
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/20", "10.1.16.0/20", "52.70.63.192/27"]

    
  }

  ingress {
    description = "elasticache_port"
    from_port   = "6379"
    to_port     = "6379"
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/20", "10.1.16.0/20"]

  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  tags = {
    name = "adiyaolu_sg"
  }
}

resource "aws_rds_cluster" "adiyaolu" {
  cluster_identifier        = var.adiyaolu_db
  database_name             = var.adiyaolu_db
  engine                    = "aurora-postgresql"
  db_subnet_group_name      = aws_db_subnet_group.adiyaolu_subnetgroup.id
  vpc_security_group_ids    = [aws_security_group.adiyaolu_db-rules.id]
  final_snapshot_identifier = false #to be set to true 
  skip_final_snapshot       = true
  storage_encrypted         = true
  deletion_protection       = false #to be set to true when been finally deployed
}


resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier         = "adiyaoludb"
  cluster_identifier = aws_rds_cluster.adiyaolu.id
  instance_class     = "db.t3.medium"
  engine             = "aurora-postgresql"
  engine_version     = "12.7"
}


// resource "aws_sns_topic" "alarm" {
//   name                    = "${var.cluster_name}-alarms-topic"
//   delivery_policy         = <<-EOF
//                             {
//                               "http": {
//                                 "defaultHealthyRetryPolicy": {
//                                   "minDelayTarget": 20,
//                                   "maxDelayTarget": 20,
//                                   "numRetries": 3,
//                                   "numMaxDelayRetries": 0,
//                                   "numNoDelayRetries": 0,
//                                   "numMinDelayRetries": 0,
//                                   "backoffFunction": "linear"
//                                 },
//                                 "disableSubscriptionOverrides": false,
//                                 "defaultThrottlePolicy": {
//                                   "maxReceivesPerSecond": 1
//                                 }
//                               }
//                             }
//                             EOF


// }


resource "aws_cloudwatch_metric_alarm" "database-storage-low-alarm" {
  alarm_name        = "database-storage-low-alarm"
  alarm_description = "This metric monitors database storage dipping below threshold"
  #alarm_actions             = ["${var.alerts_arn}"]
  comparison_operator = "LessThanThreshold"
  threshold           = "20"
  evaluation_periods  = "2"
  metric_name         = "FreeStorageSpace"
  namespace           = "RDS"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    DBInstanceIdentifier = "${aws_rds_cluster_instance.cluster_instances.id}"
  }
}


