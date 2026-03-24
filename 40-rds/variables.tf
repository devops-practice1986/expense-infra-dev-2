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

variable "rds_tags" {
  default = {
    Componet = "rds"
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
