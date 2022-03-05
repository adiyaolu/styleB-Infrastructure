
// resource "aws_s3_bucket" "adiyaolu_guard" {
//   bucket        = var.bucket_name
//   force_destroy = true
//   acl           = "private"

//   tags = {
//     Name = "adiyaolu-guardduty"
//   }
// }

// # -----------------------------------------------------------
// # seting up policy 
// # -----------------------------------------------------------

// resource "aws_iam_policy" "enable_guardduty" {
//   name        = "enable-guardduty"
//   description = "Allows full access to the contents of the security bucket"

//   policy = <<EOF
// {
//   "Version": "2012-10-17",
//   "Statement": [
//     {
//       "Effect": "Allow",
//       "Action": "s3:ListAllMyBuckets",
//       "Resource": "arn:aws:s3:::*"
//     },
//     {
//       "Effect": "Allow",
//       "Action": "s3:*",
//       "Resource": [
//         "${aws_s3_bucket.adiyaolu_guard.arn}",
//         "${aws_s3_bucket.adiyaolu_guard}/*"
//       ]
//     }
//   ]
// }
// EOF
// }


# -----------------------------------------------------------
# enable guard duty
# -----------------------------------------------------------
resource "aws_guardduty_detector" "guardduty" {
  enable = true
}

