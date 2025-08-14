
variable "tfe_issuer_url" {
	type = string
  #default = "https://app.terraform.io"
}

variable "tfe_jwt_audience" {
	type = string
  default = "tfe_token_exchange"
}

