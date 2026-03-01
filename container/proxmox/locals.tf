locals {
  size_params = {
    tiny   = { cores = 1, memory = 1, boot_disk_size = 5 }
    small  = { cores = 2, memory = 2, boot_disk_size = 10 }
    medium = { cores = 4, memory = 4, boot_disk_size = 20 }
    large  = { cores = 4, memory = 8, boot_disk_size = 40 }
  }

  # Get parameters for the selected size or default to "small"
  selected_size = var.size != null ? var.size : "small"
  params        = local.size_params[local.selected_size]

  # Final parameters
  cores  = local.params.cores
  memory = local.params.memory
}