resource "aws_s3_bucket" "config_buckett" {
  bucket        = var.bucket_name
  force_destroy = true
  acl           = "private"

  tags = {
    Name = "aws_config_buckett"
  }
}

resource "aws_iam_role" "config-role" {
  name = var.config-role

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
    "Action": "sts:AssumeRole",
     "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
      
     

    }
  ]
}

POLICY
}
## Attaching policy to above role
resource "aws_iam_policy_attachment" "adiyaolu-config" {
  name       = "adiyaolu-config"
  roles      = ["${aws_iam_role.config-role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AwsConfigRole"

  // depends_on = [
    
  // ]
}

## Adding for delivery channel
resource "aws_iam_role_policy" "config" {
  name = "awsconfig-adiyaolu"
  role = var.config-role

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
            "${aws_s3_bucket.config_buckett.arn}",
            "${aws_s3_bucket.config_buckett.arn}/*"
    ]
  }
  ]
}
POLICY
}
# creating aws configuration recorder
resource "aws_config_configuration_recorder" "adiyaolu-config" {
  name     = "adiyaolu-config-recorder"
  role_arn = aws_iam_role.config-role.arn

}
# creating aws configuration record status 
resource "aws_config_configuration_recorder_status" "adiyaolu" {
  name       = aws_config_configuration_recorder.adiyaolu-config.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.config-adiyaolu-delivery]
}

# creatinf aws delivery channel 
resource "aws_config_delivery_channel" "config-adiyaolu-delivery" {
  name           = "config-adiyaolu-delivery"
  s3_bucket_name = aws_s3_bucket.config_buckett.bucket
  depends_on     = [aws_config_configuration_recorder.adiyaolu-config]
}
