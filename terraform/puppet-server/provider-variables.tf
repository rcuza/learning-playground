variable "key_name" {
    description = "Name of the SSH keypair to use in AWS."
}

variable "key_path" {
    description = "Path to the private portion of the SSH key specified."
}

variable "aws_region" {
    description = "AWS region to launch servers."
    default = "us-west-2"
}

variable "cg_network" {
    description = "CG Subnet"
    default = "69.38.250.0/24"
}

# Ubuntu 14.04 LTS (x64, HVM)
variable "aws_amis_ubuntu" {
    default = {
        us-east-1 = "ami-d05e75b8"
        us-west-1 = "ami-df6a8b9b"
        us-west-2 = "ami-5189a661"
    }
}
# Amazon Linux AMI 2015.03 (x64, HVM)
variable "aws_amis_amazon" {
    default = {
        us-east-1 = "ami-1ecae776"
        us-west-1 = "ami-d114f295"
        us-west-2 = "ami-e7527ed7"
    }
}

