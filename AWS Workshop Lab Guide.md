# AWS Workshop Lab Guide

## Step 1: Set Up AWS CLI Login

This workshop uses a pre-provisioned AWS environment. You will authenticate using an IAM User with access scoped specifically for this workshop.

Install the AWS CLI if not already installed:
- AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

Run the following commands to authenticate (your instructor will provide your unique access keys):

```bash
export AWS_ACCESS_KEY_ID="<YOUR_ACCESS_KEY>"
export AWS_SECRET_ACCESS_KEY="<YOUR_SECRET_KEY>"
export AWS_DEFAULT_REGION="us-east-1"
```

Verify your access by listing your caller identity:
```bash
aws sts get-caller-identity
```
You should see your user listed as `stackgen-workshop-user`.

## Step 2: Install Terraform/OpenTofu and StackGen CLI

Install Terraform or OpenTofu (either works):
- **Terraform**: https://developer.hashicorp.com/terraform/downloads
- **OpenTofu**: https://opentofu.org/docs/intro/install/

Install the GitHub CLI and authenticate:
- **GitHub CLI**: https://cli.github.com/

```bash
gh auth login
```
This is required because the Terraform modules are sourced from a private GitHub repository. Without GitHub auth, `terraform init` will fail when fetching modules.

Install the StackGen CLI by following the guide for your platform:
https://docs.stackgen.com/docs/cli-guide/get-started/install-and-uninstall

Verify both tools are installed:
```bash
terraform --version
stackgen --version
gh --version
```

## Step 3: Log Into StackGen Sandbox

Navigate to the StackGen sandbox tenant:
https://sandbox.cloud.stackgen.com

Log in with the credentials provided by your workshop instructor.

## Step 4: Create Your Project

1. Click on your username at the bottom left of the screen, then open the **Settings** menu.
2. Click on the **Projects** tab and create a new project. Name it with your name or GitHub handle (e.g., `jdoe-project`).

This project is your isolated workspace — all AppStacks, modules, and governance policies will live here.

## Step 5: Generate a Personal Access Token (PAT)

1. While in Settings, click on **Personal Access Tokens** and generate a new token.
2. Save this token securely — you will not be able to see it again.

Now configure the StackGen CLI to point to the workshop instance and authenticate with your PAT:
https://docs.stackgen.com/docs/cli-guide/configuration/cloud

When prompted for the StackGen URL, use: `https://sandbox.cloud.stackgen.com`

Verify your CLI is configured correctly:
```bash
stackgen appstack list
```

## Step 6: Add PAT Token to the AWS Modules Git Repo

We will now configure the module repository to automatically publish Terraform modules to your StackGen sandbox instance.

Fork or access the workshop module repository:
https://github.com/asarkar157/aws-workshop-modules

In the repository, go to **Settings → Secrets and Variables → Actions**.

1. Click on the **Variables** tab and create a new repository variable:
   - **Name**: `STACKGEN_URL_1`
   - **Value**: `https://sandbox.cloud.stackgen.com`

2. Click on the **Secrets** tab and create a new repository secret:
   - **Name**: `STACKGEN_TOKEN_1`
   - **Value**: Your PAT token from Step 5

## Step 7: Run the Backfill Action to Populate All Modules

The module repository contains pre-built AWS Terraform modules. We need to push all of them to your StackGen instance.

1. In the GitHub repository, go to **Actions → Module Backfill Publisher** and click "Run workflow".
2. Select "Instance 1" (or "All") and click the green "Run workflow" button.

This will publish all existing module releases to your StackGen sandbox. Wait for the workflow to complete.

Once complete, you should see the following modules appear as custom resources in StackGen:
- `vpc` — Virtual Private Cloud (with subnets and routing)
- `ec2_instance` — EC2 Virtual Machine
- `rds_instance` — PostgreSQL Database
- `s3_bucket` — Object Storage
- `dynamodb_table` — NoSQL Database
- `secrets_manager` — Secrets Management
- `ecr_repository` — Container Registry
- `app_runner` — Fully managed container application service

## Step 8: Create a Governance Policy

Before building our AppStack, let's set up governance guardrails to ensure our infrastructure meets security best practices.

Navigate to **Governance** in the left sidebar and create a new governance configuration. Name it `{your-name}-s3-security` (e.g., `jdoe-s3-security`). Choose AWS services.

Proceed through the steps until you reach Step 4: Select Security Policies. You will see an empty table. Click the **+ Add New Policy** button in the top-right corner to create a custom policy.

The policy creator accepts natural language input. Create a policy that enforces the following for the S3 bucket module:

**Policy 1: "Enforce that versioning is always enabled for AWS S3 buckets"**
Our `s3_bucket` module has `versioning_enabled` defaulting to true, but we want to ensure no developer ever turns it off.

> ⚠️ **Important: Verify the resource_type field!**
> After the AI generates the policy, pay close attention to line 6 of the generated policy — this is the "resource_type" field. It must match the actual Terraform resource used in your module. For our `s3_bucket` module, the correct resource type is `s3_bucket`. If the AI generated `aws_s3_bucket`, manually correct it to `s3_bucket`.

### Step 5: Enforce TF & Provider Version
Paste the following provider block to define your AWS provider configuration:

```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

### Step 6: General Details
Fill in the Configuration Name and Description fields. In the "Enforce on projects" dropdown, **search for and select ONLY your project** that you created at the start of the lab.

Click **Save** to create your governance configuration. When you return to your AppStack and add an S3 bucket module, governance will flag any violations!

## Step 9: Create Your AppStack — Containerized App Golden Path

Now let's build the infrastructure for a containerized application using the InfraComposer canvas.

1. Create a new AppStack from scratch and choose **AWS**. 
2. Rename it in the top-left to something descriptive like `{your-name}-golden-path`. 
3. Leave the "Mark as Template" button unchecked for now.

From the Add New Resource pane, drag and drop the following modules onto the canvas:
- **Container Registry (ECR)** — Your private Docker image registry
- **App Runner** — The compute layer that runs your containerized app
- **DynamoDB** — NoSQL database for your application data
- **Secrets Manager** — Secure storage for API keys

Name each resource using the format: `{your-github-handle}-{resource}`
For example:
- Container Registry: `jdoe-ecr`
- App Runner: `jdoe-app`
- DynamoDB: `jdoe-table`
- Secrets Manager: `jdoe-secret`

Hit the green **Save** button.

## Step 10: Deploy Your Infrastructure

First, find your Project ID:
```bash
stackgen project list --project {your-project-name}
```

Then list the appstacks in your project to find your AppStack ID:
```bash
stackgen appstack list --project {your-project-id}
```

Now run a plan (preview only — no resources are created):
```bash
stackgen provision --appstack-id {your-appstack-id} --project {your-project-id} --environment prod
```

You should see a successful plan. 

### Convert your AppStack into a Template
Now that your plan succeeds, convert your AppStack into a reusable template. Go back to the AppStack name in the top-left, click it, and check the **"Mark as Template"** button. Click **Save**.

### Create Template Input Variables
To make your template useful, convert hardcoded names into variables.
Click "Add New" → **Terraform Config → Variables**.

Create variables like `app_name`, `table_name`, etc.
Link them to your modules by clicking the `(x)` button next to the input fields in each module and typing `var.app_name`.

### Apply Infrastructure
Once you've reviewed the plan and confirmed it looks correct, deploy the resources by adding the `--apply` flag:

```bash
stackgen provision --appstack-id {your-appstack-id} --project {your-project-id} --environment prod --apply
```

This will take ~3-5 minutes (App Runner provisioning takes a few minutes).

## Step 11: Set Up Agentic Infrastructure Generation

Navigate to the StackGen AI console:
https://workshop.cloud.stackgen.com/ai/

### Create a Workspace
Click the Organization Settings gear icon, click "Manage Workspaces", and click "+ Create Workspace". Name it `{your-name}-workspace` and attach it to your StackGen project. Switch to this workspace in the top-left dropdown.

### Connect StackGen Integration
Click the **Integrations** tab. Find StackGen and configure it:
- **URL**: `https://workshop.cloud.stackgen.com`
- **Token**: Your PAT token

### Create an AI Skill
Click the **Skills** tab and create a new skill:
- **Skill Name**: Containerized Infra Generation
- **Description**: "Use this when devs request infra for new containerized apps"

In the skill stage, paste the following prompt (replace placeholders!):

```text
When dev requests infra for a new containerized app, create an appstack with a randomly generated name (for AWS provider). Do this in the stackgen workspace called {your stackgen project name here}. Once the appstack is created, populate the appstack with the appstack template called {your appstack template name here}. Check the required input TFvars and fill them in with reasonable values for the developer team. Once done, give a summary to dev what was created and emit a URL link to them to view their new appstack.
```

Save the skill. Developers can now request infrastructure in plain English, and the AI will automatically generate a fully populated AWS AppStack from your golden path!

## Available AWS Modules Reference

| Module | Resources Created | Required Inputs |
|--------|-------------------|-----------------|
| `vpc` | VPC, Subnets, IGW, Route Tables | `name` |
| `ecr_repository` | ECR Container Registry | `repository_name` |
| `app_runner` | AWS App Runner Service | `service_name`, `image_identifier` |
| `dynamodb_table` | DynamoDB Table | `table_name` |
| `s3_bucket` | S3 Object Storage | `bucket_name` |
| `secrets_manager` | Secrets Manager Secret | `name`, `secret_string` |
| `rds_instance` | RDS PostgreSQL Database | `identifier`, `password`, `vpc_id`, `subnet_ids` |
| `ec2_instance` | EC2 VM, Security Group | `name`, `vpc_id`, `subnet_id` |
