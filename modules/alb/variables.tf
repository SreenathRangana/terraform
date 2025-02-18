variable "security_groups" {
  description = "List of security groups to associate with the ALB"
  type        = list(string)
}


variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}




# variable "public_subnets" {
#   type = list(string)
#   default = [
#     "subnet-036c98448b981f9a9",  # Replace with actual subnet IDs
#     "subnet-00fae3200496cce1f"   # Replace with actual subnet IDs
#   ]
# }
variable "vpc_id" {
  description = "VPC ID to associate with the ALB"
  type        = string
}
