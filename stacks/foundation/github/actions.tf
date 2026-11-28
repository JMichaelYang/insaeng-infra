resource "github_actions_repository_permissions" "this" {
  repository           = local.repository
  enabled              = true
  allowed_actions      = "all"
  sha_pinning_required = true
}

resource "github_workflow_repository_permissions" "this" {
  repository                       = local.repository
  default_workflow_permissions     = "read"
  can_approve_pull_request_reviews = false
}
