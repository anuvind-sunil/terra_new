resource "aws_instance" "eks_terra_nat_inst" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name = "anuvind_key_1"
  network_interface {
    device_index            = 0
    network_interface_id    = var.network_interface
  }
  user_data = file("${path.module}/script.sh")

  tags = {
    "Name" = var.name
  }
}

