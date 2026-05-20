# Hello World AWS App

This is a simple Node.js Express application designed to be containerized and deployed to AWS App Runner.
It demonstrates basic container deployment and reading environment variables injected by Terraform.

## Prerequisites

- Docker installed locally
- AWS CLI configured

## Build and Push to ECR

1. Authenticate Docker to your Amazon ECR registry:
   ```bash
   aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
   ```

2. Build the Docker image:
   ```bash
   docker build -t hello-world-aws-workshop .
   ```

3. Tag the image for your ECR repository:
   ```bash
   docker tag hello-world-aws-workshop:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/containerized-repo-XXXXXX:latest
   ```

4. Push the image:
   ```bash
   docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/containerized-repo-XXXXXX:latest
   ```

## Deploying

After pushing the image, you can update your `containerized_app` Terraform example to use this specific ECR image URI instead of the public NGINX image.
