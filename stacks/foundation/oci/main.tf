locals {
  freeform_tags = {
    project    = "insaeng"
    stack      = "foundation-oci"
    managed-by = "terraform"
  }
}

resource "oci_identity_compartment" "insaeng" {
  compartment_id = var.tenancy_ocid
  name           = "insaeng"
  description    = "Workloads for the insaeng project."
  enable_delete  = false
  freeform_tags  = local.freeform_tags
}

resource "oci_identity_compartment" "insaeng_state" {
  compartment_id = var.tenancy_ocid
  name           = "insaeng-state"
  description    = "Terraform state buckets for the insaeng project."
  enable_delete  = false
  freeform_tags  = local.freeform_tags
}
