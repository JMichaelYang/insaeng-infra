output "user_data" {
  description = "Rendered #cloud-config. Contains the Tailscale auth key."
  value       = local.user_data
  sensitive   = true
}

output "user_data_base64" {
  description = "user_data, base64-encoded."
  value       = base64encode(local.user_data)
  sensitive   = true
}
