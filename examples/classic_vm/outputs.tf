output "vm_public_ip" {
  value = module.components.vm_public_ip
}

output "db_endpoint" {
  value = module.components.db_endpoint
}

output "s3_bucket_name" {
  value = module.components.s3_bucket_name
}

output "secret_arn" {
  value = module.components.secret_arn
}
