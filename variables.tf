# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ----------------------------------------------------------------------------------------------------------------------

variable "subnetwork" {
  description = "(Required) Used to find the parent resource to bind the IAM policy to"
  type        = string
}

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ----------------------------------------------------------------------------------------------------------------------

variable "members" {
  type        = set(string)
  description = "(Optional) Identities that will be granted the privilege in role. Each entry can have one of the following values: 'allUsers', 'allAuthenticatedUsers', 'user:{emailid}', 'serviceAccount:{emailid}', 'group:{emailid}', 'domain:{domain}', 'projectOwner:projectid', 'projectEditor:projectid', 'projectViewer:projectid'."
  default     = []

  validation {
    condition     = alltrue([for m in var.members : can(regex("^(allUsers|allAuthenticatedUsers|(user|serviceAccount|group|domain|projectOwner|projectEditor|projectViewer):)", m))])
    error_message = "The value must be a non-empty list of strings where each entry is a valid principal type identified with `allUsers`, `allAuthenticatedUsers` or prefixed with `user:`, `serviceAccount:`, `group:`, `domain:`, `projectOwner:`, `projectEditor:` or `projectViewer:`."
  }
}

variable "role" {
  description = "(Optional) The role that should be applied. Only one 'iam_binding' can be used per role. Note that custom roles must be of the format '[projects|organizations]/{parent-name}/roles/{role-name}'."
  type        = string
  default     = null
}

variable "authoritative" {
  description = "(Optional) Whether to exclusively set (authoritative mode) or add (non-authoritative/additive mode) members to the role."
  type        = bool
  default     = true
}

variable "policy_bindings" {
  description = "(Optional) A list of IAM policy bindings."
  type        = any
  default     = null
}

# ----------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ----------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether or not to create resources within the module."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends on."
  default     = []
}
