# terraform-thoras-eks-efs

## When to use this module

Use this Terraform module as a pre-step to installing Thoras when:

1) You're installing Thoras in an EKS cluster
1) ...and you're using [EFS for EKS](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html) as Thoras' storage backend (recommended)
1) ...and the EFS EKS AddOn is not set up in your cluster
1) ...and you'd like to automate the EFS EKS AddOn setup along with everything it needs (cluster OIDC IAM provider, security group, IAM role)

## Usage

```hcl
module "thoras_efs" {
  source                     = "thoras/thoras"
  version                    = "3.1.1"
  cluster_name               = "my-cluster"
  region                     = "us-east-1"
  cluster_node_group_subnets = [
    "subnet-aaaa",
    "subnet-bbbb",
    "subnet-cccc"
  ]
}
```

## Resources created / managed by module

| Resource | Description |
|----------|-------------|
| **Thoras EFS filesystem** | the AWS EFS fs that will store Thoras historical data |
| **An EFS backup policy** | Provides a way to restore data if needed |
| **[EFS AddOn for EKS](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)** | The required EKS add-on for enabling EFS mount points in an EKS cluster |
| **IAM OIDC Provider for EKS cluster** | Allows EKS service accounts to use IAM roles |
| **Cluster EFS driver IAM role** | Allows EFS driver for EKS to access EFS filesystem |
| **Security Group for Thoras EFS Filesystem** | Security Group with an inbound rule that allows port 2049 tcp from node group subnets |


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `region` | AWS region hosting target EKS and EFS resources | `string` | `null` | yes |
| `cluster_name` | name of EKS cluster accessing EFS volume        | `string` | `null` | yes |
| `cluster_node_group_subnets` | EKS node group subnets that will access EFS | `list(string)` | `null` | yes |
| `efs_addon_version` | version of EFS addon for EKS | `string` | `v1.7.7-eksbuild.1` | yes |
| `efs_tags` | resource tags for Thoras EFS volume | `map(string)` | `{}` | no |
| `security_group_tags` | resource tags for Thoras EFS security group | `map(string)` | `{}` | no |

## Outputs

| Name | Description | Type |
|------|-------------|------|
| `fs_id` | ID of Thoras EFS volume | `string` |
| `volume_name` | name of Thoras EFS volume | `string` |
