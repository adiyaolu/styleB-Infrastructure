## S3-Site


resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  force_destroy = true
  acl  = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

}


resource "aws_s3_bucket_policy" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = <<-POLICY
  {
   "Version": "2012-10-17",
   "Statement": [
    {
      "Sid": "PublicReadAccess",
      "Principal": {
        "AWS": "*"
      },
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
            "${aws_s3_bucket.website_bucket.arn}",
            "${aws_s3_bucket.website_bucket.arn}/*"]
    }
    ]
  }
  POLICY
}

/*
resource "aws_s3_bucket_policy" "website_deployer" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = <<-POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:ListBucket"
        ],
        "Effect": "Allow",
        "Principal" : { "AWS" : "*" },
        "Resource": "${aws_s3_bucket.website_bucket.arn}/*"
      },
      {
      "Action": [
        "s3:DeleteObject",
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.website_bucket.arn}/*"
    }
    ]
  }
  POLICY
}
*/

