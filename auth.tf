

resource "vault_jwt_auth_backend" "tfe" {
    description         = "Terraform Workload Identity JWT auth backend"
    type                = "jwt"
    path                = "tfe"
    oidc_discovery_url  = "${var.tfe_issuer_url}"
    bound_issuer        = "${var.tfe_issuer_url}"
}

resource "vault_jwt_auth_backend_role" "tfe_token_exchange" {
  backend         = vault_jwt_auth_backend.tfe.path
  role_name       = "tfe_token_exchange"
  token_policies  = ["default", "tfe_token_exchange"]

  bound_audiences = ["${var.tfe_jwt_audience}"]
  user_claim      = "terraform_full_workspace"
  role_type       = "jwt"
  claim_mappings = {"terraform_project_id":"terraform_project_id",
  "terraform_workspace_id":"terraform_workspace_id",
  "terraform_organization_id":"terraform_organization_id",
  "terraform_full_workspace":"terraform_full_workspace",
  "terraform_run_id":"terraform_run_id",
  "terraform_run_phase":"terraform_run_phase",
  "terraform_organization_name":"terraform_organization_name",
  "terraform_project_name":"terraform_project_name",
  "terraform_workspace_name":"terraform_workspace_name",
  "role":"token_role"}
}

