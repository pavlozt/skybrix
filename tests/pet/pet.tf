terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}
resource "random_pet" "pet" {
  prefix = "tftst"
  length = 3
}
output "pet" {
  value = random_pet.pet.id
}
