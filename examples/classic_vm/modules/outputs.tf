output "vm_public_ip" {
  value = module.ec2_instance.public_ip
}

output "db_endpoint" {
  value = module.rds_instance.db_instance_endpoint
}

output "s3_bucket_name" {
  value = module.s3_bucket.bucket_id
}

output "secret_arn" {
  value = module.secrets_manager.secret_arn
}
