variable "filename" {
  description = "The name of the file to create"
  type        = string
}

variable "content" {
  description = "The content of the file to create"
  type        = string
}

variable "prefix" {
  description = "The prefix to add to the pet name"
  type        = string
}

variable "separator" {
  description = "The separator to use between the prefix and the pet name"
  type        = string
}

variable "length" {
  description = "The length of the pet name"
  type        = number
}
