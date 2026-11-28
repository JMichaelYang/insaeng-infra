variable "tenancy_ocid" {
  description = "OCID of the tenancy whose root compartment holds the insaeng compartments."
  type        = string
}

variable "region" {
  description = "OCI region the provider talks to."
  type        = string
}

variable "oci_auth" {
  description = "OCI provider auth method, SecurityToken locally or ResourcePrincipal in GitHub Actions."
  type        = string
  default     = "SecurityToken"

  validation {
    condition     = contains(["SecurityToken", "ResourcePrincipal"], var.oci_auth)
    error_message = "oci_auth must be SecurityToken or ResourcePrincipal."
  }
}

variable "oci_profile" {
  description = "OCI CLI config profile used when oci_auth is SecurityToken."
  type        = string
  default     = "insaeng"
}
