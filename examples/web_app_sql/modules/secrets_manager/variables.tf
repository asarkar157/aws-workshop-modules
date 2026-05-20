variable "name" {
  type        = string
  description = "Name of the secret"
}

variable "description" {
  type        = string
  description = "Description of the secret"
  default     = ""
}

variable "secret_string" {
  type        = string
  description = "The secret string value"
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
