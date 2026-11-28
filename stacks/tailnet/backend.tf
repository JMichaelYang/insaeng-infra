terraform {
  backend "oci" {
    key = "tailnet/terraform.tfstate"
  }
}
