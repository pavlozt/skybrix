locals {
  size_params = {
    tiny   = { cores = 2, memory = 1, boot_disk_size = 20, platform = "standard-v4a", fraction = 50, boot_disk_type = "network-hdd" }
    small  = { cores = 2, memory = 2, boot_disk_size = 20, platform = "standard-v4a", fraction = 100, boot_disk_type = "network-hdd" }
    medium = { cores = 4, memory = 4, boot_disk_size = 20, platform = "standard-v4a", fraction = 100, boot_disk_type = "network-ssd" }
    large  = { cores = 4, memory = 8, boot_disk_size = 20, platform = "standard-v4a", fraction = 100, boot_disk_type = "network-ssd" }
  }

  # Get parameters for the selected size or default to "small"
  selected_size = var.size != null ? var.size : "small"
  params        = local.size_params[local.selected_size]

  # Final parameters
  cores          = local.params.cores
  memory         = local.params.memory
  core_fraction  = local.params.fraction
  platform       = local.params.platform
  boot_disk_size = local.params.boot_disk_size
  boot_disk_type = local.params.boot_disk_type
}
