# AWS EKS Terraform Project

This repository contains Terraform code to deploy a production-ready Amazon EKS (Elastic Kubernetes Service) cluster with all necessary supporting infrastructure.

## Architecture Overview

This project provisions:

- Amazon EKS cluster with managed node groups
- Custom VPC with public and private subnets across multiple availability zones
- IAM roles and policies for cluster operation
- Security groups with appropriate access rules
- AWS Load Balancer Controller for managing ALB/NLB ingress
- EBS CSI driver for persistent volume support

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0.0+
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for Kubernetes access

## Quick Start

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/terraform-eks-cluster.git
   cd terraform-eks-cluster
   ```

2. **Configure AWS credentials**

   ```bash
   aws configure
   ```

3. **Initialize Terraform**

   ```bash
   terraform init
   ```

4. **Customize variables (Optional)**

   Edit `terraform.tfvars` to customize deployment parameters or set variables via command line.

5. **Deploy the EKS cluster**

   ```bash
   terraform apply
   ```

6. **Configure kubectl to access your cluster**

   ```bash
   aws eks update-kubeconfig --region $(terraform output -raw region) --name $(terraform output -raw cluster_name)
   ```

7. **Verify the deployment**

   ```bash
   kubectl get nodes
   ```

## Configuration Variables

| Variable Name | Description | Default Value |
|---------------|-------------|---------------|
| region | AWS region to deploy the EKS cluster | eu-west-1 |
| project_name | Name of the project | demo |
| environment | Environment name (e.g., dev, staging, prod) | dev |
| vpc_cidr | CIDR block for the VPC | 10.0.0.0/16 |
| public_subnet_cidrs | CIDR blocks for public subnets | ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] |
| private_subnet_cidrs | CIDR blocks for private subnets | ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"] |
| kubernetes_version | Kubernetes version for the EKS cluster | 1.28 |
| node_ami_type | AMI type for the EKS worker nodes | AL2_x86_64 |
| node_capacity_type | Capacity type for the EKS worker nodes | ON_DEMAND |
| node_instance_types | Instance types for the EKS worker nodes | ["t3.medium"] |
| node_disk_size | Disk size for the EKS worker nodes in GB | 50 |
| node_desired_size | Desired number of worker nodes | 2 |
| node_max_size | Maximum number of worker nodes | 4 |
| node_min_size | Minimum number of worker nodes | 1 |
| cluster_endpoint_public_access_cidrs | CIDRs that can access the EKS API server endpoint | ["0.0.0.0/0"] |
| kms_key_arn | ARN of the KMS key for EKS secrets encryption | "" |
| chart_version | AWS Load Balancer Controller Helm chart version | "1.6.2" |

## Project Structure

```
terraform-eks-cluster/
├── main.tf                  # Main configuration and providers
├── variables.tf             # Input variables declaration
├── outputs.tf               # Output values
├── cluster.tf               # EKS cluster configuration
├── iam.tf                   # IAM roles and policies
├── networking.tf            # VPC and network resources
├── security.tf              # Security groups
├── loadbalancer.tf          # AWS Load Balancer Controller
├── rbac.tf                  # Kubernetes RBAC configuration
├── lb-controller-policy.json # LB Controller IAM policy
├── .gitignore               # Git ignore file
└── README.md                # This file
```

## Key Components

### 1. EKS Cluster

The EKS cluster is configured with:
- Kubernetes version 1.28
- Private and public endpoint access
- CloudWatch logging for all cluster components
- Optional KMS encryption for Kubernetes secrets

### 2. Networking

The network design follows AWS best practices:
- VPC across multiple availability zones
- Public subnets for resources that need internet access
- Private subnets for worker nodes with NAT Gateway for outbound traffic
- Appropriate subnet tagging for Kubernetes integration

### 3. Node Groups

The project uses EKS managed node groups with:
- Amazon Linux 2 (AL2_x86_64) AMI
- Auto-scaling configuration
- IAM roles with necessary permissions

### 4. Add-ons

The project installs essential EKS add-ons:
- AWS Load Balancer Controller for Ingress resources
- EBS CSI Driver for persistent volumes with default storage class

## IAM Permissions

The cluster uses two main IAM roles:
1. **Cluster Role**: Permissions for the EKS control plane
2. **Node Role**: Permissions for the worker nodes

Additionally, IAM roles for service accounts (IRSA) are configured for:
- AWS Load Balancer Controller
- EBS CSI Driver

## Accessing the Cluster

After deployment, use the following command to configure kubectl:

```bash
$(terraform output -raw kubeconfig_command)
```

## Custom RBAC

The default RBAC configuration includes:
- System masters access for the admin IAM user
- Node access permissions
- You can customize additional access by modifying the `additional_roles_map` and `additional_users_map` variables

## Security Considerations

This deployment includes:
- Private worker nodes in private subnets
- Security groups limiting access to necessary communication only
- EKS API server endpoint with configurable CIDR restrictions
- Optional KMS encryption for secrets

## Troubleshooting

### Common Issues

1. **Terraform fails to create EKS cluster**
   - Check your IAM permissions
   - Verify VPC limits in the AWS account

2. **Load Balancer Controller fails to deploy**
   - Check the OIDC provider configuration
   - Verify the service account and role are correctly linked

3. **Nodes not joining the cluster**
   - Check security group rules
   - Verify IAM role permissions for the nodes

### Debugging

For detailed debugging:

```bash
# Check EKS cluster status
aws eks describe-cluster --name $(terraform output -raw cluster_name) --region $(terraform output -raw region)

# View cluster logs
kubectl logs -n kube-system deployment/aws-load-balancer-controller

# Check node status
kubectl describe nodes
```

## Maintenance

### Upgrading the Cluster

To upgrade the Kubernetes version:

1. Update the `kubernetes_version` variable
2. Run `terraform apply`

### Scaling the Cluster

To scale the node group:

1. Modify the `node_desired_size`, `node_min_size`, or `node_max_size` variables
2. Run `terraform apply`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
