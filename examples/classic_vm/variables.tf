variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources into"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the pre-existing VPC"
}

variable "public_subnet_id" {
  type        = string
  description = "The ID of a public subnet in the VPC"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of private subnet IDs in the VPC"
}
