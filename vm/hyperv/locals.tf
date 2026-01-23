locals {
  size_params = {
    tiny   = { cores = 1, boot_disk_size = 20, memory = 1 }
    small  = { cores = 2, boot_disk_size = 20, memory = 2 }
    medium = { cores = 4, boot_disk_size = 20, memory = 4 }
    large  = { cores = 8, boot_disk_size = 20, memory = 8 }
  }

  # Get parameters for the selected size or default to "small"
  selected_size = var.size != null ? var.size : "small"
  params        = local.size_params[local.selected_size]

  # Final parameters
  cores          = local.params.cores
  memory         = local.params.memory
  boot_disk_size = local.params.boot_disk_size


  notes = "Managed by Terraform. Based on image ${var.image_id}."
  // TODO : add labels for project, environment , etc

}
