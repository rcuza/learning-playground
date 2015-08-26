# Specify the provider and access details
provider "aws" {
    region = "${var.aws_region}"
}

# What is our AMI Platform?
variable "amis" {
    description = "Supposed to set our AMI platform, if we can do variables in variables."
    default = "aws_amis_ubuntu"
}
# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
    name = "terraform_loggingstack"
    description = "Used in the terraform logging stack"

    # SSH access from CG
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.cg_network}"]
    }

    # HTTP access from CG
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.cg_network}"]
    }

    # Puppet access from CG
    ingress {
        from_port = 8140
        to_port = 8140
        protocol = "tcp"
        cidr_blocks = ["${var.cg_network}"]
    }

    # outbound internet access
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

# Create a Puppet Master for Managing Logging Stack in Dev
# Assuming Ubuntu AMIs
resource "aws_instance" "logstack-puppet" {
  # How to communicate with provisioner
  connection {
    user = "ubuntu"
    key_file = "${var.key_path}"
  }

  instance_type = "t2.micro"
  ami = "${lookup(var.aws_amis_ubuntu, var.aws_region)}"
  key_name = "${var.key_name}"
  security_groups =["${aws_security_group.default.name}"]

  # Provision box to be puppet master
  provisioner "file" {
      source = "./puppetmaster-bootstrap.sh"
      destination = "/tmp/puppetmaster-bootstrap.sh"
  }

  provisioner "remote-exec" {
      inline = [
        "sudo chmod +x /tmp/puppetmaster-bootstrap.sh",
        "sudo /tmp/puppetmaster-bootstrap.sh"
      ]
  }
}


