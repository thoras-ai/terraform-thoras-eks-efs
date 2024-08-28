# AWS Managed IAM Policy for EFS Driver
data "aws_iam_policy" "efs_driver" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

resource "aws_iam_role" "cluster_efs_driver" {
  name = "thoras-efs-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${local.account_id}:oidc-provider/${local.cluster_oidc_url_stripped}"
        }
        Condition = {
          StringLike = {
            "${local.cluster_oidc_url_stripped}:aud" : "sts.amazonaws.com"
            "${local.cluster_oidc_url_stripped}:sub" : "system:serviceaccount:kube-system:efs-csi-*"
          }
        }
      },
    ]
  })

  managed_policy_arns = [data.aws_iam_policy.efs_driver.arn]
}

data "external" "thumbprint" {
  program = [
    format("%s/bin/get_thumbprint.sh", path.module),
    var.region
  ]
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = data.aws_eks_cluster.target.identity.0.oidc.0.issuer
}
