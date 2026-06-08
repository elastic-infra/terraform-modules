<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Create OIDC provider for GitHub Actions

**DEPRECATED**

This module is deprecated and is no longer maintained.
A plain `aws_iam_openid_connect_provider` resource is now sufficient: AWS verifies
the GitHub IdP's TLS certificate against its trusted root CA store, so the hardcoded
thumbprint list this module provides is no longer required. Define the resource
directly instead:

```hcl
resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}
```

### Usage

```hcl
module "github_actions" {
  source = "github.com/elastic-infra/terraform-modules//aws/github-oidc-provider?ref=master"
}

data "aws_iam_policy_document" "assume_for_github_actions" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.github_actions.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:owner/repository:*",
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-role"
  assume_role_policy = data.aws_iam_policy_document.assume_for_github_actions.json
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN assigned by AWS for GitHub provider |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
