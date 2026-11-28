terraform {
  backend "oci" {
    key = "nodes/terraform.tfstate"
  }
}
