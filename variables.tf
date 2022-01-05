#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/clouddrove/terraform-azure-nsg"
  description = "Terraform current module repo"

  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}

variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `organization`, `environment`, `name` and `attributes`."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "managedby" {
  type        = string
  default     = "hello@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove'."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Flag to control the module creation"
}

## Virtual Network
variable "resource_group_name" {
  type        = string
  default     = ""
  description = "The name of the resource group in which to create the virtual network."
}

variable "location" {
  type        = string
  default     = ""
  description = "Location where resource should be created."
}

variable "create" {
  type        = string
  default     = "30m"
  description = "Used when creating the Resource Group."
}

variable "update" {
  type        = string
  default     = "30m"
  description = "Used when updating the Resource Group."
}

variable "read" {
  type        = string
  default     = "5m"
  description = "Used when retrieving the Resource Group."
}

variable "delete" {
  type        = string
  default     = "30m"
  description = "Used when deleting the Resource Group."
}

variable "source_application_security_group_ids" {
  type        = list(any)
  default     = []
  description = "A List of source Application Security Group ID's."
}

variable "destination_application_security_group_ids" {
  type        = list(any)
  default     = []
  description = "A List of destination Application Security Group ID's."
}

variable "access" {
  type        = string
  default     = "Allow"
  description = "Specifies whether network traffic is allowed or denied. Possible values are Allow and Deny."
}

variable "priority" {
  type        = number
  default     = 1001
  description = "Specifies the priority of the rule. The value can be between 100 and 4096."
}

variable "custom_port" {
  type        = list(any)
  description = <<-DOC
    A list of maps of custom port.
    name:
    protocol:
    source_port_range:
    destination_port_ranges:
    source_address_prefixes:
    source_application_security_group_ids:
    destination_address_prefixes: for list of ip address
    destination_address_prefix : for all ip address(*) or Virtualnetwork
    destination_application_security_group_ids:
    access:
    priority:
    tags:
  DOC
  default     = []
}
