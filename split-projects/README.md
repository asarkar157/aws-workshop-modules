# Split Terraform Projects

This directory contains the output of the **tfstate-splitter** and **tfstate-to-iac** skills applied to the monolithic `terraform.tfstate` in the repository root.

## Accounting

| Metric | Count |
|--------|-------|
| **Original resources** | 412 |
| **Excluded (AWS-managed)** | 63 |
| **Accountable resources** | 349 |
| **Projects generated** | 16 |
| **Validated (`terraform validate`)** | 12 ✅ |
| **Needs manual review** | 4 ⚠️ |

## Projects

| Project | Resources | Split Reason | Validate |
|---------|-----------|-------------|----------|
| `iam-shared` | 151 | Service category | ✅ |
| `ses-email` | 63 | Service category | ⚠️ nested blocks |
| `eks-prathvi` | 18 | Naming convention | ✅ |
| `app-retroboard` | 17 | Application tag | ✅ |
| `eks-ai-sre-demo` | 15 | Naming convention | ⚠️ ASG launch_template blocks |
| `networking-ai-sre-demo` | 14 | VPC isolation | ✅ |
| `networking-vpc-06cab6363775ce4b0` | 12 | VPC isolation | ✅ |
| `storage` | 10 | Service category | ✅ |
| `compute` | 9 | Service category | ⚠️ instance nested blocks |
| `dns` | 8 | Service category | ✅ |
| `networking-aws-aidevops-default-vpc` | 7 | VPC isolation | ✅ |
| `networking-workshop-vpc` | 7 | VPC isolation | ✅ |
| `eks-guild-mcp` | 7 | Naming convention | ⚠️ OIDC url format |
| `app-hello-kitty` | 6 | Application tag | ✅ |
| `observability` | 3 | Service category | ⚠️ CloudFront nested blocks |
| `misc` | 2 | Uncategorized | ✅ |

## Splitting Strategy

Resources were assigned to projects using a priority-based approach:

1. **VPC isolation** — all networking resources (VPC, subnets, IGW, NAT, route tables, security groups) grouped by VPC
2. **Application tags** — resources tagged with `Application` or `Service` tags
3. **Naming conventions** — resources sharing a common name prefix (3+ resources)
4. **Service categories** — remaining resources by AWS service type
5. **Uncategorized** — anything left over

### Exclusions

63 AWS-managed resources were excluded from all projects:
- 49 service-linked IAM roles (`/aws-service-role/*`)
- 14 default DB parameter groups

See [excluded_resources.md](excluded_resources.md) for the full list.

## Files Per Project

Each project directory contains:

```
{project}/
├── main.tf           # Resource definitions
├── providers.tf      # AWS provider configuration
├── versions.tf       # Terraform + provider version constraints
├── variables.tf      # Input variables (region)
├── outputs.tf        # Output values
└── terraform.tfstate # Sub-state with only this project's resources
```

## Known Issues (⚠️ Projects)

The 4 projects marked ⚠️ have `terraform validate` errors caused by **deeply nested Terraform blocks** (e.g., CloudFront `default_cache_behavior`, ASG `mixed_instances_policy`) being rendered as HCL attributes instead of blocks. These require manual fixup:

| Project | Issue | Fix |
|---------|-------|-----|
| `ses-email` | `aws_ses_domain_mail_from` missing `mail_from_domain` | Add the attribute from state |
| `eks-ai-sre-demo` | ASG `mixed_instances_policy` nested blocks | Restructure as HCL blocks |
| `compute` | Instance `cpu_options` and launch template blocks | Restructure as HCL blocks |
| `eks-guild-mcp` | OIDC provider URL format | Already fixed in generator |
| `observability` | CloudFront deeply nested blocks | Restructure as HCL blocks |

## Full Resource Mapping

See [MANIFEST.md](MANIFEST.md) for the complete resource-to-project mapping.
