<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create a Service Role

### Usage

```hcl
module "service_role" {
  source = "github.com/elastic-infra/terraform-modules//aws/iam-service-role?ref=v1.0.0"

  name             = "role-name"
  trusted_services = ["ec2.amazonaws.com"]
  role_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]

  create_instance_profile = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | IAM role name | `string` | n/a | yes |
| create\_instance\_profile | Whether to create an instance profile | `bool` | `false` | no |
| role\_description | IAM Role description | `string` | `""` | no |
| role\_inline\_policies | List of name and IAM policy document to attach to IAM role | <pre>list(object({<br>    name   = string<br>    policy = string<br>  }))</pre> | `[]` | no |
| role\_path | Path of IAM role | `string` | `"/"` | no |
| role\_policy\_arns | List of ARNs of IAM policies to attach to IAM role | `list(string)` | `[]` | no |
| trusted\_services | AWS Services that can assume these roles | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_profile\_arn | ARN of IAM instance profile |
| instance\_profile\_name | Name of IAM instance profile |
| role\_arn | ARN of IAM role |
| role\_name | Name of IAM role |
| role\_unique\_id | The stable and unique string identifying the role |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
