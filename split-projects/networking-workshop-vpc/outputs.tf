output "aws_security_group_sg_0b575c05f44b7716e_id" {
  value = aws_security_group.sg_0b575c05f44b7716e.id
}

output "aws_security_group_workshop_lambda_sg_id" {
  value = aws_security_group.workshop_lambda_sg.id
}

output "aws_subnet_workshop_public_subnet_1_id" {
  value = aws_subnet.workshop_public_subnet_1.id
}

output "aws_subnet_workshop_public_subnet_2_id" {
  value = aws_subnet.workshop_public_subnet_2.id
}

output "aws_vpc_workshop_vpc_id" {
  value = aws_vpc.workshop_vpc.id
}
