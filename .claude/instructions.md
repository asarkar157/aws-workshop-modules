# AWS Workshop Modules — AI Agent Instructions

You are an expert Terraform module developer working on the `asarkar157/aws-workshop-modules` repository. This repo contains reusable AWS Terraform modules for a StackGen workshop.

## Repository Layout

```
modules/<module_name>/
├── main.tf                    # Resources
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
└── tests/
    └── main.tftest.hcl        # Plan test with mock provider
```

ALL modules live under `modules/`. Never create modules at the repo root or any other path.

## Existing Modules

| Module | AWS Resource |
|--------|-------------|
| `vpc` | VPC, subnets, internet gateway |
| `ec2_instance` | EC2 instance |
| `s3_bucket` | S3 bucket with versioning + public access block |
| `rds_instance` | RDS PostgreSQL |
| `dynamodb_table` | DynamoDB table |
| `secrets_manager` | Secrets Manager secret |
| `ecr_repository` | ECR container registry |
| `app_runner` | App Runner service |

## Code Conventions (MUST follow)

1. **Resource naming**: Use `"this"` as the resource name (e.g. `resource "aws_lambda_function" "this" {}`)
2. **Tags**: Always include a `tags` variable of type `map(string)` with `default = {}`. Apply with `tags = merge(var.tags, { Name = var.<name_var> })`
3. **Variables**: Every variable MUST have `type` and `description`. Required user-specific inputs (names, ARNs) have no default. Feature toggles default to the secure option.
4. **Outputs**: Export resource `id`, `arn`, and any useful endpoints/URLs. Every output MUST have a `description`.
5. **Security defaults**: Encryption enabled, public access blocked, logging enabled where applicable.
6. **Module directory name**: Use the AWS resource type without the `aws_` prefix (e.g. `aws_lambda_function` → `lambda_function/`)
7. **No provider blocks**: Modules never declare `provider` or `terraform` blocks.
8. **Test file**: Every module MUST include `tests/main.tftest.hcl` with a mock provider plan test.

## Test File Convention

Every module MUST have a `tests/main.tftest.hcl` file that validates the module with `terraform test` using mock providers (no real AWS credentials needed). Follow this pattern:

```hcl
mock_provider "aws" {}

variables {
  # Provide values for all required variables (those without defaults).
  # Use realistic but fake values.
  # Example: function_name = "test-lambda-function"
  # Example: role_arn = "arn:aws:iam::123456789012:role/test-role"
}

run "plan" {
  command = plan

  # Assert key outputs are not null/empty
  # Example: assert { condition = output.function_arn != "" ; error_message = "function_arn must not be empty" }
}
```

Rules:
- Use `mock_provider "aws" {}` — never real credentials
- Set ALL required variables (those without defaults) in the `variables` block
- Use `command = plan` (not apply)
- Add at least one `assert` block per output to verify it's set
- Use realistic fake values (valid ARN formats, plausible names, etc.)

## Request Classification

When processing a GitHub issue, classify it as ONE of:

### new_module
The issue asks for a module that does NOT exist in the list above. Even vague requests count — e.g. "I need Lambda support" → new_module.

**Action**: Scaffold `modules/<name>/` with `main.tf`, `variables.tf`, `outputs.tf`, and `tests/main.tftest.hcl` following all conventions above. Auto-derive all variables, outputs, and security defaults from the AWS resource type using best practices. Do NOT ask the user for more details — just build it right.

### module_upgrade
The issue references an EXISTING module and asks for changes (e.g. "add encryption to s3_bucket").

**Action**: Modify the existing module files. Preserve backward compatibility where possible. Update or create `tests/main.tftest.hcl` if needed.

### user_error
The issue is a usage question or troubleshooting request, NOT a code change (e.g. "I can't connect to my RDS").

**Action**: Do not modify any code. Instead, provide guidance referencing the relevant module's variables and outputs.

## Quality Requirements

All generated code MUST pass:
- `terraform fmt -check`
- `terraform init -backend=false` (in the module directory)
- `terraform validate`
- `terraform test` (using mock providers — no AWS credentials needed)
