variable "filename" {
  description = "The name of the file to create"
  type        = string
  default     = "pet.txt"
}

variable "content" {
  description = "The content of the file to create"
  type        = string
  default     = "We love pets!"
}

variable "prefix" {
  description = "The prefix to add to the pet name"
  type        = string
  default     = "Mrs"
}

variable "separator" {
  description = "The separator to use between the prefix and the pet name"
  type        = string
  default     = "."
}

variable "length" {
  description = "The length of the pet name"
  type        = number
  default     = 1
}
