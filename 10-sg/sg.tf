module "mysql_sg" {
    source = "git::https://github.com/Rakeshreddy-07/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    common_tags = var.common_tags
    sg_tags = var.sg_tags
    description = "created for mysql"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "mysql"
}

module "bastion_sg" {
    source = "git::https://github.com/Rakeshreddy-07/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    common_tags = var.common_tags
    sg_tags = var.sg_tags
    description = "created for bastion"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "bastion"
}

module "eks_control_plane_sg" {
    source = "git::https://github.com/Rakeshreddy-07/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    common_tags = var.common_tags
    sg_tags = var.sg_tags
    description = "created for eks_control_plane"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "eks_control_plane"
}

module "eks_node_sg" {
    source = "git::https://github.com/Rakeshreddy-07/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    common_tags = var.common_tags
    sg_tags = var.sg_tags
    description = "created for eks_node_sg"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "eks_node_sg"
}


#VPN SG #ports 22,443,1194,943
module "vpn_sg" {
    source = "git::https://github.com/Rakeshreddy-07/terraform-aws-securitygroup.git?ref=main"
    project = var.project
    environment = var.environment
    common_tags = var.common_tags
    sg_tags = var.sg_tags
    description = "created for vpn"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    sg_name = "vpn"
}



#add SG rule in app alb SG 

resource "aws_security_group_rule" "eks_control_plane_node" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id       = module.eks_node_sg.sg_id
  security_group_id = module.eks_control_plane_node.sg_id
}


resource "aws_security_group_rule" "eks_node_control_plane" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id       = module.eks_control_plane.sg_id
  security_group_id = module.eks_node_sg.sg_id
}


resource "aws_security_group_rule" "eks_node_ingress_alb" {
  type              = "ingress"
  from_port         = 30000
  to_port           = 32767
  protocol          = "-1"
  source_security_group_id       = module.alb_ingress_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}

resource "aws_security_group_rule" "node_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = module.eks_node_sg.sg_id
}


resource "aws_security_group_rule" "node_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}

resource "aws_security_group_rule" "node_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.sg_id
  security_group_id = module.eks_node_sg.sg_id
}


resource "aws_security_group_rule" "app_ingress_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.sg_id
  security_group_id = module.alb_ingress_sg.sg_id
}


resource "aws_security_group_rule" "app_ingress_bastion_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.sg_id
  security_group_id = module.alb_ingress_sg.sg_id
}

resource "aws_security_group_rule" "app_ingress_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.alb_ingress_sg.sg_id
}


#add inbound rule to bastion SG
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion_sg.sg_id
}



resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id       = module.bastion_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

resource "aws_security_group_rule" "mysql_eks_node" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id       = module.eks_node_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}