provider "oci" {
  auth                = var.oci_auth
  config_file_profile = var.oci_auth == "SecurityToken" ? var.oci_profile : null
  region              = var.region
}
