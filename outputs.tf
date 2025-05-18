###############################################################
# outputs.tf - Output values from EKS cluster Terraform configuration
###############################################################

output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.cluster_sg.id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = aws_iam_role.cluster_role.name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN associated with EKS cluster"
  value       = aws_iam_role.cluster_role.arn
}

output "node_group_name" {
  description = "Name of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.node_group_name
}

output "node_security_group_id" {
  description = "Security group ID attached to the EKS nodes"
  value       = aws_security_group.node_sg.id
}

output "node_iam_role_name" {
  description = "IAM role name associated with EKS node group"
  value       = aws_iam_role.node_role.name
}

output "node_iam_role_arn" {
  description = "IAM role ARN associated with EKS node group"
  value       = aws_iam_role.node_role.arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.eks_vpc.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "kubeconfig_command" {
  description = "Command to update the kubeconfig file to connect to the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.eks_cluster.name}"
}

output "eks_version" {
  description = "The Kubernetes server version of the cluster"
  value       = aws_eks_cluster.eks_cluster.version
}


# output "aws_lb_controller_role_arn" {
#   description = "ARN of the IAM role used by the AWS Load Balancer Controller"
#   value       = module.lb_controller_iam_role.iam_role_arn
# }

# output "aws_lb_controller_policy_arn" {
#   description = "ARN of the IAM policy attached to the AWS Load Balancer Controller role"
#   value       = aws_iam_policy.lb_controller.arn
# }

# output "helm_release_status" {
#   description = "Status of the Helm release for the AWS Load Balancer Controller"
#   value       = helm_release.lb_controller.status
# }

# output "helm_release_version" {
#   description = "Deployed version of the AWS Load Balancer Controller"
#   value       = helm_release.lb_controller.version
# }