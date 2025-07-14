output "server_profile_template_moid" {
  description = "MOID of the created Server Profile Template"
  value       = intersight_server_profile_template.ucs_server_profile_template.moid
}

output "server_profile_template_name" {
  description = "Name of the created Server Profile Template"
  value       = intersight_server_profile_template.ucs_server_profile_template.name
}

output "ucs_domain_profile_moid" {
  description = "MOID of the UCS Domain Profile"
  value       = intersight_fabric_switch_cluster_profile.ucs_domain_profile.moid
}

output "uuid_pool_moid" {
  description = "MOID of the UUID Pool"
  value       = intersight_uuidpool_pool.uuid_pool.moid
}

output "mac_pool_a_moid" {
  description = "MOID of MAC Pool A"
  value       = intersight_macpool_pool.mac_pool_a.moid
}

output "mac_pool_b_moid" {
  description = "MOID of MAC Pool B"
  value       = intersight_macpool_pool.mac_pool_b.moid
}

output "ip_pool_moid" {
  description = "MOID of the IP Pool"
  value       = intersight_ippool_pool.ip_pool.moid
}

output "bios_policy_moid" {
  description = "MOID of the BIOS Policy"
  value       = intersight_bios_policy.m7_bios_policy.moid
}

output "boot_policy_moid" {
  description = "MOID of the Boot Policy"
  value       = intersight_boot_precision_policy.m2_boot_policy.moid
}

output "storage_policy_moid" {
  description = "MOID of the Storage Policy"
  value       = intersight_storage_storage_policy.m2_raid_policy.moid
}

output "resources_created" {
  description = "Summary of all created resources"
  value = {
    pools = {
      uuid_pool    = intersight_uuidpool_pool.uuid_pool.name
      mac_pool_a   = intersight_macpool_pool.mac_pool_a.name
      mac_pool_b   = intersight_macpool_pool.mac_pool_b.name
      ip_pool      = intersight_ippool_pool.ip_pool.name
    }
    policies = {
      ntp_policy        = intersight_ntp_policy.ntp_policy.name
      snmp_policy       = intersight_snmp_policy.snmp_policy.name
      bios_policy       = intersight_bios_policy.m7_bios_policy.name
      power_policy      = intersight_power_policy.chassis_power_policy.name
      thermal_policy    = intersight_thermal_policy.chassis_thermal_policy.name
      imc_access_policy = intersight_access_policy.imc_access_policy.name
      kvm_policy        = intersight_kvm_policy.kvm_policy.name
      vmedia_policy     = intersight_vmedia_policy.vmedia_policy.name
      ipmi_policy       = intersight_ipmioverlan_policy.ipmi_policy.name
      local_user_policy = intersight_iam_end_point_user_policy.local_user_policy.name
      boot_policy       = intersight_boot_precision_policy.m2_boot_policy.name
      storage_policy    = intersight_storage_storage_policy.m2_raid_policy.name
      qos_policy_1500   = intersight_vnic_eth_qos_policy.mtu1500_qos_policy.name
      qos_policy_9000   = intersight_vnic_eth_qos_policy.mtu9000_qos_policy.name
      network_control   = intersight_fabric_eth_network_control_policy.network_control_policy.name
      ethernet_adapter  = intersight_vnic_eth_adapter_policy.ethernet_adapter_policy.name
    }
    profiles = {
      ucs_domain_profile        = intersight_fabric_switch_cluster_profile.ucs_domain_profile.name
      server_profile_template   = intersight_server_profile_template.ucs_server_profile_template.name
    }
  }
}
