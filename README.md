# Cisco UCS Intersight Terraform Configuration

This Terraform configuration provides a comprehensive deployment for Cisco UCS infrastructure using the Intersight cloud management platform. It creates all necessary policies, pools, and profiles for a complete UCS server deployment.

## Overview

This configuration deploys 22 Intersight resources including:
- **Pools**: UUID, MAC Address (A/B), IP Address
- **Policies**: NTP, SNMP, BIOS, Power, Thermal, Boot, Storage, QoS, Network Control
- **Access Policies**: IMC Access, KVM, Virtual Media, IPMI, Local User
- **Profiles**: UCS Domain Profile, Server Profile Template
- **Network**: Ethernet Adapter and QoS policies with MTU 1500/9000 support

## Prerequisites

1. **Cisco Intersight Account**: Active Intersight account with appropriate permissions
2. **API Key**: Generated API key and private key file from Intersight
3. **Terraform**: Version 1.0 or later
4. **Network Access**: Connectivity to intersight.com

## Setup Instructions

### 1. Clone or Download Configuration

```bash
# If using git
git clone <repository-url>
cd terraform-intersight

# Or download and extract the terraform files to a directory
```

### 2. Generate Intersight API Keys

1. Log into your Intersight account at https://intersight.com
2. Navigate to **Settings** → **API Keys**
3. Click **Generate API Key**
4. Download the private key file (SecretKey.txt)
5. Copy the API Key ID

### 3. Create Variables File

Copy the example variables file and customize it:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Then edit `terraform.tfvars` with your environment-specific values:

```hcl
# Intersight API Configuration - REPLACE WITH YOUR ACTUAL VALUES
api_key_id       = "your-actual-api-key-id-here"
api_private_key  = "-----BEGIN RSA PRIVATE KEY-----\nYOUR-ACTUAL-PRIVATE-KEY-CONTENT\n-----END RSA PRIVATE KEY-----"
api_uri         = "https://intersight.com"

# Organization and Naming
org_name = "default"  # Your Intersight organization name
prefix   = "demo"     # Prefix for all resource names

# UCS Domain Configuration
name_of_ucs_domain               = "demo-UCS-Domain"
description_of_ucs_domain_profile = "Demo UCS Domain Profile"

# Pool Configurations
uuid_prefix      = "AA020000-0000-0001"
mac_pool_a_start = "00:25:B5:AA:00:00"
mac_pool_a_end   = "00:25:B5:AA:00:FF"
mac_pool_b_start = "00:25:B5:BB:00:00"
mac_pool_b_end   = "00:25:B5:BB:00:FF"

# IP Pool Configuration (for in-band management)
ip_pool_start   = "192.168.100.100"
ip_pool_end     = "192.168.100.200"
ip_pool_gateway = "192.168.100.1"
ip_pool_netmask = "255.255.255.0"

# NTP Configuration
ntp_servers = ["pool.ntp.org", "time.nist.gov"]
timezone    = "America/New_York"

# SNMP Configuration (optional)
snmp_contact  = "admin@yourcompany.com"
snmp_location = "Data Center 1"
snmp_user_name = "admin"
```

### 4. Initialize Terraform

```bash
terraform init
```

### 5. Validate Configuration

```bash
terraform validate
```

### 6. Plan Deployment

```bash
terraform plan
```

Review the plan to ensure all 22 resources will be created correctly.

### 7. Deploy Infrastructure

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

## Configuration Details

### Resource Breakdown

| Resource Type | Count | Purpose |
|---------------|-------|---------|
| Pools | 4 | UUID, MAC (A/B), IP address allocation |
| Management Policies | 5 | NTP, SNMP, IMC Access, KVM, Virtual Media |
| Hardware Policies | 4 | BIOS, Power, Thermal, Storage |
| Network Policies | 4 | QoS (1500/9000 MTU), Network Control, Ethernet Adapter |
| Security Policies | 2 | IPMI, Local User Management |
| Boot/Profile | 3 | Boot Order, Domain Profile, Server Profile Template |

### Key Features

- **Complete UCS Management**: All essential policies for server deployment
- **M.2 RAID Support**: Configured storage policy for M.2 drives
- **Dual MTU Support**: QoS policies for both standard (1500) and jumbo (9000) frames
- **Security Hardened**: IPMI, KVM, and user management policies
- **Production Ready**: Proper dependency management and lifecycle rules

### Network Configuration

- **In-band Management**: VLAN 100 with dedicated IP pool
- **MTU Support**: 1500 (standard) and 9000 (jumbo frames)
- **Protocol Support**: CDP and LLDP enabled for network discovery

## Usage Examples

### Deploy with Custom Values

```bash
# Deploy with specific prefix
terraform apply -var="prefix=production"

# Deploy to different organization
terraform apply -var="org_name=MyOrg" -var="prefix=prod"
```

### Viewing Resources

```bash
# List all created resources
terraform state list

# Show specific resource details
terraform show intersight_server_profile_template.ucs_server_profile_template
```

## Maintenance Operations

### Update Configuration

1. Modify variables in `terraform.tfvars`
2. Run `terraform plan` to review changes
3. Run `terraform apply` to implement changes

### Scale Operations

To add additional MAC pools or modify existing pools:

```hcl
# Add to terraform.tfvars
mac_pool_c_start = "00:25:B5:CC:00:00"
mac_pool_c_end   = "00:25:B5:CC:00:FF"
```

Then add the corresponding resource to `main.tf`.

### Cleanup

To remove all resources:

```bash
terraform destroy
```

**⚠️ Warning**: This will delete all created Intersight policies and profiles. Ensure no servers are using these profiles before destroying.

## Troubleshooting

### Common Issues

1. **API Authentication Errors**
   - Verify API key ID and private key are correct
   - Ensure private key includes proper BEGIN/END markers
   - Check Intersight account permissions

2. **Organization Not Found**
   - Verify `org_name` matches your Intersight organization exactly
   - Check organization access permissions

3. **Resource Conflicts**
   - Ensure resource names don't conflict with existing objects
   - Use unique prefixes for different environments

4. **Network Connectivity**
   - Verify internet connectivity to intersight.com
   - Check firewall/proxy settings

### Validation Commands

```bash
# Check Terraform configuration syntax
terraform validate

# Verify provider configuration
terraform providers

# Check current state
terraform state list

# Refresh state from Intersight
terraform refresh
```

### Debug Mode

Enable debug logging for troubleshooting:

```bash
export TF_LOG=DEBUG
terraform apply
```

## Advanced Configuration

### Custom BIOS Settings

The BIOS policy can be extended with specific settings:

```hcl
resource "intersight_bios_policy" "m7_bios_policy" {
  # ... existing configuration ...
  
  # Add specific BIOS settings
  intel_hyper_threading_tech = "enabled"
  intel_virtualization_technology = "enabled"
  # Add more settings as needed
}
```

### Additional Pools

Add additional resource pools as needed:

```hcl
# Additional IP Pool for different VLAN
resource "intersight_ippool_pool" "mgmt_ip_pool" {
  name = "${var.prefix}-MGMT-IP-Pool"
  # ... configuration ...
}
```

## Security Considerations

1. **API Key Security**: 
   - Store API keys securely, never commit to version control
   - Use environment variables or secure vaults for production
   - The `.gitignore` file prevents accidental commits of sensitive files

2. **Variable Files**: 
   - `terraform.tfvars` is excluded from Git by default
   - Use `terraform.tfvars.example` as a template
   - Never commit actual credentials to version control

3. **State Files**: 
   - Terraform state files may contain sensitive data
   - Consider using remote state storage (S3, Terraform Cloud, etc.)
   - State files are excluded from Git by default

4. **Access Control**: Use Intersight RBAC for appropriate access levels

### Setting up Environment Variables (Recommended)

Instead of using `terraform.tfvars`, you can set environment variables:

```bash
export TF_VAR_api_key_id="your-api-key-id"
export TF_VAR_api_private_key="$(cat /path/to/SecretKey.txt)"
export TF_VAR_org_name="your-org-name"
# ... other variables
```

## Support and Documentation

- **Cisco Intersight Documentation**: https://intersight.com/help
- **Terraform Intersight Provider**: https://registry.terraform.io/providers/CiscoDevNet/intersight
- **UCS Documentation**: https://www.cisco.com/c/en/us/support/servers-unified-computing/index.html

## License

This configuration is provided as-is for educational and demonstration purposes. Ensure compliance with your organization's policies and Cisco licensing terms.

---

## Quick Start Summary

1. Get Intersight API keys
2. Create `terraform.tfvars` with your values
3. Run `terraform init && terraform plan && terraform apply`
4. All 22 UCS resources will be created
5. Use the server profile template to deploy servers

For questions or issues, refer to the troubleshooting section or Cisco documentation.

## File Structure

```
terraform-intersight/
├── main.tf                     # Main Terraform configuration
├── variables.tf                # Variable definitions
├── outputs.tf                  # Output definitions
├── versions.tf                 # Provider version requirements
├── terraform.tfvars.example    # Example variables file
├── .gitignore                  # Git ignore rules
└── README.md                   # This documentation
```
