output "aws_iam_role_hello_kitty_serve_id" {
  value = aws_iam_role.hello_kitty_serve.id
}

output "aws_lambda_function_hello_kitty_serve_id" {
  value = aws_lambda_function.hello_kitty_serve.id
}

output "aws_s3_bucket_hello_kitty_images_renewing_alpaca_id" {
  value = aws_s3_bucket.hello_kitty_images_renewing_alpaca.id
}
