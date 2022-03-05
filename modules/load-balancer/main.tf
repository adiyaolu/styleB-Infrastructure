##  load-balancer-ssl



provider "aws" {
  alias = "dns"
  region = "us-east-1"
  profile  = var.dns_profile
}

data "aws_route53_zone" "zone" {
  provider = aws.dns
  name     = var.zone
}


### Security Group 
resource "aws_security_group" "lb_sg" {
  name   = "${var.name_prefix}-lb-sg"
  vpc_id = var.vpc_id
  
  tags = merge(
   {
     "Name" = "${var.base_description} Load Balancer Security Group"
   },
   var.extra_tags,
 )
  
}

# Open ingress traffic SSH port


resource "aws_security_group_rule" "lb_sg_ingress" {
  count             = length(var.sg_ingress_ports)
	
  type              = "ingress"
  description       = "Open Input for 443"
  from_port         = var.sg_ingress_ports[count.index]
  to_port           = var.sg_ingress_ports[count.index]
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
  depends_on        = [aws_security_group.lb_sg]
  
}
   
# Open egress traffic
 
resource "aws_security_group_rule" "lb_sg_egress" {
  depends_on        = [aws_security_group.lb_sg]
  type              = "egress"
  description       = "OPEN egress, all ports, all protocols"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}



resource "aws_lb" "lb" {
  name               = "${var.name_prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  access_logs {
    bucket  = var.log_bucket
    prefix  = "${var.name_prefix}-lb"
    enabled = var.logs_enabled
  }

}

resource "aws_lb_listener" "lb-ssl" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Load Balancer"
      status_code  = "200"
    }
  }
  
  depends_on = [aws_lb.lb, aws_acm_certificate.cert]
}

resource "aws_lb_listener" "lb-redirect" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



# note the providor of the Cert for Load balancers need to be the in the same
# regoon as the LB,  (as apposed to Cloud Front certs which need to be in US-East-1)

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.validation.fqdn]
}


resource "aws_route53_record" "alias" {
  provider = aws.dns
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                    = aws_lb.lb.dns_name
    zone_id                 = aws_lb.lb.zone_id 
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
























