terraform {
  backend "oci" {
    key = "foundation/tailscale/terraform.tfstate"
  }
}
