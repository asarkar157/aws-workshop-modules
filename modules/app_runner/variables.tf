variable "service_name" {
  type        = string
  description = "Name of the App Runner service"
}

variable "image_identifier" {
  type        = string
  description = "The image identifier (e.g. ECR URI or public image like public.ecr.aws/nginx/nginx:latest)"
}

variable "image_repository_type" {
  type        = string
  description = "The image repository type (ECR or ECR_PUBLIC)"
  default     = "ECR_PUBLIC"
}

variable "port" {
  type        = string
  description = "Port the application listens on"
  default     = "80"
}

variable "environment_variables" {
  type        = map(string)
  description = "Environment variables for the App Runner service"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
