
##################################################################################
# VARIABLES
##################################################################################


variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "name_prefix" {
  type        = string
  description = "Default Name for all resources"
  default     = "bk"
}

variable "vpc_subnet_count" {
  type        = string
  description = "Number of subnets to create in VPC"
  default     = "2"
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}