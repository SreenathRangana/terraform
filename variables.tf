variable "region" {
  description = "AWS Region"
  type        = string
}

# VPC Variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "enable_ecr_vpc_endpoint" {
  description = "Flag to enable ECR VPC endpoint"
  type        = bool
  default     = false
}
variable "azs" {
  type        = list(string)
  description = "List of Availability Zones"
}

variable "security_groups" {
  description = "List of security group IDs to associate with the VPC"
  type        = list(string)
  default     = []  # Set a default value if necessary
}

# ECR Variables
variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

# ECS Variables
variable "cluster_name" {
  description = "Name of ECS cluster"
  type        = string
}
