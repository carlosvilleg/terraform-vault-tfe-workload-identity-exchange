

resource "vault_identity_oidc_key" "tfe_token_exchange" {
  name      = "tfe_token_exchange"
  algorithm = "RS256"
}

resource "vault_identity_oidc_role" "tfe_token_exchange" {
  name = "tfe_token_exchange"
  key  = vault_identity_oidc_key.tfe_token_exchange.name
  ttl = 86400
  client_id = "Service Provider APIs"
  template = <<EOT
 {"role": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.role}},
 "terraform_project_id": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.terraform_project_id}},
 "terraform_workspace_id": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.terraform_workspace_id}},
  "terraform_organization_id": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.terraform_organization_id}},
  "terraform_full_workspace": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.terraform_full_workspace}},
  "terraform_run_id": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.terraform_run_id}},
  "terraform_run_phase": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.terraform_run_phase}},
  "terraform_organization_name": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.terraform_organization_name}},
  "terraform_project_name": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.terraform_project_name}},
  "terraform_workspace_name": {{identity.entity.aliases.${vault_jwt_auth_backend.tfe.accessor}.metadata.terraform_workspace_name}}
 }
EOT
}

resource "vault_identity_oidc_key_allowed_client_id" "role" {
  key_name          = vault_identity_oidc_key.tfe_token_exchange.name
  allowed_client_id = vault_identity_oidc_role.tfe_token_exchange.client_id
}

resource "vault_policy" "tfe_token_exchange" {
  name = "tfe_token_exchange"

  policy = <<EOT
path "identity/oidc/token/tfe_token_exchange" {
  	capabilities = ["read"]
}

# Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}
EOT
}
