terraform {
  backend "oci" {
    key = "foundation/github/terraform.tfstate"
  }
}
