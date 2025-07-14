# Cisco UCS Intersight Terraform Configuration
# Provider configuration
provider "intersight" {
  apikey    = var.api_key_id
  secretkey = var.api_private_key
  endpoint  = var.api_uri
}

# Get Organization Moid
data "intersight_organization_organization" "org" {
  name = var.org_name
}

# NTP Policy - simplified without tags first
resource "intersight_ntp_policy" "ntp_policy" {
  name         = "${var.prefix}-ntp-policy"
  description  = "NTP Policy"
  enabled      = true
  ntp_servers  = var.ntp_servers
  timezone     = var.timezone

  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# UUID Pool - simplified (removed read-only size property)
resource "intersight_uuidpool_pool" "uuid_pool" {
  name             = "${var.prefix}-UUID-Pool"
  assignment_order = "sequential"
  prefix           = var.uuid_prefix
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# MAC Pool A - simplified
resource "intersight_macpool_pool" "mac_pool_a" {
  name             = "${var.prefix}-MAC-Pool-A"
  assignment_order = "sequential"
  
  mac_blocks {
    from = var.mac_pool_a_start
    to   = var.mac_pool_a_end
  }
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# MAC Pool B - simplified
resource "intersight_macpool_pool" "mac_pool_b" {
  name             = "${var.prefix}-MAC-Pool-B"
  assignment_order = "sequential"
  
  mac_blocks {
    from = var.mac_pool_b_start
    to   = var.mac_pool_b_end
  }
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# UCS Domain Profile (SwitchClusterProfile)
resource "intersight_fabric_switch_cluster_profile" "ucs_domain_profile" {
  name        = var.name_of_ucs_domain
  description = var.description_of_ucs_domain_profile
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# IP Pool
resource "intersight_ippool_pool" "ip_pool" {
  name             = "${var.prefix}-IP-Pool"
  assignment_order = "sequential"
  
  ip_v4_blocks {
    from = var.ip_pool_start
    to   = var.ip_pool_end
  }
  
  ip_v4_config {
    gateway      = var.ip_pool_gateway
    netmask      = var.ip_pool_netmask
    primary_dns  = "8.8.8.8"
    secondary_dns = "8.8.4.4"
  }
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# SNMP Policy
resource "intersight_snmp_policy" "snmp_policy" {
  name         = "${var.prefix}-SNMP-Policy"
  description  = "SNMP Policy"
  enabled      = true
  snmp_port    = 161
  v2_enabled   = false
  v3_enabled   = true
  sys_contact  = var.snmp_contact
  sys_location = var.snmp_location
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Chassis Power Policy
resource "intersight_power_policy" "chassis_power_policy" {
  name                     = "${var.prefix}-Chassis-Power-Policy"
  description              = "Chassis Power Policy"
  extended_power_capacity  = "Enabled"
  power_save_mode          = "Enabled"
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
  
  lifecycle {
    ignore_changes = [profiles]
  }
}

# Chassis Thermal Policy
resource "intersight_thermal_policy" "chassis_thermal_policy" {
  name             = "${var.prefix}-Chassis-Thermal-Policy"
  description      = "Chassis Thermal Policy"
  fan_control_mode = "Balanced"
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# BIOS Policy
resource "intersight_bios_policy" "m7_bios_policy" {
  name        = "${var.prefix}-M7-BIOS-Policy"
  description = "BIOS Policy for M7 Servers"
  
  # Common BIOS settings without complex attributes that might not be supported
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
  
  lifecycle {
    ignore_changes = [profiles]
  }
}

# IMC Access Policy - for in-band management
resource "intersight_access_policy" "imc_access_policy" {
  name         = "${var.prefix}-IMC-Access-Policy"
  description  = "IMC Access Policy for in-band management"
  
  inband_vlan = 100
  inband_ip_pool {
    moid        = intersight_ippool_pool.ip_pool.moid
    object_type = "ippool.Pool"
  }
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# KVM Policy - for virtual KVM access
resource "intersight_kvm_policy" "kvm_policy" {
  name              = "${var.prefix}-KVM-Access-Policy"
  description       = "KVM Policy for virtual KVM access"
  enabled           = true
  maximum_sessions  = 4
  remote_port       = 2068
  enable_video_encryption = true
  enable_local_server_video = true
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Virtual Media Policy
resource "intersight_vmedia_policy" "vmedia_policy" {
  name         = "${var.prefix}-vMedia-Policy"
  description  = "Virtual Media Policy for ISO mounting"
  enabled      = true
  encryption   = true
  low_power_usb = true
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# IPMI over LAN Policy
resource "intersight_ipmioverlan_policy" "ipmi_policy" {
  name         = "${var.prefix}-IPMI-Policy"
  description  = "IPMI over LAN Policy"
  enabled      = true
  privilege    = "admin"
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Local User Policy (using correct IAM endpoint user policy)
resource "intersight_iam_end_point_user_policy" "local_user_policy" {
  name               = "${var.prefix}-LocalUser-Policy"
  description        = "Local User Policy for KVM and IPMI access"
  
  password_properties {
    enforce_strong_password  = false
    enable_password_expiry   = false
    password_expiry_duration = 90
    password_history         = 0
    notification_period      = 15
    grace_period            = 0
  }
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Boot Order Policy for M.2 drives
resource "intersight_boot_precision_policy" "m2_boot_policy" {
  name                     = "${var.prefix}-M2-Boot-Policy"
  description             = "Boot Order Policy for M.2 drives"
  configured_boot_mode    = "Uefi"
  enforce_uefi_secure_boot = false
  
  boot_devices {
    enabled     = true
    name        = "M2Boot"
    object_type = "boot.LocalDisk"
    additional_properties = jsonencode({
      Slot = "MSTOR-RAID"
      Bootloader = {
        Description = ""
        Name        = ""
        ObjectType  = "boot.Bootloader"
        Path        = ""
      }
    })
  }
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Storage Policy for M.2 RAID
resource "intersight_storage_storage_policy" "m2_raid_policy" {
  name         = "${var.prefix}-M2-RAID-Policy"
  description  = "Storage Policy for M.2 RAID configuration"
  unused_disks_state = "NoChange"
  use_jbod_for_vd_creation = true
  
  # M.2 Virtual Drive configuration
  m2_virtual_drive {
    enable      = true
    controller_slot = "MSTOR-RAID-1"
  }
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Ethernet QoS Policy - MTU 1500
resource "intersight_vnic_eth_qos_policy" "mtu1500_qos_policy" {
  name           = "${var.prefix}-MTU1500-QoS-Policy"
  description    = "Ethernet QoS Policy with MTU 1500"
  mtu            = 1500
  rate_limit     = 0
  cos            = 0
  trust_host_cos = false
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Ethernet QoS Policy - MTU 9000
resource "intersight_vnic_eth_qos_policy" "mtu9000_qos_policy" {
  name           = "${var.prefix}-MTU9000-QoS-Policy"
  description    = "Ethernet QoS Policy with MTU 9000"
  mtu            = 9000
  rate_limit     = 0
  cos            = 0
  trust_host_cos = false
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Ethernet Network Control Policy (using correct fabric resource type)
resource "intersight_fabric_eth_network_control_policy" "network_control_policy" {
  name        = "${var.prefix}-Network-Control-Policy"
  description = "Network Control Policy with CDP and LLDP"
  cdp_enabled = true
  forge_mac   = "allow"
  mac_registration_mode = "nativeVlanOnly"
  uplink_fail_action = "linkDown"
  
  lldp_settings {
    receive_enabled  = true
    transmit_enabled = true
  }
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Ethernet Adapter Policy
resource "intersight_vnic_eth_adapter_policy" "ethernet_adapter_policy" {
  name         = "${var.prefix}-Ethernet-Adapter-Policy"
  description  = "Ethernet Adapter Policy"
  
  vxlan_settings {
    enabled = false
  }
  
  nvgre_settings {
    enabled = false
  }
  
  arfs_settings {
    enabled = true
  }
  
  interrupt_settings {
    coalescing_time = 125
    coalescing_type = "MIN"
    nr_count       = 4
    mode           = "MSIx"
  }
  
  completion_queue_settings {
    nr_count  = 4
    ring_size = 1
  }
  
  rx_queue_settings {
    nr_count  = 4
    ring_size = 512
  }
  
  tx_queue_settings {
    nr_count  = 1
    ring_size = 256
  }
  
  tcp_offload_settings {
    large_receive = true
    large_send   = true
    rx_checksum  = true
    tx_checksum  = true
  }
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
}

# Server Profile Template
resource "intersight_server_profile_template" "ucs_server_profile_template" {
  name        = "${var.prefix}-Server-Profile-Template"
  description = "Server Profile Template"
  target_platform = "Standalone"
  
  organization {
    moid        = data.intersight_organization_organization.org.results[0].moid
    object_type = "organization.Organization"
  }
  
  # Assign comprehensive policies
  policy_bucket {
    moid        = intersight_bios_policy.m7_bios_policy.moid
    object_type = "bios.Policy"
  }
  
  policy_bucket {
    moid        = intersight_power_policy.chassis_power_policy.moid
    object_type = "power.Policy"
  }
  
  policy_bucket {
    moid        = intersight_thermal_policy.chassis_thermal_policy.moid
    object_type = "thermal.Policy"
  }
  
  policy_bucket {
    moid        = intersight_access_policy.imc_access_policy.moid
    object_type = "access.Policy"
  }
  
  policy_bucket {
    moid        = intersight_kvm_policy.kvm_policy.moid
    object_type = "kvm.Policy"
  }
  
  policy_bucket {
    moid        = intersight_vmedia_policy.vmedia_policy.moid
    object_type = "vmedia.Policy"
  }
  
  policy_bucket {
    moid        = intersight_ipmioverlan_policy.ipmi_policy.moid
    object_type = "ipmioverlan.Policy"
  }
  
  policy_bucket {
    moid        = intersight_iam_end_point_user_policy.local_user_policy.moid
    object_type = "iam.EndPointUserPolicy"
  }
  
  policy_bucket {
    moid        = intersight_boot_precision_policy.m2_boot_policy.moid
    object_type = "boot.PrecisionPolicy"
  }
  
  policy_bucket {
    moid        = intersight_storage_storage_policy.m2_raid_policy.moid
    object_type = "storage.StoragePolicy"
  }
  
  # UUID Pool assignment
  uuid_pool {
    moid        = intersight_uuidpool_pool.uuid_pool.moid
    object_type = "uuidpool.Pool"
  }
  
  # Explicit dependencies to ensure proper deletion order
  depends_on = [
    intersight_bios_policy.m7_bios_policy,
    intersight_power_policy.chassis_power_policy,
    intersight_thermal_policy.chassis_thermal_policy,
    intersight_access_policy.imc_access_policy,
    intersight_kvm_policy.kvm_policy,
    intersight_vmedia_policy.vmedia_policy,
    intersight_ipmioverlan_policy.ipmi_policy,
    # intersight_iam_local_user_policy.local_user_policy,
    intersight_boot_precision_policy.m2_boot_policy,
    intersight_storage_storage_policy.m2_raid_policy,
    intersight_uuidpool_pool.uuid_pool
  ]
}
