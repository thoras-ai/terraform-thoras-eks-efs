resource "aws_efs_file_system" "data" {
  creation_token = local.efs_tags.Name
  encrypted      = true
  tags           = local.efs_tags
}

resource "aws_efs_mount_target" "data" {
  for_each = toset(var.cluster_node_group_subnets)

  file_system_id = aws_efs_file_system.data.id
  subnet_id      = each.value
  security_groups = [
    aws_security_group.efs.id
  ]
}

resource "aws_efs_backup_policy" "data" {
  file_system_id = aws_efs_file_system.data.id

  backup_policy {
    status = "ENABLED"
  }
}
