variable "dt_env_url" {
  description = "Dynatrace environment URL - injected via TF_VAR_dt_env_url from GitHub Secrets"
  type        = string
  sensitive   = true
}

variable "dt_api_token" {
  description = "Dynatrace API token - injected via TF_VAR_dt_api_token from GitHub Secrets"
  type        = string
  sensitive   = true
}

variable "platform_token" {
  description = "Dynatrace platform token - required for new platform resources (documents, dashboards)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "environment" {
  description = "Deployment environment - set by pipeline from github.ref (never hardcoded)"
  type        = string
  default     = "DEV"

  validation {
    condition     = contains(["DEV", "STAGING", "PROD"], var.environment)
    error_message = "environment must be DEV, STAGING, or PROD."
  }
}
