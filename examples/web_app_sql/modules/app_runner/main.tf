data "aws_iam_policy_document" "apprunner_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["build.apprunner.amazonaws.com", "tasks.apprunner.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "access_role" {
  count              = var.image_repository_type == "ECR" ? 1 : 0
  name               = "${var.service_name}-apprunner-access-role"
  assume_role_policy = data.aws_iam_policy_document.apprunner_assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  count      = var.image_repository_type == "ECR" ? 1 : 0
  role       = aws_iam_role.access_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role" "instance_role" {
  name               = "${var.service_name}-apprunner-instance-role"
  assume_role_policy = data.aws_iam_policy_document.apprunner_assume_role.json
  tags               = var.tags
}

resource "aws_apprunner_service" "this" {
  service_name = var.service_name

  source_configuration {
    image_repository {
      image_configuration {
        port                          = var.port
        runtime_environment_variables = var.environment_variables
      }
      image_identifier      = var.image_identifier
      image_repository_type = var.image_repository_type
    }

    dynamic "authentication_configuration" {
      for_each = var.image_repository_type == "ECR" ? [1] : []
      content {
        access_role_arn = aws_iam_role.access_role[0].arn
      }
    }
    auto_deployments_enabled = false
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.instance_role.arn
  }

  tags = merge(var.tags, { Name = var.service_name })
}
