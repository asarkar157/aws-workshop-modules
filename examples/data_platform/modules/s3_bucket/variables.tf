variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "versioning_enabled" {
  type        = bool
  description = "Whether to enable versioning for the bucket"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
