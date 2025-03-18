module "vpc" {
  #source      = "../terraform-aws-vpc"
  source = "git::https://github.com/Rakeshreddy-07/terraform-aws-vpc.git?ref=main"
  environment = var.environment
  project     = var.project
  cidr_block  = var.cidr_block
  common_tags = var.common_tags
  vpc_tags    = var.vpc_tags
  igw_tags = var.igw
  public_subnet_cidr = var.public_subnet
  public_subnet_tags = var.public_tags
  private_subnet_cidr = var.private_subnet
  private_subnet_tags = var.private_tags
  database_subnet_cidr = var.database_subnet
  database_subnet_tags = var.database_tags
  nat_gw_tags = var.nat_tags
  vpc_peering_tags = var.vpc_peering_tags
  is_peering_required = true
}

resource "aws_db_subnet_group" "expense" {
  name       = "${var.project}-${var.environment}"
  subnet_ids = module.vpc.database_subnet_id

  tags = merge(
    var.common_tags,
    {
    Name = "${var.project}-${var.environment}"
  }
  )
}