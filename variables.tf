variable "region" {
  type        = string
  description = "AWS Region"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "app_port" {
  type        = number
  description = "Port on which the application runs"
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
}

# variable "vpc_security_group_ids" {
#   description = "List of security group IDs to associate with the EC2 instance"
#   type        = list(string)
# }

variable "db_name" {
  type        = string
  description = "Name of the RDS database"
}

variable "db_username" {
  type        = string
  description = "Username for the RDS database"
}

variable "db_password" {
  type        = string
  description = "Password for the RDS database"
}

variable "db_port" {
  type        = number
  description = "DB Port for Postgres database"
}

variable "db_identifier" {
  type        = string
  description = "Identifier for the RDS database"
}
