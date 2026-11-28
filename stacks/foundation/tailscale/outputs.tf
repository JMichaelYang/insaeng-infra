output "plan_identity_id" {
  value = tailscale_federated_identity.plan.id
}

output "plan_audience" {
  value = tailscale_federated_identity.plan.audience
}

output "apply_identity_id" {
  value = tailscale_federated_identity.apply.id
}

output "apply_audience" {
  value = tailscale_federated_identity.apply.audience
}
