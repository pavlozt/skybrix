locals {
  size_params = {
    tiny   = { cores = 1, memory = 1 }
    small  = { cores = 2, memory = 2 }
    medium = { cores = 4, memory = 4 }
    large  = { cores = 8, memory = 8 }
  }

  # Get parameters for the selected size or default to "small"
  selected_size = var.size != null ? var.size : "small"
  params        = local.size_params[local.selected_size]

  # Final parameters
  cores  = local.params.cores
  memory = local.params.memory
}
