output "insaeng_compartment_id" {
  description = "OCID of the insaeng workloads compartment."
  value       = oci_identity_compartment.insaeng.id
}

output "insaeng_state_compartment_id" {
  description = "OCID of the insaeng-state compartment that holds Terraform state buckets."
  value       = oci_identity_compartment.insaeng_state.id
}
