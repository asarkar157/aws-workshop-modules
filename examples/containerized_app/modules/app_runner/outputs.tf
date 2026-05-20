output "service_arn" {
  description = "The ARN of the App Runner service"
  value       = aws_apprunner_service.this.arn
}

output "service_url" {
  description = "The URL of the App Runner service"
  value       = aws_apprunner_service.this.service_url
}

output "instance_role_arn" {
  description = "The ARN of the instance role attached to the App Runner service"
  value       = aws_iam_role.instance_role.arn
}

output "instance_role_name" {
  description = "The name of the instance role attached to the App Runner service"
  value       = aws_iam_role.instance_role.name
}
