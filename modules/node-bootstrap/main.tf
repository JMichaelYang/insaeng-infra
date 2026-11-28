locals {
  user_data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    name        = var.name
    ts_auth_key = var.ts_auth_key
    data_device = var.data_device
  })
}
