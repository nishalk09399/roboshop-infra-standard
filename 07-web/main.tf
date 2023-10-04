module "web" {
    source = "../../terraform-roboshop-app"
    project_name = var.project_name
    env = var.env
    common_tags = var.common_tags

    #target group 
    health_check = var.health_check
    target_group_port = var.target_group_port
    vpc_id = data.aws_ssm_parameter.vpc_id.value


    #lauch template
     image_id = data.aws_ami.devops_ami.id
     security_group_id = data.aws_ssm_parameter.web_sg_id.value
     launch_template_tags = var.launch_template_tags
     user_data = filebase64("${path.module}/web.sh")

    #Auto scaling group 
    vpc_zone_identifier = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
    tag = var.autoscaling_tags

    #Auto scaling policy - I have given all the values in parent script 
    #only no mandatory values are there iam good with the parent script so, no resoruces are declaring here

    #listener rule
    alb_listener_arn = data.aws_ssm_parameter.web_alb_listener_arn.value
    rule_priority = var.rule_priority
    host_header = var.host_header



}