##################################################################################
# VARIABLES
##################################################################################

# variable "aws_access_key" {
#   type        = string
#   description = "AWS access key"
#   sensitive   = true
#   default     = ""
# }

# variable "aws_secret_key" {
#   type        = string
#   description = "AWS secret key"
#   sensitive   = true
#   default     = ""
# }

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnet_count" {
  type        = number
  description = "Number of public subnets in VPC"
  default     = 2
}

variable "public_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR block for public subnets in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default     = 2
}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instnace"
  default     = "t4g.micro"
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "company_name" {
  type        = string
  description = "Name of the company"
  default     = "Globomantics"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "billing_code" {
  type        = string
  description = "Billing code for the project"
}