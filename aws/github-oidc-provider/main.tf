/**
* ## Information
*
* Create OIDC provider for GitHub Actions
*
* ### Usage
*
* ```hcl
* module "github_actions" {
*   source = "github.com/elastic-infra/terraform-modules//aws/github-oidc-provider?ref=master"
* }
*
* data "aws_iam_policy_document" "assume_for_github_actions" {
*   statement {
*     effect  = "Allow"
*     actions = ["sts:AssumeRoleWithWebIdentity"]
*     principals {
*       type        = "Federated"
*       identifiers = [module.github_actions.arn]
*     }
*     condition {
*       test     = "StringLike"
*       variable = "token.actions.githubusercontent.com:sub"
*       values = [
*         "repo:owner/repository:*",
*       ]
*     }
*   }
* }
*
* resource "aws_iam_role" "github_actions" {
*   name               = "github-actions-role"
*   assume_role_policy = data.aws_iam_policy_document.assume_for_github_actions.json
* }
* ```
*
*/

resource "aws_iam_openid_connect_provider" "github_actions" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
  ]
}
