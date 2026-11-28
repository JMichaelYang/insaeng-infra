variable "compartment_id" {
  description = "OCID of the compartment that holds the network."
  type        = string
}

variable "name" {
  description = "Display name for the VCN and subnet, and prefix for the other resources."
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block for the VCN and its single subnet."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "cidr_block must be a valid IPv4 CIDR block, such as 10.0.0.0/16."
  }
}

variable "freeform_tags" {
  description = "Freeform tags applied to every resource."
  type        = map(string)
  default     = {}
}
