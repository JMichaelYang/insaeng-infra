resource "github_repository_environment" "production" {
  repository          = local.repository
  environment         = "production"
  prevent_self_review = false

  reviewers {
    users = [5275392]
  }

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "production_main" {
  repository     = local.repository
  environment    = github_repository_environment.production.environment
  branch_pattern = "main"
}
