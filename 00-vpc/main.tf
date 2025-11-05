module "vpc" {
    source = "../../vpc-module-now"
    cidr_block = var.cidr_block
    environment = var.environment
    project = var.project
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    database_subnet_cidr = var.database_subnet_cidr
}
output "vpc_id" {
    value = module.vpc.vpc_id
}
output "public_subnets" {
    value = module.vpc.public_subnets
}
output "private_subnets" {
    value = module.vpc.private_subnets
}
output "database_subnets" {
    value = module.vpc.database_subnets
}