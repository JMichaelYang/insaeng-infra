locals {
  shape       = "VM.Standard.A1.Flex"
  data_device = "/dev/oracleoci/oraclevdb"
}

module "bootstrap" {
  source = "../node-bootstrap"

  name        = var.name
  ts_auth_key = var.ts_auth_key
  data_device = local.data_device
}

data "oci_core_volume" "data" {
  volume_id = var.volume_id
}

data "oci_core_images" "ubuntu" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  shape                    = local.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "terraform_data" "generation" {
  input = var.generation
}

resource "oci_core_instance" "this" {
  compartment_id       = var.compartment_id
  availability_domain  = data.oci_core_volume.data.availability_domain
  display_name         = var.name
  shape                = local.shape
  preserve_boot_volume = false
  freeform_tags        = var.freeform_tags

  shape_config {
    ocpus         = var.size.ocpus
    memory_in_gbs = var.size.memory_gb
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.ubuntu.images[0].id
    boot_volume_size_in_gbs = 100
    boot_volume_vpus_per_gb = 10
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    hostname_label   = var.name
  }

  launch_options {
    is_pv_encryption_in_transit_enabled = true
  }

  instance_options {
    are_legacy_imds_endpoints_disabled = true
  }

  metadata = {
    user_data = module.bootstrap.user_data_base64
  }

  lifecycle {
    ignore_changes       = [source_details[0].source_id, metadata]
    replace_triggered_by = [terraform_data.generation]
  }
}

resource "oci_core_volume_attachment" "data" {
  instance_id                         = oci_core_instance.this.id
  volume_id                           = var.volume_id
  attachment_type                     = "paravirtualized"
  device                              = local.data_device
  is_pv_encryption_in_transit_enabled = true
}
