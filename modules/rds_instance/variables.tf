variable "identifier" {
  type        = string
  description = "The identifier for the RDS instance"
}

variable "engine" {
  type        = string
  description = "The database engine to use"
  default     = "postgres"
}

variable "engine_version" {
  type        = string
  description = "The engine version to use"
  default     = "15.4"
}

variable "instance_class" {
  type        = string
  description = "The instance type of the RDS instance"
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  type        = number
  description = "The allocated storage in gigabytes"
  default     = 20
}

variable "db_name" {
  type        = string
  description = "The name of the database to create when the DB instance is created"
  default     = "workshopdb"
}

variable "username" {
  type        = string
  description = "Username for the master DB user"
  default     = "dbadmin"
}

variable "password" {
  type        = string
  description = "Password for the master DB user"
  sensitive   = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the DB will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the DB subnet group"
}

variable "multi_az" {
  type        = bool
  description = "Whether to deploy a Multi-AZ standby for automatic failover (high availability). Applies to the primary instance and all read replicas."
  default     = false
}

variable "backup_retention_period" {
  type        = number
  description = "Number of days to retain automated backups. Must be greater than 0 to enable read replicas and point-in-time recovery."
  default     = 7
}

variable "read_replica_count" {
  type        = number
  description = "Number of read replicas to create for read-scaling and additional high-availability endpoints. Set to 0 to disable."
  default     = 0
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
