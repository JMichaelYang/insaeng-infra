output "insaeng_compartment_id" {
  description = "OCID of the insaeng workloads compartment."
  value       = oci_identity_compartment.insaeng.id
}

output "insaeng_state_compartment_id" {
  description = "OCID of the insaeng-state compartment that holds Terraform state buckets."
  value       = oci_identity_compartment.insaeng_state.id
}

output "ci_client_id" {
  description = "Client ID of the insaeng-github-exchange confidential app that CI uses for the token exchange."
  value       = oci_identity_domains_app.github_exchange.name
}

output "ci_client_secret" {
  description = "Client secret of the insaeng-github-exchange confidential app."
  value       = oci_identity_domains_app.github_exchange.client_secret
  sensitive   = true
}

output "ci_domain_url" {
  description = "URL of the Default identity domain that hosts the token exchange."
  value       = local.default_domain_url
}
