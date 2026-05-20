variable "name" {
  type        = string
  description = "Name of the EC2 instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the instance will be deployed"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the instance will be deployed"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "ami_id" {
  type        = string
  description = "AMI ID to use for the instance. If empty, uses latest Amazon Linux 2023."
  default     = ""
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key pair to use"
  default     = ""
}

variable "create_public_ip" {
  type        = bool
  description = "Whether to create an Elastic IP for the instance"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
