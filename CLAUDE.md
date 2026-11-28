# CLAUDE.md

Never leave comments in code or config files in this repo. This covers Terraform, shell scripts, YAML and cloud-init templates, GitHub workflows and actions, HCL backend configs, `.tflint.hcl` and env files.

Put explanations in PR descriptions, issues or READMEs instead.

Keep only these lines, which tools need to work:

- `#!` shebangs
- the `#cloud-config` first line of cloud-init templates
- the `# vX.Y.Z` tag after a SHA-pinned `uses:`, which Dependabot relies on
- tool directives such as `# tflint-ignore:`, `# shellcheck disable=` and zizmor ignore comments
