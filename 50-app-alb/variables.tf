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

variable "app_alb_tags" {
  default = {
    Componet = "app_alb"
  }
}
 variable "user_name"{
  default = "root"
 }
 variable"password"{
  default = "ExpenseApp1"
 }

 
variable "zone_name"{
  default = "inspiredevops.online"
}
