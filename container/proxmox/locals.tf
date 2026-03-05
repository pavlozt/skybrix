locals {
  size_params = {
    tiny   = { cores = 1, memory = 1, boot_disk_size = 5 }
    small  = { cores = 2, memory = 2, boot_disk_size = 10 }
    medium = { cores = 4, memory = 4, boot_disk_size = 20 }
    large  = { cores = 4, memory = 8, boot_disk_size = 40 }
  }

  # Fallback to "small" if var.size is not provided
  selected_preset = coalesce(var.size, "small")
  preset_params   = local.size_params[local.selected_preset]

  # Logic: Variable Override > Preset Value
  # coalesce returns the first non-null value
  cores  = coalesce(var.cpu, local.preset_params.cores)
  memory = coalesce(var.memory, local.preset_params.memory)
  boot_disk_size = coalesce(var.boot_disk_size, local.preset_params.boot_disk_size)

}