locals {
  distro_packages = {
    debian = ["hyperv-daemons"]
    ubuntu = ["linux-azure"]
    rocky  = ["hyperv-daemons"]
    centos = ["hyperv-daemons"]
    rhel   = ["hyperv-daemons"]
    fedora = ["hyperv-daemons"]
  }
  detected_distro = [
    for distro in keys(local.distro_packages) : distro if length(regexall(distro, var.image_id)) > 0
  ]
  os_specific_packages = length(local.detected_distro) > 0 ? local.distro_packages[local.detected_distro[0]] : []
}

