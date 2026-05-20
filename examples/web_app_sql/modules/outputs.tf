output "app_url" {
  value = module.app_runner.service_url
}

output "db_endpoint" {
  value = module.rds_instance.db_instance_endpoint
}
