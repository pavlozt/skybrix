locals {
  size_params = {
    tiny   = { cores = 2, memory = 1, boot_disk_size = 20, platform = "standard-v4a", core_fraction = 50,  boot_disk_type = "network-hdd" }
    small  = { cores = 2, memory = 2, boot_disk_size = 20, platform = "standard-v4a", core_fraction = 100, boot_disk_type = "network-hdd" }
    medium = { cores = 4, memory = 4, boot_disk_size = 20, platform = "standard-v4a", core_fraction = 100, boot_disk_type = "network-ssd" }
    large  = { cores = 4, memory = 8, boot_disk_size = 20, platform = "standard-v4a", core_fraction = 100, boot_disk_type = "network-ssd" }
  }

  # Safe preset selection. If var.size is null or not in the map,
  selected_preset = coalesce(var.size, "small")
  preset_params   = lookup(local.size_params, local.selected_preset, {})

  # Logic: Variable Override > Preset Value > Hardcoded Default
  cores          = coalesce(var.cpu, try(local.preset_params.cores, 2))
  memory         = coalesce(var.memory, try(local.preset_params.memory, 2))
  boot_disk_size = coalesce(var.boot_disk_size, try(local.preset_params.boot_disk_size, 20))
  boot_disk_type = coalesce(var.boot_disk_type, try(local.preset_params.boot_disk_type, "network-hdd"))

  # Fields with strict defaults for core_fraction and platform
  # If size is null or key is missing, these will use defaults.
  core_fraction = try(local.preset_params.core_fraction, 100)
  platform      = try(local.preset_params.platform, "standard-v4a")
}