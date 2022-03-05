## S3-Site


resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  acl  =  "log-delivery-write"
  force_destroy = true

  versioning {
     enabled    = false
  }


}


resource "aws_s3_bucket_policy" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = <<-POLICY
  {
   "Version": "2012-10-17",
   "Statement": [
       {
           "Action": "s3:GetBucketAcl",
           "Effect": "Allow",
           "Resource": "arn:aws:s3:::${var.bucket_name}",
           "Principal": 
		    { 
				"AWS": "*"
			}
       },
       {
           "Action": "s3:PutObject" ,
           "Effect": "Allow",
           "Resource": "arn:aws:s3:::${var.bucket_name}/*",
           "Principal": 
		   { 
			   "AWS": "*"
		   }
       }
   ]
  }
  POLICY
}

