output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "qualified_arn" {
  description = "The ARN of the Lambda function including the version (qualified ARN)"
  value       = aws_lambda_function.this.qualified_arn
}

output "invoke_arn" {
  description = "The ARN to be used for invoking the function from API Gateway or other services"
  value       = aws_lambda_function.this.invoke_arn
}

output "version" {
  description = "Latest published version of the Lambda function"
  value       = aws_lambda_function.this.version
}

output "role_arn" {
  description = "The ARN of the IAM execution role attached to the function"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "The name of the IAM execution role attached to the function"
  value       = aws_iam_role.this.name
}

output "log_group_name" {
  description = "The name of the CloudWatch log group for the function"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "The ARN of the CloudWatch log group for the function"
  value       = aws_cloudwatch_log_group.this.arn
}
