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

variable "zone_name" {
  default = "inspiredevops.online"
}

variable "zone_id"{
  default = "Z04732553GGREX7ES29MF"
}