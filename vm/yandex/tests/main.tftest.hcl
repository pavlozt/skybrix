provider "yandex" {
  token       = var.yandex_token
  cloud_id    = var.yandex_cloud_id
  folder_id   = var.yandex_folder_id
  zone        = var.yandex_zone
  max_retries = 3
}

variable "yandex_token" {
  type        = string
  description = "YandexCloud token"
}

variable "yandex_cloud_id" {
  type        = string
  description = "YandexCloud cloud id"
}
variable "yandex_folder_id" {
  type        = string
  description = "YandexCloud folder id"
}

variable "yandex_zone" {
  type        = string
  description = "YandexCloud zone"
  default     = "ru-central1-a"
}


run "setup" {
  module {
    source = "../../tests/pet/"
  }
}
run "plan" {
  command = plan
  variables {
    name = run.setup.pet
  }
}
run "create_vm" {
  command = apply
  variables {
    name                = run.setup.pet
    low_cost            = true
    size                = "small"
    ssh_public_key_file = "~/.ssh/id_ed25519.pub"
    name_suffix         = "tf-test"
    extra_disks = {
      "data" = { size = 5, type = "network-ssd" },
      "logs" = { size = 10, type = "network-hdd" }
    }
  }
  assert {
    condition     = yandex_compute_instance.vm.name == "${run.setup.pet}-tf-test"
    error_message = "VM name does not match expected pattern"
  }
  assert {
    condition     = yandex_compute_instance.vm.status == "running"
    error_message = "vm status not matched"
  }
  assert {
    condition     = yandex_compute_instance.vm.network_interface[0].nat_ip_address != null && output.host_info.ip != ""
    error_message = "VM IP address is empty"
  }
  assert {
    condition     = output.host_info.ip != null && output.host_info.ip != ""
    error_message = "Output IP address is empty"
  }
  assert {
    condition     = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", output.host_info.ip))
    error_message = "Output IP address is not a valid IPv4 address"
  }
  assert {
    condition     = output.host_info.ssh_username == "ops"
    error_message = "SSH username is not 'ops'"
  }
  assert {
    condition     = yandex_compute_instance.vm.metadata != null
    error_message = "VM metadata is null"
  }
  assert {
    condition     = yandex_compute_instance.vm.metadata["user-data"] != null
    error_message = "Metadata does not contain 'user-data' key"
  }
  assert {
    condition     = can(regex("#cloud-config", yandex_compute_instance.vm.metadata["user-data"]))
    error_message = "user-data does not contain '#cloud-config' string"
  }
}




