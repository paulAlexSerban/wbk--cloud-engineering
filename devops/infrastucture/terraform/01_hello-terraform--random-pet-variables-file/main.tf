resource "local_file" "pet" {
  filename = "${path.module}/dist/${var.filename}"
  content  = "My pet is named ${random_pet.my_pet.id}"

  depends_on = [ random_pet.my_pet ]
}

resource "random_pet" "my_pet" {
  prefix    = var.prefix
  separator = var.separator
  length    = var.length
}

output "pet-name" {
  value = random_pet.my_pet.id
  description = "Record the value of pet IF generate by random_pet resource"
}
