#output


output "s3_domain_name" {
  value       = aws_s3_bucket.website_bucket.website_endpoint 
  description = "s3 bucket domain name"
}

output "s3_id" {
  value       = aws_s3_bucket.website_bucket.id
  description = "s3 bucket id"
}


