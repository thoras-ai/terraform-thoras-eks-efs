data "aws_eks_cluster" "target" {
  name = var.cluster_name
}

data "aws_subnet" "nodes_for_efs_access" {
  for_each = toset(var.cluster_node_group_subnets)
  id       = each.value
}

resource "aws_eks_addon" "efs" {
  count = var.install_efs_eks_addon ? 1 : 0

  cluster_name                = var.cluster_name
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = var.efs_addon_version
  resolve_conflicts_on_update = "PRESERVE"

  service_account_role_arn = aws_iam_role.cluster_efs_driver.arn
}
