variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "expense"
    Environment = "dev"
    Terraform   = true
  }
}

# for mysql sg
variable "mysql_sg_tags" {
  default = {
    Component = "mysql"
  }
}
# for backend sg
variable "backend_sg_tags" {
  default = {
    Component = "backend"
  }
}

# for frontend sg
variable "frontend_sg_tags" {
  default = {
    Component = "frontend"
  }
}

# for bastian sg
variable "bastion_sg_tags" {
  default = {
    Component = "bastian"
  }
}

variable "ansible_sg_tags" {
  default = {
    Component = "ansible"
  }
}

variable "app_alb_sg_tags"{
  default = {
    Component = "app_alb"
  }
}

variable "web_alb_sg_tags"{
  default = {
    Component = "web_alb"
  }
}