variable "project" {
    default = "expense"
  
}

variable "environment" {
    default = "dev"
  
}

variable "common_tags" {
    default = {
        Terraform = "True"
        Test = "Practice"
    }
  
}

variable "description" {
    default = ""
  
}

variable "sg_tags" {
    default = {
        Purpose = "Practice"
    }
  
}

