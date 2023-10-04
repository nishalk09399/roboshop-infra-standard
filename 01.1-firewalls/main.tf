
#this code we are writing for ELB,ASG,Listers,Rules etc., things we are combing and implementing the same to our robosho pproject
#vpn SG

#First run the 01-VPC script and then run this below script 
module "vpn_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "roboshop-vpn"
    sg_description = "Allowing all ports from my home"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_vpc.default.id
    common_tags = merge(
        var.common_tags, 
        {
            component = "VPN"
            Name = "roboshop-vpn"
        }
        
    )
}

#DB SG's

#mongodb SG
module "mongodb_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "mongodb"
    sg_description = "Allowing traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            Component = "Mongodb",
            Name = "Mongodb"
        }
        
    )
}

module "redis_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "redis"
    sg_description = "Allowing traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            Component = "redis",
            Name = "redis"
        }
        
    )
}

module "mysql_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "mysql"
    sg_description = "Allowing traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            Component = "mysql",
            Name = "mysql"
        }
        
    )
}

module "rabbitmq_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "rabbitmq"
    sg_description = "Allowing traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            Component = "rabbitmq",
            Name = "rabbitmq"
        }
        
    )
}

#Application SG's 

#catalogue SG
module "catalogue_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "catalogue"
    sg_description = "Allowing all port"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            component = "catalogue",
            Name = "catalogue"
        }
        
    )
    }

module "user_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "user"
    sg_description = "Allowing traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            Component = "user",
            Name = "user"
        }
        
    )
}

module "cart_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "cart"
    sg_description = "Allowing traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            Component = "cart",
            Name = "cart"
        }
        
    )
}
module "shipping_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "shipping"
    sg_description = "Allowing traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            Component = "shipping",
            Name = "shipping"
        }
        
    )
}

module "payment_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "payment"
    sg_description = "Allowing traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            Component = "payment",
            Name = "payment"
        }
        
    )
}

#App alb SG

module "app_alb_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "App-ALB"
    sg_description = "Allowing all traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            component = "App",
            Name = "App-ALB"
        }
        
    )
    }





#web SG
module "web_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "web"
    sg_description = "Allowing all traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            Component = "web"
            
        }
        
    )
    }


#web alb SG
module "web_alb_sg" {
    source = "../../terraform-aws-securitygroup"
    project_name = var.project_name
    sg_name = "WEB-ALB"
    sg_description = "Allowing all traffic"
    #sg_ingress_rules = var.sg_ingress_rules
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    common_tags = merge(
        var.common_tags, 
        {
            component = "Web",
            Name = "Web-ALB"
        }
        
        
    )
    }


#this are the security groups rules we are allowing which component need to connect with each other - Rules 


resource "aws_security_group_rule" "vpn" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.vpn_sg.security_group_id
}

#rules for mongodb DB

resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  description = "Allowing port 27017 from catalogue"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.security_group_id
}

resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  description = "Allowing port 27017 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.security_group_id
}

resource "aws_security_group_rule" "mongodb_user" {
  type              = "ingress"
  description = "Allowing port number 27017 from user"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mongodb_sg.security_group_id
}

#rules for redis DB


resource "aws_security_group_rule" "redis_user" {
  type              = "ingress"
  description = "Allowing port 6379 from user"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.security_group_id
}

resource "aws_security_group_rule" "redis_vpn" {
  type              = "ingress"
  description = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.security_group_id
}

resource "aws_security_group_rule" "redis_cart" {
  type              = "ingress"
  description = "Allowing port number 6379 from cart"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.redis_sg.security_group_id

}

#Mysql DB Rules

resource "aws_security_group_rule" "mysql_shipping" {
  type              = "ingress"
  description = "Allowing port number 3306 from shipping"
  from_port         = 3306 
  to_port           = 3306 
  protocol          = "tcp"
  source_security_group_id = module.shipping_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mysql_sg.security_group_id
}

resource "aws_security_group_rule" "mysql_vpn" {
  type              = "ingress"
  description = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.mysql_sg.security_group_id
}

#Rabbitmq DB Rules 

resource "aws_security_group_rule" "rabbitmq_payment" {
  type              = "ingress"
  description = "Allowing port number 5672 from payment"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.rabbitmq_sg.security_group_id
}

resource "aws_security_group_rule" "rabbitmq_vpn" {
  type              = "ingress"
  description = "Allowing port number 22 from vpn to connect"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.rabbitmq_sg.security_group_id
}

#Application SG rules
#catalogue Application Rules 

resource "aws_security_group_rule" "catalogue_vpn" {
  type              = "ingress"
  description = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.catalogue_sg.security_group_id
}


resource "aws_security_group_rule" "catalogue_app_alb" {
  type              = "ingress"
  description = "Allowing port 8080 from app alb"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.catalogue_sg.security_group_id
}

#User Application Rules 

resource "aws_security_group_rule" "user_app_alb" {
  type              = "ingress"
  description = "Allowing port 8080 from app alb"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.user_sg.security_group_id
}

resource "aws_security_group_rule" "user_vpn" {
  type              = "ingress"
  description = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.user_sg.security_group_id
}

#cart Application Rules 

resource "aws_security_group_rule" "cart_app_alb" {
  type              = "ingress"
  description = "Allowing port 8080 from app alb"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.cart_sg.security_group_id
}

resource "aws_security_group_rule" "cart_vpn" {
  type              = "ingress"
  description = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.cart_sg.security_group_id
}

#shipping Application Rules 

resource "aws_security_group_rule" "shipping_app_alb" {
  type              = "ingress"
  description = "Allowing port 8080 from app alb"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.shipping_sg.security_group_id
}

resource "aws_security_group_rule" "shipping_vpn" {
  type              = "ingress"
  description = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.shipping_sg.security_group_id
}

#Payment Application Rules

resource "aws_security_group_rule" "payment_app_alb" {
  type              = "ingress"
  description = "Allowing port 8080 from app alb"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.payment_sg.security_group_id
}

resource "aws_security_group_rule" "payment_vpn" {
  type              = "ingress"
  description = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.payment_sg.security_group_id
}


#Application LB to VPN Connection rule

resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  description = "Allowing port 80 from vpn"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

#Application LB to WEB Connection rule

resource "aws_security_group_rule" "app_alb_web" {
  type              = "ingress"
  description = "Allowing port 80 from web"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

#this are the rules that which are adding that example catalogue should accept connection on 80 from App ALB

resource "aws_security_group_rule" "app_alb_catalogue" {
  type              = "ingress"
  description = "Allowing port number 80 from catalogue"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_user" {
  type              = "ingress"
  description = "Allowing port number 80 from user"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.user_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_cart" {
  type              = "ingress"
  description = "Allowing port number 80 from cart"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_shipping" {
  type              = "ingress"
  description = "Allowing port number 80 from shipping"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.shipping_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}

resource "aws_security_group_rule" "app_alb_payment" {
  type              = "ingress"
  description = "Allowing port number 80 from payment"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.payment_sg.security_group_id
  #cidr_blocks       = ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.app_alb_sg.security_group_id
}


#WEB  connection rules

resource "aws_security_group_rule" "web_vpn" {
  type              = "ingress"
  description = "Allowing port 80 from vpn"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_sg.security_group_id
}

#allwoing port num - 22 to connect the instance through the roboshop-vpn server to web server
resource "aws_security_group_rule" "web_vpn_ssh" {
  type              = "ingress"
  description = "Allowing port 22 from vpn"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_sg.security_group_id
}

#web to public
resource "aws_security_group_rule" "web_web_alb" {
  type              = "ingress"
  description = "Allowing port 80 from web alb"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb_sg.security_group_id
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_sg.security_group_id
}

#web to internet
resource "aws_security_group_rule" "web_alb_internet" {
  type              = "ingress"
  description = "Allowing port 80 from web int"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_alb_sg.security_group_id
}

#web to internet through https
resource "aws_security_group_rule" "web_alb_internet_https" {
  type              = "ingress"
  description = "Allowing port 80 from web alb through https"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  #cidr_blocks       =  ["${chomp(data.http.myip.body)}/32"]
  #ipv6_cidr_blocks  = [aws_vpc.example.ipv6_cidr_block]
  security_group_id = module.web_alb_sg.security_group_id
}
