resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

module "s3_bucket" {
  source = "../../../modules/s3_bucket"

  bucket_name = "api-backend-assets-${random_string.suffix.result}"
}

module "dynamodb_table" {
  source = "../../../modules/dynamodb_table"

  table_name = "api-backend-table-${random_string.suffix.result}"
  hash_key   = "id"
}

module "secrets_manager" {
  source = "../../../modules/secrets_manager"

  name          = "api-backend-secret-${random_string.suffix.result}"
  description   = "API Keys for external services"
  secret_string = "dummy-api-key-${random_string.suffix.result}"
}

module "app_runner" {
  source = "../../../modules/app_runner"

  service_name          = "api-backend-app-${random_string.suffix.result}"
  image_identifier      = "public.ecr.aws/nginx/nginx:latest"
  image_repository_type = "ECR_PUBLIC"

  environment_variables = {
    DYNAMODB_TABLE = module.dynamodb_table.table_name
    SECRET_ID      = module.secrets_manager.secret_id
    S3_BUCKET      = module.s3_bucket.bucket_id
  }
}
