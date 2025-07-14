# Intersight API Configuration
variable "api_key_id" {
  description = "Intersight API Key ID"
  type        = string
  sensitive   = true
}

variable "api_private_key" {
  description = "Intersight API Private Key"
  type        = string
  sensitive   = true
}

variable "api_uri" {
  description = "Intersight API URI"
  type        = string
  default     = "https://intersight.com"
}

# Organization Configuration
variable "org_name" {
  description = "Intersight Organization Name"
  type        = string
}

variable "prefix" {
  description = "Prefix for all resource names"
  type        = string
}

# UCS Domain Configuration
variable "name_of_ucs_domain" {
  description = "Name of the UCS Domain"
  type        = string
}

variable "description_of_ucs_domain_profile" {
  description = "Description of the UCS Domain Profile"
  type        = string
  default     = ""
}

# Pool Configuration Variables
variable "uuid_prefix" {
  description = "UUID Pool Prefix"
  type        = string
}

variable "mac_pool_a_start" {
  description = "MAC Pool A Start Address"
  type        = string
}

variable "mac_pool_a_end" {
  description = "MAC Pool A End Address"
  type        = string
}

variable "mac_pool_b_start" {
  description = "MAC Pool B Start Address"
  type        = string
}

variable "mac_pool_b_end" {
  description = "MAC Pool B End Address"
  type        = string
}

# IP Pool Configuration
variable "ip_pool_start" {
  description = "IP Pool Start Address"
  type        = string
}

variable "ip_pool_end" {
  description = "IP Pool End Address"
  type        = string
}

variable "ip_pool_gateway" {
  description = "IP Pool Gateway"
  type        = string
}

variable "ip_pool_netmask" {
  description = "IP Pool Netmask"
  type        = string
}

# NTP Configuration
variable "ntp_servers" {
  description = "List of NTP Servers"
  type        = list(string)
}

variable "timezone" {
  description = "Timezone"
  type        = string
  default     = "America/New_York"
}

# SNMP Configuration
variable "snmp_contact" {
  description = "SNMP Contact"
  type        = string
  default     = ""
}

variable "snmp_location" {
  description = "SNMP Location"
  type        = string
  default     = ""
}

variable "snmp_user_name" {
  description = "SNMP User Name"
  type        = string
  default     = "admin"
}

variable "snmp_auth_password" {
  description = "SNMP Authentication Password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "snmp_priv_password" {
  description = "SNMP Privacy Password"
  type        = string
  default     = ""
  sensitive   = true
}
