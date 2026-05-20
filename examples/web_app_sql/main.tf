terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket_name = "webapp-sql-bucket-${random_string.suffix.result}"
}

module "secrets_manager" {
  source = "./modules/secrets_manager"

  name        = "webapp-sql-db-secret-${random_string.suffix.result}"
  description = "Database credentials"
  secret_string = jsonencode({
    username = "dbadmin"
    password = random_password.db_password.result
  })
}

module "rds_instance" {
  source = "./modules/rds_instance"

  identifier = "webapp-sql-db-${random_string.suffix.result}"
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  password   = random_password.db_password.result
}

module "app_runner" {
  source = "./modules/app_runner"

  service_name          = "webapp-sql-app-${random_string.suffix.result}"
  image_identifier      = "public.ecr.aws/nginx/nginx:latest"
  image_repository_type = "ECR_PUBLIC"

  environment_variables = {
    DB_HOST   = module.rds_instance.db_instance_address
    S3_BUCKET = module.s3_bucket.bucket_id
  }
}
