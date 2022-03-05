
## SSL Cert

#
# SSL certificates for CloudFront require us-east-1
#  make a sep
#



provider "aws" {
  alias = "acm"
  region = "us-east-1"
  profile  = var.profile
}


provider "aws" {
  alias = "dns"
  region = "us-east-1"
  profile  = var.dns_profile
}

data "aws_route53_zone" "zone" {
  provider = aws.dns
  name         = var.zone
}


resource "aws_cloudfront_distribution" "website_cdn" {
  enabled         = true
  is_ipv6_enabled = var.ipv6
  price_class     = var.price_class
  http_version    = "http2"

  origin {
    origin_id   = "origin-bucket-${var.origin_id}"
    domain_name = var.origin_domain_name

    dynamic "custom_header" {
        for_each = var.custom_header
		
	    content {   
			name = custom_header.key
			value = custom_header.value
        }
    }
 
    dynamic "s3_origin_config" {
      for_each = var.cloudfront_access_identity_path == "" ? [] : [1]
      content {
          origin_access_identity = var.cloudfront_access_identity_path
      }
    }
       
    dynamic "custom_origin_config" {
      for_each = var.cloudfront_access_identity_path != "" ? [] : [1]
      content {
          origin_protocol_policy = "http-only"
          http_port              = "80"
          https_port             = "443"
          origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
  }

  default_root_object = var.default_root_object

  default_cache_behavior {
    allowed_methods = var.allowed_methods
    cached_methods  = var.cached_methods

    forwarded_values {
      query_string = var.forward_query_string
	  headers      = var.forwarded_headers

      cookies {
        forward = "none"
      }
    }
	
	
	
//    dynamic "lambda_function_association" {
//       for_each = var.edge_lambada_names
//		
//	   content {   
//         event_type   = var.edge_lambada_event_types[index(var.edge_lambada_names,lambda_function_association.value)]
//         lambda_arn   = aws_lambda_function.s3_edge[index(var.edge_lambada_names,lambda_function_association.value)].qualified_arn
//         include_body = false 
//       }
//   }
	   

    min_ttl          = 0
    default_ttl      = "300"  //3600
    max_ttl          = "1200" //86400
    target_origin_id = "origin-bucket-${var.origin_id}"

    // This redirects any HTTP request to HTTPS. Security first!
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  custom_error_response {
    error_code = 404
    response_code =  200
    response_page_path = "/index.html"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  aliases = [var.domain]
  depends_on = [aws_acm_certificate_validation.cert]

}


resource "aws_acm_certificate" "cert" {
  provider = aws.acm
  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {
  provider = aws.acm
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.validation.fqdn]
}



resource "aws_route53_record" "alias" {
  provider = aws.dns
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                    = aws_cloudfront_distribution.website_cdn.domain_name
    zone_id                 = aws_cloudfront_distribution.website_cdn.hosted_zone_id
    evaluate_target_health  = false
  }
}


resource "aws_route53_record" "validation" {
  provider = aws.dns
  zone_id = data.aws_route53_zone.zone.zone_id
  name = element(tolist(aws_acm_certificate.cert.domain_validation_options[*].resource_record_name), 0)
  type = element(tolist(aws_acm_certificate.cert.domain_validation_options[*].resource_record_type), 0)
  records = [element(tolist(aws_acm_certificate.cert.domain_validation_options[*].resource_record_value), 0)]
  ttl = "300"
}






//data "archive_file" "lambda_zip" {
//    count = length(var.edge_lambada_names)	
//    type        = "zip"
//    source_file  = "${path.module}/${var.edge_lambada_names[count.index]}.js"
//    output_path = "${path.module}/${var.edge_lambada_names[count.index]}.zip"
//}


locals {
	name_prefix = replace(var.domain, ".", "_")
}



//resource "aws_lambda_function" "s3_edge" {
//  count = length(var.edge_lambada_names)			
//  function_name = "${local.name_prefix}-${var.edge_lambada_names[count.index]}"
//  filename      = data.archive_file.lambda_zip[count.index].output_path
//  source_code_hash = data.archive_file.lambda_zip[count.index].output_base64sha256
//  handler       = "${var.edge_lambada_names[count.index]}.handler"
//  description = "Lambda for adding Headers to S3 web through cloudfront"
//  
//  runtime = "nodejs12.x"
//  role          = aws_iam_role.lambda_edge_iam.arn
//  
//  publish = true
//  
//## must us east for cloud fround edge  
//  provider = aws.acm
//
//}



//resource "aws_cloudwatch_log_group" "edge_headers_lambda" {
//    count = length(var.edge_lambada_names)
//    name = "/aws/lambda/${aws_lambda_function.s3_edge[count.index].function_name}"
//    retention_in_days = 7
//}



//resource "aws_iam_role" "lambda_edge_iam" {
//  name = "${local.name_prefix}-edge-iam-role"
//   provider = aws.acm
//
//  assume_role_policy = <<-EOF
//  {
//    "Version": "2012-10-17",
//    "Statement": [
//      {
//        "Effect": "Allow",
//        "Principal": {
//          "Service": [
//            "s3.amazonaws.com",
//            "events.amazonaws.com",
//            "edgelambda.amazonaws.com",
//            "lambda.amazonaws.com"
//          ]
//        },
//        "Action": "sts:AssumeRole"
//      }
//    ]
//  }
//EOF
//}



//resource "aws_iam_role_policy" "lambda_edge" {
//  name_prefix = "lambda-edge-policy-"
//  role        = aws_iam_role.lambda_edge_iam.id
//  provider = aws.acm
//
//  policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Action": [
//        "logs:CreateLogStream",
//        "logs:PutLogEvents",
//        "logs:CreateLogGroup",
//        "s3:*"
//      ],
//      "Effect": "Allow",
//      "Resource": "*"
//    }
//  ]
//}
//EOF
//}













