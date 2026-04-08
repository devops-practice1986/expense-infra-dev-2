module "mysql_sg" {
  #source       = "../../terraform-aws-security-group"
  source       = "git::https://github.com/devops-practice1986/terraform-aws-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "mysql"
  vpc_id       = local.value
  common_tags  = var.common_tags
  sg_tags      = var.mysql_sg_tags
}

module "backend_sg" {
  source       = "git::https://github.com/devops-practice1986/terraform-aws-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "backend"
  vpc_id       = local.value
  common_tags  = var.common_tags
  sg_tags      = var.backend_sg_tags
}

module "frontend_sg" {
  source       = "git::https://github.com/devops-practice1986/terraform-aws-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "frontend"
  vpc_id       = local.value
  common_tags  = var.common_tags
  sg_tags      = var.frontend_sg_tags
}

module "bastion_sg" {
  source       = "git::https://github.com/devops-practice1986/terraform-aws-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "bastion"
  vpc_id       = local.value
  common_tags  = var.common_tags
  sg_tags      = var.bastion_sg_tags
}

module "ansible_sg" {
  source       = "git::https://github.com/devops-practice1986/terraform-aws-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "ansible"
  vpc_id       = local.value
  common_tags  = var.common_tags
  sg_tags      = var.ansible_sg_tags
}

module "app_alb_sg" {
  source       = "git::https://github.com/devops-practice1986/terraform-aws-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "app_alb"
  vpc_id       = local.value
  common_tags  = var.common_tags
  sg_tags      = var.app_alb_sg_tags
}

module "web_alb_sg" {
  source       = "git::https://github.com/devops-practice1986/terraform-aws-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "web_alb"
  vpc_id       = local.value
  common_tags  = var.common_tags
  sg_tags      = var.web_alb_sg_tags
}


module "vpn_sg" {
  source       = "git::https://github.com/devops-practice1986/terraform-aws-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  sg_name      = "vpn"
  vpc_id       = local.value
  common_tags  = var.common_tags
}
# ******************THESE ARE SG RULES*******************************
# Seurity group rules to mysql on 3306
# MySql allowing connection on 3306 from the instances attached to backend SG
resource "aws_security_group_rule" "mysql_backend" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend_sg.id # this is link from mysql to backend
  security_group_id        = module.mysql_sg.id   # enter the rule into mysql
}

# Backend allowing connection on 8080 from the instances atteched to frontend SG
# resource "aws_security_group_rule" "backend_frontend" {
#   type                     = "ingress"
#   from_port                = 8080
#   to_port                  = 8080
#   protocol                 = "tcp"
#   source_security_group_id = module.frontend_sg.id # this is link from backend to frontend  
#   security_group_id        = module.backend_sg.id  # enter the rule into backend
# }


# # frontend allowing connection on 80 from the instances atteched to public SG
# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]         # this is link from frontend to public
#   security_group_id = module.frontend_sg.id # enter the rule into frontend}
# }

#*********************RULES FOR BASTION*************************
# for employee purpose to connect to the servers
# resource "aws_security_group_rule" "mysql_bastion" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   source_security_group_id = module.bastion_sg.id # this is link from mysql to backend # this is link from mysql to backend
#   security_group_id        = module.mysql_sg.id   # enter the rule into frontend}
# }

resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id        = module.mysql_sg.id
}
resource "aws_security_group_rule" "backend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id        = module.backend_sg.id
}
resource "aws_security_group_rule" "frontend_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id
  security_group_id        = module.frontend_sg.id
}

#*********************RULES FOR ANSIBLE*************************
# for employee purpose to connect to the servers
# resource "aws_security_group_rule" "mysql_ansible" {
#   type                     = "ingress"
#   from_port                = 22
#   to_port                  = 22
#   protocol                 = "tcp"
#   source_security_group_id = module.ansible_sg.id # this is link from mysql to backend # this is link from mysql to backend
#   security_group_id        = module.mysql_sg.id   # enter the rule into frontend}
# }

resource "aws_security_group_rule" "backend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id # this is link from mysql to backend # this is link from backend to frotned
  security_group_id        = module.backend_sg.id # enter the rule into backend
}

resource "aws_security_group_rule" "frontend_ansible" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.ansible_sg.id  # this is link from mysql to backend # this is link from backend to frotned
  security_group_id        = module.frontend_sg.id # enter the rule into backend
}

resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]        # this is link from mysql to backend # this is link from backend to frotned
  security_group_id = module.ansible_sg.id # enter the rule into backend
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]        # this is link from mysql to backend # this is link from backend to frotned
  security_group_id = module.bastion_sg.id # enter the rule into backend
}

resource "aws_security_group_rule" "backend_app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.app_alb_sg.id
  security_group_id        = module.backend_sg.id
}
resource "aws_security_group_rule" "app_alb_bastion" { # backend accepting connect from app_alb
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion_sg.id # traffic is comming from ALB SG
  security_group_id        = module.app_alb_sg.id # rules will be added in backend SG
}

# *********VPN PORTS OPEN**************
# VPN Ports: 22, 943, 443, 1194
resource "aws_security_group_rule" "vpn_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.id
}
resource "aws_security_group_rule" "vpn_public_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.id
}

resource "aws_security_group_rule" "vpn_public_493" {
  type              = "ingress"
  from_port         = 493
  to_port           = 493
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.id
}

resource "aws_security_group_rule" "vpn_public_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.id
}
resource "aws_security_group_rule" "vpn_public_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.id
}

# connects app_alb from vpn
resource "aws_security_group_rule" "app_alb_vpn" { # vpn to app_alb
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.id
  security_group_id        = module.app_alb_sg.id
}

# connects backend from vpn
resource "aws_security_group_rule" "backend_vpn" { # vpn to backend
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.id # traffice from vpn
  security_group_id        = module.backend_sg.id
}

resource "aws_security_group_rule" "backend_vpn_8080" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.vpn_sg.id
  security_group_id        = module.backend_sg.id
}

resource "aws_security_group_rule" "web_alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.id
}

resource "aws_security_group_rule" "web_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.id
}

resource "aws_security_group_rule" "frontend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.id
  security_group_id = module.frontend_sg.id
}

resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb_sg.id
  security_group_id = module.frontend_sg.id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.frontend_sg.id
  security_group_id = module.app_alb_sg.id
  
}
