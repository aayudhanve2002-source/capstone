variable "aws_region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "three-tier-app"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "db_username" {
  default = "aayush"
}
variable "db_password" {
  default = "aayush7678"
  sensitive = true
}

variable "frontend_instance_type" { default = "t3.micro" }
variable "backend_instance_type"  { default = "t3.micro" }

variable "frontend_min_size" { default = 1 }
variable "frontend_max_size" { default = 3 }
variable "frontend_desired_capacity" { default = 1 }

variable "backend_min_size" { default = 1 }
variable "backend_max_size" { default = 3 }
variable "backend_desired_capacity" { default = 1 }