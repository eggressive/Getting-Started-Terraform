variable "aws_access_key" {
  type        = string
  description = "value of the AWS access key"
  sensitive   = true
}

variable "aws_secret_key" {
  type        = string
  description = "value of the AWS secret key"
  sensitive   = true
}

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

variable "public_subnet_cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
  default     = "10.0.0.0/24"
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