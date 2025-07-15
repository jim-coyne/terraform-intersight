# Terraform-Intersight

This repository provides an Infrastructure-as-Code approach for configuring Cisco UCS in Intersight Managed Mode (IMM) using Terraform modules. It automates the deployment of domain profiles, server policies, pools, and server profile templates.

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

Then edit `terraform.tfvars` with your environment-specific values.

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

### Cleanup

To remove all resources:

```bash
terraform destroy
```

**⚠️ Warning**: This will delete all created Intersight policies and profiles. Ensure no servers are using these profiles before destroying.

## Support and Documentation

- **Cisco Intersight Documentation**: https://intersight.com/help
- **Terraform Intersight Provider**: https://registry.terraform.io/providers/CiscoDevNet/intersight
- **UCS Documentation**: https://www.cisco.com/c/en/us/support/servers-unified-computing/index.html
