variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources into"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the pre-existing VPC"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of private subnet IDs in the VPC"
}
