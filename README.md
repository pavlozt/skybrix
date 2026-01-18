# ☁️🧱 SkyBrix  - Unified Terraform Modules for Multi-Cloud and On-Premise Infrastructure

SkyBrix provides a set of reusable Terraform modules designed to simplify complex and diverse environments, including public clouds and on-premise hypervisors, through a single consistent interface. These pre-built components allow for the quick and effortless deployment of short-lived environments, which are ideal for cloud testing scenarios.

## Key Benefits:
-  Unified configuration patterns.
-  Rapid prototyping across different environments.
-  Minimal code changes when switching between clouds or on-premise. Just replace path to modules.

## Supported Providers

### Compute Providers
- **[Yandex Cloud](vm/yandex/)** - Virtual Machines
- **[Digital Ocean](vm/do/)** - Droplets
- **[Hyper-V](vm/hyperv)** - Virtual Machines (with cloud-init .iso support)

### DNS Providers
- **[Cloudflare](dns/record/cloudflare/)** - DNS management (without proxing)
- **[RouterOS (Mikrotik)](dns/record/routeros/)** - Router operating system with DNS server support


## Example Usage

```hcl
module "vm" {
  source       = "github.com/pavlozt/skybrix//vm/yandex"
  // change to another provder:
  // source       = "github.com/pavlozt/skybrix//vm/do"
  name         = "vm"
  size         = "small"
  // OS images, however, may be named differently among different providers.
  image_family = "ubuntu-24-04-lts"
  ssh_username   = "ops"
  provider_opts       = var.provider_opts
  admin_public_key_file = "~/.ssh/id_ed25519.pub"
}

// Ansible static inventory file
module "inventory_dev" {
  source    = "github.com:/pavlozt/skybrix//local/inventory/ansible"
  groupname = "servers"
  inventory_file = "../hosts/dev/inventory.yaml"
  hosts          = [module.vm.host_info] // or create ip list from other modules output
}

// DNS record management
module "dns_control" {
  source      = "github.com/pavlozt/skybrix.git//dns/record/cloudflare"
  name        = "control"
  ip          = module.vm.host_info.ip
  zone_name   = var.zone_name
  zone_suffix = var.zone_suffix
}
```


