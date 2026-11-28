terraform {
  backend "oci" {
    key = "network/terraform.tfstate"
  }
}
