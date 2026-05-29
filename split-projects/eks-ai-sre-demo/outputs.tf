output "aws_eks_cluster_ai_sre_demo_id" {
  value = aws_eks_cluster.ai_sre_demo.id
}

output "aws_iam_role_ai_sre_demo_ebs_csi_driver_id" {
  value = aws_iam_role.ai_sre_demo_ebs_csi_driver.id
}

output "aws_iam_role_ai_sre_demo_eks_cluster_id" {
  value = aws_iam_role.ai_sre_demo_eks_cluster.id
}

output "aws_iam_role_ai_sre_demo_eks_nodes_id" {
  value = aws_iam_role.ai_sre_demo_eks_nodes.id
}

output "aws_iam_role_ai_sre_demo_github_actions_deploy_id" {
  value = aws_iam_role.ai_sre_demo_github_actions_deploy.id
}

output "aws_s3_bucket_ai_sre_demo_tfstate_id" {
  value = aws_s3_bucket.ai_sre_demo_tfstate.id
}
