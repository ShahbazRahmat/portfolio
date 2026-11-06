output "cluster_name" {
  description = "Name of the EKS cluster."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "API server endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for additional IRSA roles."
  value       = aws_iam_openid_connect_provider.this.arn
}
