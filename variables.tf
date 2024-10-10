# variable "cidr" {
#   type = string
#   #   default     = "10.0.0.0/16"
#   description = ""
# }


variable "region" {
  type        = string
  description = "AWS Region"
  #   default     = "us-east-1"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  #   default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

# variable "availability_zones" {
#   description = "List of availability zones"
#   type        = list(string)
# }
