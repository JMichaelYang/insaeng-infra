variable "name" {
  description = "Hostname the node joins the tailnet as."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$", var.name))
    error_message = "name must be a DNS label: lowercase letters, digits and hyphens, at most 63 characters."
  }
}

variable "ts_auth_key" {
  description = "One-time Tailscale auth key. The tailnet tags (tag:server) come from the key itself."
  type        = string
  sensitive   = true

  validation {
    condition     = startswith(var.ts_auth_key, "tskey-")
    error_message = "ts_auth_key must be a Tailscale key starting with tskey-."
  }
}

variable "data_device" {
  description = "Block device path of the data disk, e.g. /dev/oracleoci/oraclevdb on OCI."
  type        = string

  validation {
    condition     = can(regex("^/dev/[A-Za-z0-9._/-]+$", var.data_device))
    error_message = "data_device must be a path under /dev/."
  }
}
