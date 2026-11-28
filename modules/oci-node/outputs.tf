output "hostname" {
  description = "Hostname the node uses on the VNIC and the tailnet."
  value       = var.name
}

output "id" {
  description = "OCID of the instance."
  value       = oci_core_instance.this.id
}
