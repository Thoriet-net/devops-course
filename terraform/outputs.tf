output "pet_name" {
  value = random_pet.name.id
}

output "suffix_hex" {
  value = random_id.suffix.hex
}