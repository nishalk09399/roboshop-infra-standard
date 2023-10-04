variable "project_name" {
    default = "roboshop"
}


variable "env" {
    default = "dev"
}


variable "common_tags" {
  default = {
    Project = "roboshop"
    Component = "web"
    Environment = "DEV"
    Terraform = "true"
  }
}


variable "health_check" {
    default = {
    enabled = true
    healthy_threshold = 2     #we are just hitting url it will check weather it is working or not that is healthcheck
    interval = 15
    matcher = "200-299"
    path = "/"
    port        = 80
    protocol    = "HTTP"
    timeout = 5   
    unhealthy_threshold = 3    #we didnt get any response untill 3 sec consider it as unhealthy 
  }

}

variable "target_group_port" {
    default = 80
}

variable "launch_template_tags" {
    default = [
        {
            resource_type = "instance"

            tags = {
                Name = "web"
            }
        },
        {
            resource_type = "volume"

            tags = {
                Name = "web"
            }
        }


    ]
}

variable "autoscaling_tags" {

    default = [
        {
            key = "Name"
            value = "web"
            propagate_at_launch = "true"


        }, 
         {
            key = "Project"
            value = "roboshop"
            propagate_at_launch = "true"


        }
    ]
}

variable "rule_priority" {
    default = 10
}

variable "host_header" {
    default = "nishaldevops.online"
}