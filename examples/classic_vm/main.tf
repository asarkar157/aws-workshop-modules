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


module "components" {
  source = "./modules"

  vpc_id = var.vpc_id
  public_subnet_id = var.public_subnet_id
  private_subnet_ids = var.private_subnet_ids
}
