output "fs_id" {
  value = aws_efs_file_system.data.id
}

output "volume_name" {
  value = aws_efs_file_system.data.name
}
