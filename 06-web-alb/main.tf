#below is the web alb 

resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.common_tags.Component}"
  internal           = false #private = internal here true defines it is private, false is public
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_ids.value) #atleast we nee to provide 2 subnets for high availablepurpose



  tags = var.common_tags
  
}
#below is the certificate ACM 

resource "aws_acm_certificate" "nishaldevops" {
  domain_name       = "nishaldevops.online"
  validation_method = "DNS"
  tags = var.common_tags
}

data "aws_route53_zone" "nishaldevops" {
  name         = "nishaldevops.online"
  private_zone = false
}

#this will create the records 
resource "aws_route53_record" "nishaldevops" {
  for_each = {
    for dvo in aws_acm_certificate.nishaldevops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.nishaldevops.zone_id
}

#this is for validation

resource "aws_acm_certificate_validation" "nishaldevops" {
  certificate_arn         = aws_acm_certificate.nishaldevops.arn
  validation_record_fqdns = [for record in aws_route53_record.nishaldevops : record.fqdn]
}

#this is listerner for the web alb

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.nishaldevops.arn

  default_action {
    type = "fixed-response"  # we are giving here fixed response for the testing purpose

    fixed_response {
      content_type = "text/plain"
      message_body = "This is the fixed response from the web alb HTTTPS"
      status_code  = "200"
    }
  }
}

#creating the route 53 record for web alb

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = "nishaldevops.online"

  records = [
    {
      name    = ""
      type    = "A"
      alias   = {
        name    = aws_lb.web_alb.dns_name
        zone_id = aws_lb.web_alb.zone_id
      }
    }
  ]
}
