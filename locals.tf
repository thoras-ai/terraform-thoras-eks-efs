locals {
  efs_tags = merge(
    { Name = "thoras-data-${var.cluster_name}" },
    var.efs_tags
  )

  security_group_tags = merge(
    { Name = "thoras-efs-${var.cluster_name}" },
    var.security_group_tags
  )

  cluster_oidc_url_stripped = trimprefix(
    data.aws_eks_cluster.target.identity.0.oidc.0.issuer,
    "https://"
  )

  # We can extract the account ID out of any of the subnets
  account_id = data.aws_subnet.nodes_for_efs_access[
    var.cluster_node_group_subnets[0]
  ].owner_id
}
