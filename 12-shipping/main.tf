#first we are creating the target group for our shipping component

resource "aws_alb_target_group" "shipping" {
  name        = "${var.project_name}-${var.common_tags.Component}"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  health_check {
    enabled = true
    healthy_threshold = 2     #we are just hitting url it will check weather it is working or not that is healthcheck
    interval = 15
    matcher = "200-299"
    path = "/health"
    port        = 8080
    protocol    = "HTTP"
    timeout = 5   
    unhealthy_threshold = 3    #we didnt get any response untill 3 sec consider it as unhealthy 
  }
}

#below is shipping launch template 

resource "aws_launch_template" "shipping" {
  name = "${var.project_name}-${var.common_tags.Component}"

  image_id = data.aws_ami.devops_ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  vpc_security_group_ids = [data.aws_ssm_parameter.shipping_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "shipping"
    }
  }

  user_data = filebase64("${path.module}/shipping.sh")
}

#below we are creating shipping autoscalinggroup 


resource "aws_autoscaling_group" "shipping" {
  name                      = "${var.project_name}-${var.common_tags.Component}"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  target_group_arns = [aws_alb_target_group.shipping.arn]
  launch_template  {
    id =  aws_launch_template.shipping.id
    version = "$Latest"
  }

  vpc_zone_identifier       = split(",",data.aws_ssm_parameter.private_subnet_ids.value)

  tag {
    key                 = "Name"
    value               = "shipping"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

#below we are creating shipping autoscaling group policy

resource "aws_autoscaling_policy" "shipping" {
  autoscaling_group_name = aws_autoscaling_group.shipping.name
  name                   = "cpu"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

#below we are creating listerner rule for ALB

resource "aws_lb_listener_rule" "shipping" {
  listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  priority     = 40

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.shipping.arn
  }

  condition {
    host_header {
      values = ["shipping.app.nishaldevops.online"]
    }
  }
}