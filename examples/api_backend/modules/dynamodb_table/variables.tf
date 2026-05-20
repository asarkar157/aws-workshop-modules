variable "table_name" {
  type        = string
  description = "Name of the DynamoDB table"
}

variable "hash_key" {
  type        = string
  description = "The attribute to use as the hash (partition) key"
  default     = "id"
}

variable "hash_key_type" {
  type        = string
  description = "The type of the hash key (S for string, N for number, B for binary)"
  default     = "S"
}

variable "billing_mode" {
  type        = string
  description = "Controls how you are charged for read and write throughput and how you manage capacity"
  default     = "PAY_PER_REQUEST"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
