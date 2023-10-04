#first we are creating the target group for our cart component

module "payment" {
  source = "../../terraform-roboshop-app"
  project_name = var.project_name
  env = var.env
  common_tags = var.common_tags

  #target group
  
  target_group_port = var.target_group_port
  vpc_id = data.aws_ssm_parameter.vpc_id.value

  #launch template
  image_id = data.aws_ami.devops_ami.id
  security_group_id = data.aws_ssm_parameter.payment_sg_id.value
  user_data = filebase64("${path.module}/payment.sh")
  launch_template_tags = var.launch_template_tags

  #autoscaling
  vpc_zone_identifier = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  tag = var.autoscaling_tags

  #autoscalingpolicy - Looks good 

  #listener rule
  alb_listener_arn = data.aws_ssm_parameter.app_alb_listener_arn.value
  rule_priority = 50 
  host_header = "payment.app.nishaldevops.online"

}