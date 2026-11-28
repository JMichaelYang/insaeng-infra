resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.cidr_block]
  display_name   = var.name
  freeform_tags  = var.freeform_tags
}

resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.name}-igw"
  enabled        = true
  freeform_tags  = var.freeform_tags
}

resource "oci_core_default_route_table" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_route_table_id
  display_name               = "${var.name}-default"
  freeform_tags              = var.freeform_tags

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

# Egress only. There are deliberately no ingress_security_rules: OCI's default
# security list allows SSH from anywhere, and Tailscale is the only way in.
resource "oci_core_default_security_list" "this" {
  manage_default_resource_id = oci_core_vcn.this.default_security_list_id
  display_name               = "${var.name}-default"
  freeform_tags              = var.freeform_tags

  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
}

# Regional (no availability_domain) and public, so the node gets an ephemeral
# public IP for outbound traffic.
resource "oci_core_subnet" "this" {
  compartment_id             = var.compartment_id
  vcn_id                     = oci_core_vcn.this.id
  cidr_block                 = var.cidr_block
  display_name               = var.name
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_default_route_table.this.id
  security_list_ids          = [oci_core_default_security_list.this.id]
  freeform_tags              = var.freeform_tags
}
