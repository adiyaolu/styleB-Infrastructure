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


data "aws_lb" "lb" {
  name = var.lb_name
}

data "aws_lb_listener" "listener443" {
  load_balancer_arn = data.aws_lb.lb.arn
  port              = 443
}


resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn =  data.aws_lb_listener.listener443.arn
  priority     = var.rule_priority 

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb.arn
  }

  condition {
    host_header {
      values = [ var.domain ]
    }
  }
}

resource "aws_lb_listener_certificate" "lb" {
  listener_arn    = data.aws_lb_listener.listener443.arn
  certificate_arn = aws_acm_certificate.cert.arn
  depends_on = ["aws_acm_certificate_validation.cert"]
}


resource "aws_lb_target_group" "lb" {
  name = "${var.name_prefix}-ecs-lb-tg"
  port     = var.target_group_port
  target_type = var.target_type
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  slow_start = var.warmup_time
  
  
  health_check {
	enabled = var.health_check_enabled ? true : false
    interval = var.health_check_interval
	path = var.health_check_path
	timeout = var.health_check_timeout
	unhealthy_threshold = var.health_check_unhealthy_threshold
	healthy_threshold = var.health_check_healthy_threshold
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
    name                    = data.aws_lb.lb.dns_name
    zone_id                 = data.aws_lb.lb.zone_id 
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
























