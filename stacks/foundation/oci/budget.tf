variable "alert_email" {
  description = "Email address that receives the tenancy budget alerts."
  type        = string

  validation {
    condition     = can(regex("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", var.alert_email))
    error_message = "alert_email must be an email address such as name@example.com."
  }
}

resource "oci_budget_budget" "tenancy" {
  compartment_id = var.tenancy_ocid
  target_type    = "COMPARTMENT"
  targets        = [var.tenancy_ocid]
  amount         = 1
  reset_period   = "MONTHLY"
  display_name   = "insaeng-tenancy"
  description    = "Monthly 1 USD budget covering the whole tenancy."
  freeform_tags  = local.freeform_tags
}

resource "oci_budget_alert_rule" "actual" {
  budget_id      = oci_budget_budget.tenancy.id
  type           = "ACTUAL"
  threshold_type = "ABSOLUTE"
  threshold      = 0.01
  display_name   = "insaeng-tenancy-actual"
  description    = "Any actual spend in the tenancy."
  recipients     = var.alert_email
  message        = "OCI tenancy has actual spend this month. Spend should stay at 0 USD."
  freeform_tags  = local.freeform_tags
}

resource "oci_budget_alert_rule" "forecast" {
  budget_id      = oci_budget_budget.tenancy.id
  type           = "FORECAST"
  threshold_type = "PERCENTAGE"
  threshold      = 100
  display_name   = "insaeng-tenancy-forecast"
  description    = "Forecast spend reaches the 1 USD budget."
  recipients     = var.alert_email
  message        = "OCI tenancy spend is forecast to reach the 1 USD monthly budget."
  freeform_tags  = local.freeform_tags
}
