variable "region" {
  type        = string
  description = "AWS region hosting target EKS and EFS resources"
  nullable    = false
}

variable "cluster_name" {
  type        = string
  description = "name of EKS cluster accessing EFS volume"
  nullable    = false
}

variable "vpc_id" {
  type        = string
  description = "VPC ID hosting target EKS and EFS resources"
  nullable    = false
}

variable "identity_oidc_issuer" {
  type        = string
  description = "OIDC issuer URL for the EKS cluster"
  nullable    = false
}

variable "cluster_node_group_subnets" {
  type        = list(string)
  description = "EKS node group subnets that will access EFS"
  nullable    = false
}

variable "efs_addon_version" {
  type        = string
  description = "version of EFS addon for EKS"
  default     = "v1.7.7-eksbuild.1"
}

variable "install_efs_eks_addon" {
  type        = bool
  description = "Whether to install the EKS addon for EFS"
  default     = true
}

variable "efs_tags" {
  type        = map(string)
  description = "resource tags for EFS volume"
  default     = {}
}

variable "efs_throughput_mode" {
  type        = string
  description = "throughput mode for EFS volumee"
  default     = "bursting"
}

variable "security_group_tags" {
  type        = map(string)
  description = "resource tags for EFS security group"
  default     = {}
}
