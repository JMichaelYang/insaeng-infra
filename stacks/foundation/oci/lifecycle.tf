resource "oci_identity_policy" "objectstorage_lifecycle" {
  compartment_id = var.tenancy_ocid
  name           = "insaeng-objectstorage-lifecycle"
  description    = "Lets Object Storage run lifecycle rules on the insaeng state buckets."
  freeform_tags  = local.freeform_tags

  statements = [
    "Allow service objectstorage-${var.region} to manage object-family in compartment ${oci_identity_compartment.insaeng_state.name}",
  ]
}

resource "oci_objectstorage_object_lifecycle_policy" "tfstate" {
  namespace = data.oci_objectstorage_namespace.this.namespace
  bucket    = oci_objectstorage_bucket.tfstate.name

  rules {
    name        = "delete-previous-versions"
    target      = "previous-object-versions"
    action      = "DELETE"
    time_amount = 30
    time_unit   = "DAYS"
    is_enabled  = true
  }

  rules {
    name        = "delete-stale-locks"
    target      = "objects"
    action      = "DELETE"
    time_amount = 1
    time_unit   = "DAYS"
    is_enabled  = true

    object_name_filter {
      inclusion_patterns = ["*.lock"]
    }
  }

  depends_on = [oci_identity_policy.objectstorage_lifecycle]
}

resource "oci_objectstorage_object_lifecycle_policy" "tfstate_foundation" {
  namespace = data.oci_objectstorage_namespace.this.namespace
  bucket    = oci_objectstorage_bucket.tfstate_foundation.name

  rules {
    name        = "delete-previous-versions"
    target      = "previous-object-versions"
    action      = "DELETE"
    time_amount = 30
    time_unit   = "DAYS"
    is_enabled  = true
  }

  rules {
    name        = "delete-stale-locks"
    target      = "objects"
    action      = "DELETE"
    time_amount = 1
    time_unit   = "DAYS"
    is_enabled  = true

    object_name_filter {
      inclusion_patterns = ["*.lock"]
    }
  }

  depends_on = [oci_identity_policy.objectstorage_lifecycle]
}
