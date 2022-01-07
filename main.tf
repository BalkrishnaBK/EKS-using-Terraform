##################################################################################
# TERRAFORM CONFIG
##################################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

  }
}

##################################################################################
# PROVIDERS
##################################################################################

provider "kubernetes" {
  host                   = data.aws_eks_cluster.bk.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.bk.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.bk_auth.token
}

provider "aws" {
  region = var.aws_region
}


##################################################################################
# VARIABLES
##################################################################################


locals {
  cluster_name = "bk"
  cluster_version = "1.20"
}


variable "cidr_block" {
  type        = string
  description = "CIDR"
  default     = "10.0.0.0/16"
}


variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}


##################################################################################
# RESOURCES
##################################################################################

resource "aws_vpc" "bk_vpc" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_subnet" "bk_sub" {
  vpc_id     = aws_vpc.bk_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "bk_sub1" {
  vpc_id     = aws_vpc.bk_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
}

# resource "aws_vpc_endpoint" "bk_vps_endpoint" {
#   vpc_id       = aws_vpc.bk_vpc.id
#   service_name = "com.amazonaws.${var.aws_region}.eks"
# }

# resource "aws_vpc_endpoint_subnet_association" "bk_ec2" {
#   vpc_endpoint_id = aws_vpc_endpoint.bk_vps_endpoint.id
#   subnet_id       = aws_subnet.bk_sub.id
# }

# resource "aws_vpc_endpoint_subnet_association" "bk_ec21" {
#   vpc_endpoint_id = aws_vpc_endpoint.bk_vps_endpoint.id
#   subnet_id       = aws_subnet.bk_sub1.id
# }


resource "aws_eks_cluster" "bk_cluster" {
  name     = "bk_cluster"
  role_arn = aws_iam_role.bk_iam.arn

  vpc_config {
    subnet_ids = [aws_subnet.bk_sub.id, aws_subnet.bk_sub1.id]
  }


  depends_on = [
    aws_iam_role_policy_attachment.bk_iam-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.bk_iam-AmazonEKSVPCResourceController,
  ]
}

resource "aws_iam_role" "bk_iam" {
  name = "bk_iam"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "bk_iam-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.bk_iam.name
}


resource "aws_iam_role_policy_attachment" "bk_iam-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.bk_iam.name
}

##################################################################################
# DATA
##################################################################################

data "aws_eks_cluster" "bk" {
  name = aws_eks_cluster.bk_cluster.name
}

data "aws_eks_cluster_auth" "bk_auth" {
  name = "bk_auth"
}

data "aws_availability_zones" "available" {}

##################################################################################
# OUTPUT
##################################################################################


output "endpoint" {
  value = data.aws_eks_cluster.bk.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = data.aws_eks_cluster.bk.certificate_authority[0].data
}

# Only available on Kubernetes version 1.13 and 1.14 clusters created or upgraded on or after September 3, 2019.
output "identity-oidc-issuer" {
  value = data.aws_eks_cluster.bk.identity[0].oidc[0].issuer
}


