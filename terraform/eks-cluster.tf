resource "aws_eks_cluster" "eks-cluster" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.eks-iam-role.arn
  version = var.kubernetes_version
  vpc_config {
    vpc_id = module.vpc.vpc_id
    subnet_ids = var.private_subnets
  }
  depends_on = [
    aws_iam_role.eks-iam-role,
  ]
}

resource "kubernetes_service_account" "eks_cluster_sa" {
  metadata {
    name      = var.k8s_service_account_name
    namespace = var.k8s_service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks-iam-role.arn
    }
  }
  depends_on = [aws_eks_cluster.eks-cluster]
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-workernodes"
  node_role_arn   = aws_iam_role.workernodes.arn
  subnet_ids      = var.private_subnets
  instance_types  = ["t3.xlarge"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
