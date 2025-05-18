###############################################################
# main.tf - Entry point for EKS cluster Terraform configuration
###############################################################

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  cloud {
    organization = "adco"
    workspaces {
      name = "terraformAWSEKS"
    }
  }
}


provider "aws" {
  region = var.region
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}

locals {
  cluster_name = var.environment != null ? "${var.project_name}-${var.environment}" : var.project_name
  account_id   = data.aws_caller_identity.current.account_id
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

