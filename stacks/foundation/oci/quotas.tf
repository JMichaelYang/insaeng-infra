locals {
  quota_scope = "in compartment ${oci_identity_compartment.insaeng.name}"

  free_tier_quota_statements = [
    "zero compute-core quotas ${local.quota_scope}",
    "set compute-core quota standard-a1-core-count to 4 ${local.quota_scope}",
    "zero compute-memory quotas ${local.quota_scope}",
    "set compute-memory quota standard-a1-memory-count to 24 ${local.quota_scope}",
    "set block-storage quota total-storage-gb to 200 ${local.quota_scope}",
    "zero load-balancer quotas ${local.quota_scope}",
  ]
}

resource "oci_limits_quota" "insaeng_free_tier" {
  compartment_id = var.tenancy_ocid
  name           = "insaeng-free-tier"
  description    = "Limits the insaeng compartment to Always Free A1 compute, 200 GB of block and boot storage and no load balancers."
  statements     = local.free_tier_quota_statements
  freeform_tags  = local.freeform_tags

  depends_on = [oci_identity_compartment.insaeng]
}
