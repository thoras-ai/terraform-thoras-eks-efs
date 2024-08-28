resource "aws_security_group" "efs" {
  name        = "thoras-efs-${var.cluster_name}"
  description = "allow EKS nodes to ingress to EFS volume"

  # vpc_config is technically a list but in practice
  # contains only one element
  vpc_id = data.aws_eks_cluster.target.vpc_config.0.vpc_id
  tags   = local.security_group_tags
}

resource "aws_vpc_security_group_ingress_rule" "efs_access_from_cluster" {
  for_each = toset([
    for subnet in data.aws_subnet.nodes_for_efs_access : subnet.cidr_block
  ])

  security_group_id = aws_security_group.efs.id

  cidr_ipv4   = each.value
  ip_protocol = "tcp"
  from_port   = 2049
  to_port     = 2049
}
