variable "name" {
  type        = string
  description = "Name of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = map(string)
  description = "Map of public subnet names to CIDR blocks (e.g. {'subnet-a' = '10.0.1.0/24'})"
  default = {
    "public-1a" = "10.0.1.0/24"
    "public-1b" = "10.0.2.0/24"
  }
}

variable "private_subnets" {
  type        = map(string)
  description = "Map of private subnet names to CIDR blocks"
  default = {
    "private-1a" = "10.0.11.0/24"
    "private-1b" = "10.0.12.0/24"
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
