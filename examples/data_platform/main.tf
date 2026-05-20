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

module "s3_bucket_raw" {
  source = "../../modules/s3_bucket"

  bucket_name = "data-platform-raw-${random_string.suffix.result}"
}

module "s3_bucket_processed" {
  source = "../../modules/s3_bucket"

  bucket_name = "data-platform-processed-${random_string.suffix.result}"
}

module "dynamodb_table" {
  source = "../../modules/dynamodb_table"

  table_name = "data-platform-metadata-${random_string.suffix.result}"
  hash_key   = "id"
}

resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "secrets_manager" {
  source = "../../modules/secrets_manager"

  name          = "data-platform-db-secret-${random_string.suffix.result}"
  description   = "Database password for Data Platform"
  secret_string = jsonencode({
    username = "dbadmin"
    password = random_password.db_password.result
  })
}

module "rds_instance" {
  source = "../../modules/rds_instance"

  identifier        = "data-platform-db-${random_string.suffix.result}"
  vpc_id            = var.vpc_id
  subnet_ids        = var.private_subnet_ids
  password          = random_password.db_password.result
  allocated_storage = 50
  instance_class    = "db.t3.small"
}
