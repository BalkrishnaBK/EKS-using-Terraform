##################################################################################
# OUTPUT
##################################################################################


output "endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_role" {
  value = module.eks.cluster_iam_role_name
}

output "cluster_id" {
  value = module.eks.cluster_id
}