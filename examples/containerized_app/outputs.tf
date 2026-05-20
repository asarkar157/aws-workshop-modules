output "app_url" {
  value = module.app_runner.service_url
}

output "dynamodb_table" {
  value = module.dynamodb_table.table_name
}

output "ecr_repository_url" {
  value = module.ecr_repository.repository_url
}
