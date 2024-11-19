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

#domain and subdomain name

variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone."
  type        = string
}
variable "subdomain_name" {
  description = "The subdomain name for the Route 53 hosted zone."
  type        = string
}

variable "subdomain" {
  description = "The subdomain name for the Route 53 record."
  type        = string
}


# ssh_key_name
variable "ssh_key_name" {
  type        = string
  description = "SSH key Name for launch templates"
  # default = "ec2"
}

# auto scaling group
variable "asg_min_size" {
  description = "Auto scaling group min size"
  type        = number
}

variable "asg_max_size" {
  description = "Auto scaling group max size"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Auto scaling group desired capacity"
  type        = number
}

variable "asg_cool_down" {
  description = "Auto scaling group cool down"
  type        = number
}

variable "scale_up_eval" {
  description = "evaluation period for scale up "
  type        = number
}

variable "scale_up_period" {
  description = "scale up period"
  type        = number
}

variable "scale_up_threshold" {
  description = "threshold for scale up policy"
  type        = number
}

variable "scale_down_eval" {
  description = "evaluation period for scale down "
  type        = number
}

variable "scale_down_period" {
  description = "scale down period"
  type        = number
}

variable "scale_down_threshold" {
  description = "threshold for scale down policy"
  type        = number
}

variable "lb_type" {
  description = "Type of ALB"
  type        = string
}


variable "lb_target_type" {
  description = "load balancer target type"
  type        = string
}

variable "tg_protocol" {
  description = "target group protocol"
  type        = string
}

variable "lambda_filename" {
  description = "lambda artifacts path"
  type        = string
}

variable "sendgrid_api_key" {
  description = "send grid messaging api key"
  type        = string
}

variable "base_url" {
  description = "Application base url"
  type        = string
}

variable "from_email" {
  description = "from email to send email through sendgrid"
  type        = string
}

variable "jwt_secret" {
  description = "JWT token secret key"
  type        = string
}