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
