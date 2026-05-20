output "db_endpoint" {
  value = module.components.db_endpoint
}

output "raw_bucket" {
  value = module.components.raw_bucket
}

output "processed_bucket" {
  value = module.components.processed_bucket
}

output "dynamodb_table" {
  value = module.components.dynamodb_table
}
