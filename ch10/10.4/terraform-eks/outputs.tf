output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS region"
  value       = data.aws_region.current.name
}

output "vpc_id" {
  description = "VPC ID (10.5에서 AWS Load Balancer Controller 설치에 쓴다)"
  value       = module.vpc.vpc_id
}
