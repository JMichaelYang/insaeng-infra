data "oci_identity_domains" "default" {
  compartment_id = var.tenancy_ocid
  display_name   = "Default"
}

locals {
  default_domain_url = data.oci_identity_domains.default.domains[0].url
}

resource "oci_identity_domains_app" "github_exchange" {
  idcs_endpoint   = local.default_domain_url
  schemas         = ["urn:ietf:params:scim:schemas:oracle:idcs:App"]
  display_name    = "insaeng-github-exchange"
  description     = "Exchanges GitHub Actions OIDC tokens for OCI sessions for insaeng-infra CI."
  is_oauth_client = true
  client_type     = "confidential"
  allowed_grants  = ["client_credentials"]
  active          = true

  based_on_template {
    value = "CustomWebAppTemplateId"
  }
}

resource "oci_identity_domains_identity_propagation_trust" "github_actions" {
  idcs_endpoint          = local.default_domain_url
  schemas                = ["urn:ietf:params:scim:schemas:oracle:idcs:IdentityPropagationTrust"]
  name                   = "insaeng-github-actions"
  description            = "Trusts GitHub Actions OIDC tokens from insaeng-infra and issues resource principal session tokens."
  type                   = "JWT"
  issuer                 = "https://token.actions.githubusercontent.com"
  public_key_endpoint    = "https://token.actions.githubusercontent.com/.well-known/jwks"
  subject_type           = "Resource"
  subject_claim_name     = "sub"
  allow_impersonation    = true
  impersonating_resource = "insaeng-infra-ci"
  client_claim_name      = "aud"
  client_claim_values    = ["https://cloud.oracle.com"]
  oauth_clients          = [oci_identity_domains_app.github_exchange.name]
  claim_propagations     = ["ext_repository_id", "ext_ref", "ext_environment"]
  active                 = true

  claim_validations {
    name  = "repository_id"
    value = "1475167325"
  }
}
