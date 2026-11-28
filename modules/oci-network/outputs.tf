output "vcn_id" {
  description = "OCID of the VCN."
  value       = oci_core_vcn.this.id
}

output "subnet_id" {
  description = "OCID of the public regional subnet."
  value       = oci_core_subnet.this.id
}
