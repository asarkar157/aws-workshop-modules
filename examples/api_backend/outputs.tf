output "api_url" {
  value = module.app_runner.service_url
}

output "dynamodb_table" {
  value = module.dynamodb_table.table_name
}

output "s3_bucket" {
  value = module.s3_bucket.bucket_id
}
