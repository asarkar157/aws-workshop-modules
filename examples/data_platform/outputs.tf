output "db_endpoint" {
  value = module.rds_instance.db_instance_endpoint
}

output "raw_bucket" {
  value = module.s3_bucket_raw.bucket_id
}

output "processed_bucket" {
  value = module.s3_bucket_processed.bucket_id
}

output "dynamodb_table" {
  value = module.dynamodb_table.table_name
}
