variable "name" {
  description = "Node name, used as the instance display name, VNIC hostname label and tailnet hostname."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.name))
    error_message = "name must be a DNS label of 2 to 63 characters that starts with a letter: lowercase letters, digits and hyphens."
  }
}

variable "size" {
  description = "OCPUs and memory in GB for the VM.Standard.A1.Flex shape."
  type = object({
    ocpus     = number
    memory_gb = number
  })

  validation {
    condition     = var.size.ocpus >= 1 && floor(var.size.ocpus) == var.size.ocpus
    error_message = "size.ocpus must be a whole number of at least 1."
  }

  validation {
    condition     = var.size.memory_gb >= var.size.ocpus && var.size.memory_gb <= var.size.ocpus * 64
    error_message = "size.memory_gb must be between 1 and 64 GB per OCPU."
  }
}

variable "ts_auth_key" {
  description = "One-time Tailscale auth key passed to node-bootstrap."
  type        = string
  sensitive   = true
}

variable "compartment_id" {
  description = "OCID of the compartment for the instance and the image lookup."
  type        = string
}

variable "subnet_id" {
  description = "OCID of the subnet for the primary VNIC."
  type        = string
}

variable "volume_id" {
  description = "OCID of the data block volume to attach. The instance launches in its availability domain."
  type        = string
}

variable "generation" {
  description = "Bump to replace the instance. Image and metadata changes alone never replace it."
  type        = number

  validation {
    condition     = var.generation >= 0 && floor(var.generation) == var.generation
    error_message = "generation must be a whole number of at least 0."
  }
}

variable "freeform_tags" {
  description = "Freeform tags for the instance."
  type        = map(string)
  default     = {}
}
