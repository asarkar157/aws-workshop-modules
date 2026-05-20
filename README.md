# AWS Workshop Terraform Modules

Custom Terraform modules for the StackGen workshop. These modules provision developer-facing AWS resources into a pre-existing VPC.

## Prerequisites

- AWS CLI installed and configured
- Terraform >= 1.0
- Docker (for building the hello-world app)

## Authentication

```bash
# Set your AWS credentials
export AWS_ACCESS_KEY_ID="<YOUR_ACCESS_KEY>"
export AWS_SECRET_ACCESS_KEY="<YOUR_SECRET_KEY>"
export AWS_DEFAULT_REGION="us-east-1"
```
Or run `aws configure`.

You can generate workshop credentials using the included script:
```bash
cd scripts
chmod +x setup_credentials.sh
./setup_credentials.sh
```

## Available Modules

| Module | Description | Key Outputs |
|--------|-------------|-------------|
| [vpc](modules/vpc/) | Virtual Private Cloud | `vpc_id`, `public_subnet_ids` |
| [ec2_instance](modules/ec2_instance/) | EC2 Virtual Machine | `public_ip`, `instance_id` |
| [s3_bucket](modules/s3_bucket/) | S3 Object storage | `bucket_arn`, `bucket_id` |
| [rds_instance](modules/rds_instance/) | RDS PostgreSQL Database | `db_instance_endpoint` |
| [dynamodb_table](modules/dynamodb_table/) | DynamoDB NoSQL Table | `table_name`, `table_arn` |
| [secrets_manager](modules/secrets_manager/) | Secrets Manager Secret | `secret_arn` |
| [ecr_repository](modules/ecr_repository/) | ECR Container Registry | `repository_url` |
| [app_runner](modules/app_runner/) | App Runner Service | `service_url` |

## Golden Path Examples

| Example | Use Case | Modules Used |
|---------|----------|--------------|
| [classic_vm](examples/classic_vm/) | Server with DB and storage | VPC, EC2, RDS, S3, Secrets |
| [web_app_sql](examples/web_app_sql/) | Web app with relational DB | VPC, App Runner, RDS, Secrets, S3 |
| [containerized_app](examples/containerized_app/) | Container-based service | VPC, App Runner, ECR, Secrets, DynamoDB |
| [api_backend](examples/api_backend/) | Backend with NoSQL | VPC, App Runner, DynamoDB, Secrets, S3 |
| [data_platform](examples/data_platform/) | Databases + storage | VPC, RDS, DynamoDB, S3, Secrets |

## Hello World App

A deployable Express/Node.js application is provided in `src/hello_world`. See [src/hello_world/README.md](src/hello_world/README.md) for instructions on how to build, push to ECR, and deploy using App Runner.

## Quick Start

Instead of using raw Terraform commands, you will use the StackGen CLI tools to import and provision your infrastructure. This ensures all your resources are tracked in the StackGen platform.

1. **Import the Terraform example into a StackGen AppStack:**
```bash
terraform-importer import appstack \
  --project <YOUR_PROJECT_ID> \
  --input-tf-source-dir examples/classic_vm \
  --appstack-cloud-provider aws \
  --appstack-name "classic-vm-quickstart"
```
*(Note the resulting AppStack ID from the output)*

2. **Provision (Plan & Apply) the AppStack:**
```bash
stackgen provision \
  --appstack-id <YOUR_APPSTACK_ID> \
  --project <YOUR_PROJECT_ID> \
  --environment prod \
  --apply
```
