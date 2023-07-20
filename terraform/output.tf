output "cluster_id" {
  description = "EKS cluster ID."
  value       = aws_eks_cluster.eks-cluster.id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = aws_eks_cluster.eks-cluster.endpoint
}