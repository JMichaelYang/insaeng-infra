locals {
  github_issuer  = "https://token.actions.githubusercontent.com"
  github_subject = "repo:JMichaelYang@5275392/insaeng-infra@1475167325"
}

resource "tailscale_federated_identity" "plan" {
  description = "insaeng infra CI plan"
  issuer      = local.github_issuer
  subject     = "${local.github_subject}:*"
  scopes = [
    "policy_file:read",
    "dns:read",
    "auth_keys:read",
    "devices:core:read",
  ]
}

resource "tailscale_federated_identity" "apply" {
  description = "insaeng infra CI apply"
  issuer      = local.github_issuer
  subject     = "${local.github_subject}:environment:production"
  scopes = [
    "policy_file",
    "dns",
    "auth_keys",
    "devices:core",
  ]
  tags = ["tag:server"]
}
