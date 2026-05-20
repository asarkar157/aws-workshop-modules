resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

module "dynamodb_table" {
  source = "../../../modules/dynamodb_table"

  table_name = "containerized-table-${random_string.suffix.result}"
  hash_key   = "id"
}

module "ecr_repository" {
  source = "../../../modules/ecr_repository"

  repository_name = "containerized-repo-${random_string.suffix.result}"
}

module "secrets_manager" {
  source = "../../../modules/secrets_manager"

  name          = "containerized-api-key-${random_string.suffix.result}"
  description   = "Sample API key"
  secret_string = "dummy-api-key-${random_string.suffix.result}"
}

module "app_runner" {
  source = "../../../modules/app_runner"

  service_name          = "containerized-app-${random_string.suffix.result}"
  image_identifier      = "public.ecr.aws/nginx/nginx:latest"
  image_repository_type = "ECR_PUBLIC"

  environment_variables = {
    DYNAMODB_TABLE = module.dynamodb_table.table_name
    SECRET_ID      = module.secrets_manager.secret_id
  }
}
