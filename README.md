# ☁️🧱 SkyBrix  - Unified Terraform Modules for Multi-Cloud and On-Premise Infrastructure

SkyBrix provides a set of reusable Terraform modules designed to simplify complex and diverse environments, including public clouds and on-premise hypervisors, through a single consistent interface. These pre-built components allow for the quick and effortless deployment of short-lived environments, which are ideal for cloud testing scenarios.

## Key Benefits:
-  Consistent API across all infrastructure providers.
-  Minimal code changes when switching between clouds or on-premise. Just replace path to modules.
-  Unified configuration patterns.
-  Rapid prototyping across different environments.

## Supported Providers

### Compute Providers
- **[Yandex Cloud](vm/yandex/)** - Virtual Machines
- **[Digital Ocean](vm/do/)** - Droplets
- **[Hyper-V](vm/hyperv)** - Virtual Machines (with cloud-init .iso support)

### DNS Providers
- **[Cloudflare](dns/record/cloudflare/)** - DNS management
- **[RouterOS (Mikrotik)](dns/record/routeros/)** - Router operating system with DNS capabilities


## Example Usage

```hcl
module "vm" {
  source       = "github.com/pavlozt/skybrix//vm/yandex?ref=v0.0.1"
  // change to another provder:
  // source       = "github.com/pavlozt/skybrix//vm/do?ref=v0.0.1"
  name         = "vm"
  size         = "small"
  image_family = var.image_family
  ssh_username   = "ops"
  provider_opts       = var.provider_opts
  admin_public_key_file = "~/.ssh/id_rsa.pub"
}

// Ansible static inventory file
module "inventory_dev" {
  source    = "github.com:/pavlozt/skybrix//local/inventory/ansible?ref=v0.0.1"
  groupname = "servers"
  inventory_file = "../hosts/dev/inventory.yaml"
  hosts          = [module.vm.host_info]
}

// DNS record management
module "dns_control" {
  source      = "github.com/pavlozt/skybrix.git//dns/record/cloudflare?ref=v0.0.1"
  name        = "control"
  ip          = module.vm.host_info.ip
  zone_name   = var.zone_name
  zone_suffix = var.zone_suffix
}
```


