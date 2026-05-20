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

  bucket_name = "classic-vm-bucket-${random_string.suffix.result}"
}

module "secrets_manager" {
  source = "./modules/secrets_manager"

  name        = "classic-vm-db-secret-${random_string.suffix.result}"
  description = "Database password for Classic VM"
  secret_string = jsonencode({
    username = "dbadmin"
    password = random_password.db_password.result
  })
}

module "rds_instance" {
  source = "./modules/rds_instance"

  identifier = "classic-vm-db-${random_string.suffix.result}"
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids
  password   = random_password.db_password.result
}

module "ec2_instance" {
  source = "./modules/ec2_instance"

  name             = "classic-vm-${random_string.suffix.result}"
  vpc_id           = var.vpc_id
  subnet_id        = var.public_subnet_id
  create_public_ip = true
}
