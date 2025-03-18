variable "environment" {
  default = "dev"

}

variable "project" {
  default = "expense"

}

variable "cidr_block" {
  default = "10.0.0.0/16"

}

variable "common_tags" {
  type = map(any)
  default = {
    project     = "expense"
    environment = "dev"
    Terraform   = "true"

  }

}

variable "vpc_tags" {
  default = {
    Purpose = "assignment"
  }

}

variable "igw" {
    default = {
        Purpose = "assignment"
    }
  
}

variable "public_subnet" {
    default = ["10.0.1.0/24", "10.0.2.0/24"]
  
}

variable "public_tags" {
    default = {
        Purpose = "assignment"
    }
}

variable "private_subnet" {
    default = ["10.0.11.0/24", "10.0.12.0/24"]
  
}

variable "private_tags" {
    default = {
        Purpose = "assignment"
    }
}

variable "database_subnet" {
    default = ["10.0.21.0/24", "10.0.22.0/24"]
  
}

variable "database_tags" {
    default = {
        Purpose = "assignment"
    }
}

variable "nat_tags" {
    default = {
        Purpose = "assignment"
    }
}

variable "vpc_peering_tags" {
  default = {
    test = "vpc-peering"
  }
}