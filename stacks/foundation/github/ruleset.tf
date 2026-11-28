locals {
  required_checks = [
    "fmt",
    "workflow-lint",
    "validate",
    "backend-keys",
    "tflint",
    "checkov",
  ]
}

resource "github_repository_ruleset" "main" {
  name        = "main"
  repository  = local.repository
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      required_approving_review_count = 0
    }

    required_status_checks {
      strict_required_status_checks_policy = false

      dynamic "required_check" {
        for_each = local.required_checks

        content {
          context = required_check.value
        }
      }
    }
  }
}
