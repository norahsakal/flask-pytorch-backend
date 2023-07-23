variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "kubernetes_version" {
  default     = 1.25
  description = "kubernetes version"
}

variable "k8s_service_account_namespace" {
  type    = string
  default = "default"
}

variable "k8s_service_account_name" {
  type    = string
  default = "eks-cluster-sa"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.101.0/24"]
}