output "aws_iam_role_retroboard_api_id" {
  value = aws_iam_role.retroboard_api.id
}

output "aws_iam_role_retroboard_send_email_id" {
  value = aws_iam_role.retroboard_send_email.id
}

output "aws_iam_role_retroboard_slack_alerts_id" {
  value = aws_iam_role.retroboard_slack_alerts.id
}

output "aws_lambda_function_retroboard_send_email_id" {
  value = aws_lambda_function.retroboard_send_email.id
}

output "aws_lambda_function_retroboard_slack_alerts_id" {
  value = aws_lambda_function.retroboard_slack_alerts.id
}

output "aws_s3_bucket_retroboard_demo_appcd_io_id" {
  value = aws_s3_bucket.retroboard_demo_appcd_io.id
}
