
##################################################################################
# MODULES
##################################################################################


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.10.0"

  name = "${var.name_prefix}-vpc"
  # default_vpc_name = "${var.name_prefix}-vpc"
  # public_subnet_suffix = "${var.name_prefix}-ps-"
  cidr = var.vpc_cidr_block

  azs             = slice(data.aws_availability_zones.available.names, 0, (var.vpc_subnet_count))
  # private_subnets = [for subnet in range(var.vpc_subnet_count) : cidrsubnet(var.vpc_cidr_block, 16, subnet)]
  public_subnets  = [for subnet in range(var.vpc_subnet_count) : cidrsubnet(var.vpc_cidr_block, 8, subnet)]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  # depends_on = [module.iam_assumable_role]

  tags = {
    Name = "${var.name_prefix}"
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.0.5"
  # insert the 11 required variables here
  cluster_name                    = "${var.name_prefix}-eks"
  cluster_version                 = "1.21"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  iam_role_name = "${var.name_prefix}-iam"
  tags = {
    Name = "${var.name_prefix}"
  }
}

