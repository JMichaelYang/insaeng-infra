# insaeng-infra

Terraform for the insaeng homelab on Oracle Cloud's free tier, joined to a Tailscale tailnet. The `stacks/foundation/{oci,tailscale,github}` stacks are applied from a laptop and set up the compartments, state buckets, identities and repository settings that CI depends on; the `stacks/{network,tailnet,nodes}` stacks are planned on pull requests and applied from GitHub Actions. Shared code lives in `modules/`, each stack keeps its state in OCI Object Storage under `<stack path>/terraform.tfstate`, and the Terraform version is pinned in `.terraform-version`.
