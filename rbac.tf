###############################################################
# RBAC Configuration
###############################################################

# Create the aws-auth ConfigMap to provide access to the cluster
resource "kubernetes_config_map_v1_data" "aws_auth_data" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<YAML
- rolearn: ${aws_iam_role.node_role.arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
${var.additional_roles_map}
YAML

    mapUsers = <<YAML
<<<<<<< HEAD
- userarn: arn:aws:iam::000011110000:user/admin
=======
- userarn: arn:aws:iam::111100000000:user/admin
>>>>>>> 953c2b485108f52817f475e48bd6d533c0000fbe
  username: admin
  groups:
    - system:masters  # Gives admin access
YAML
  }

  force = true


  depends_on = [
    aws_eks_node_group.eks_node_group
  ]
}
