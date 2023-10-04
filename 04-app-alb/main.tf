resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-${var.common_tags.Component}"
  internal           = true #private = internal here true defines it is private
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.private_subnet_ids.value) #atleast we nee to provide 2 subnets for high availablepurpose

   #enable_deletion_protection = true #accidental deletion it will prevent


  tags = var.common_tags
  
}

#providing listener

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"


  #this will add one listerner on port 80 and one default rule
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This is fixed response from the APP-ALB"
      status_code  = "200"
    }
   }
  }

  #creating one route 53 record because every time we launch the ALB the DNS name will change to keeping it sta
  #stable we are creating record

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = "nishaldevops.online"

  records = [
    {
      name    = "*.app"
      type    = "A"
      alias   = {
        name    = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
      }
    }
  ]
}
  

