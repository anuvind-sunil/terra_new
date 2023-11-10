resource "aws_security_group" "anuvind-test_nat_instance_sg" {
  name        = "anuvind-test-anuvind_nat-instance-sg"
  description = "test-Security group for NAT instance"   
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "eks_terra_nat_inst" {
  ami           = "ami-078c1149d8ad719a7"
  instance_type = "t2.micro"
  subnet_id = var.subnet_id
  key_name = "anuvind_key_1"
  vpc_security_group_ids = [aws_security_group.anuvind-test_nat_instance_sg.id] 
  tags = {
    "Name" = "anuvind_nat_test_inst_inPrivate"
  }
  
  user_data = file("${path.module}/script.sh")
  depends_on = [
    var.dependency_db_ins
  ]
}

