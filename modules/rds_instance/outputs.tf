output "db_instance_id" {
  description = "The RDS instance ID of the primary instance"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "The ARN of the primary RDS instance"
  value       = aws_db_instance.this.arn
}

output "db_instance_endpoint" {
  description = "The connection endpoint in address:port format."
  value       = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.this.port
}

output "db_instance_name" {
  description = "The database name"
  value       = aws_db_instance.this.db_name
}

output "read_replica_ids" {
  description = "The RDS instance IDs of the read replicas"
  value       = aws_db_instance.replica[*].id
}

output "read_replica_endpoints" {
  description = "The connection endpoints of the read replicas in address:port format"
  value       = aws_db_instance.replica[*].endpoint
}
