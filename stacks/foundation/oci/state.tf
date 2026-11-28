data "oci_objectstorage_namespace" "this" {
  compartment_id = var.tenancy_ocid
}

resource "oci_objectstorage_bucket" "tfstate" {
  compartment_id = oci_identity_compartment.insaeng_state.id
  namespace      = data.oci_objectstorage_namespace.this.namespace
  name           = "insaeng-tfstate"
  access_type    = "NoPublicAccess"
  versioning     = "Enabled"
  storage_tier   = "Standard"
  freeform_tags  = local.freeform_tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "oci_objectstorage_bucket" "tfstate_foundation" {
  compartment_id = oci_identity_compartment.insaeng_state.id
  namespace      = data.oci_objectstorage_namespace.this.namespace
  name           = "insaeng-tfstate-foundation"
  access_type    = "NoPublicAccess"
  versioning     = "Enabled"
  storage_tier   = "Standard"
  freeform_tags  = local.freeform_tags

  lifecycle {
    prevent_destroy = true
  }
}

output "objectstorage_namespace" {
  description = "Object Storage namespace that holds the Terraform state buckets."
  value       = data.oci_objectstorage_namespace.this.namespace
}

output "tfstate_bucket_name" {
  description = "Name of the state bucket for the CI stacks."
  value       = oci_objectstorage_bucket.tfstate.name
}

output "tfstate_foundation_bucket_name" {
  description = "Name of the state bucket for the foundation stacks."
  value       = oci_objectstorage_bucket.tfstate_foundation.name
}
