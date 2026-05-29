variable "function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "handler" {
  type        = string
  description = "Function entrypoint in your code (e.g. index.handler). Not used when package_type is Image"
  default     = null
}

variable "runtime" {
  type        = string
  description = "Identifier of the function's runtime (e.g. python3.12, nodejs20.x). Not used when package_type is Image"
  default     = null
}

variable "package_type" {
  type        = string
  description = "Lambda deployment package type (Zip or Image)"
  default     = "Zip"
}

variable "filename" {
  type        = string
  description = "Path to the function's deployment package (ZIP) within the local filesystem"
  default     = null
}

variable "source_code_hash" {
  type        = string
  description = "Base64-encoded SHA256 hash of the deployment package, used to trigger updates when the package changes"
  default     = null
}

variable "s3_bucket" {
  type        = string
  description = "S3 bucket containing the deployment package. Conflicts with filename"
  default     = null
}

variable "s3_key" {
  type        = string
  description = "S3 key of the deployment package"
  default     = null
}

variable "s3_object_version" {
  type        = string
  description = "Object version of the S3 deployment package"
  default     = null
}

variable "image_uri" {
  type        = string
  description = "ECR image URI containing the function's deployment package. Used when package_type is Image"
  default     = null
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB the function has access to"
  default     = 128
}

variable "timeout" {
  type        = number
  description = "Amount of time in seconds the function has to run before timing out"
  default     = 3
}

variable "architectures" {
  type        = list(string)
  description = "Instruction set architecture for the function (x86_64 or arm64)"
  default     = ["arm64"]
}

variable "environment_variables" {
  type        = map(string)
  description = "Map of environment variables available to the function at runtime"
  default     = {}
}

variable "reserved_concurrent_executions" {
  type        = number
  description = "Amount of reserved concurrent executions for the function. -1 removes any concurrency limit"
  default     = -1
}

variable "tracing_mode" {
  type        = string
  description = "X-Ray tracing mode for the function (Active or PassThrough)"
  default     = "Active"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key used to encrypt environment variables at rest. Uses an AWS managed key when null"
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to attach the function to a VPC. Leave empty to run outside a VPC"
  default     = []
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to associate with the function when running in a VPC"
  default     = []
}

variable "additional_policy_arns" {
  type        = list(string)
  description = "List of additional IAM policy ARNs to attach to the function's execution role"
  default     = []
}

variable "log_retention_in_days" {
  type        = number
  description = "Number of days to retain the function's CloudWatch logs"
  default     = 14
}

variable "log_kms_key_arn" {
  type        = string
  description = "ARN of the KMS key used to encrypt the CloudWatch log group. Uses an AWS managed key when null"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
