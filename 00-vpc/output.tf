# output "az_info" {
#     value = module.vpc.az_names
# }

# output "subnet_info" {
#     value = module.vpc.subnet_info
# }

output "vpc_id_info" {
    value = module.vpc.vpc_id
  
}

output "public_subnet_id_info" {
    value = module.vpc.public_subnet_id
}

output "db_subnet_group" {
    value = aws_db_subnet_group.expense.name
  
}