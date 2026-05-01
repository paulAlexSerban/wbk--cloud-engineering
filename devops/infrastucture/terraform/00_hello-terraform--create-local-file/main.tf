# resource resource_type resource_name {
#   argument1 = value1
#
# }
# resource_type: the type of resource you want to create (e.g. aws_instance, local_file)
# resource_name: a name you choose to identify the resource in the Terraform state file (e.g. my_instance, my_file)
# resource types are available in the Terraform registry - https://registry.terraform.io/
# each resource type has its own set of arguments that it accepts

resource "local_file" "hello_terraform" {
  content         = "Hello, Terraform! I am updated again;)"
  filename        = "${path.module}/dist/hello.txt"
  file_permission = 0700
}
