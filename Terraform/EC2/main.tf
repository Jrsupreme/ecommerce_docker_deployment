resource "aws_security_group" "bastion_host_sg" { # Frontend Security group
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
  tags = {
    "name"       : "wl6_front_sg"  
    "terraform"  : "true"
  }
}

resource "aws_security_group" "app_sg" { # Backend security group
  description = "SSH & DJANGO"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    "Name"      : "wl6_back_sg"                         
    "Terraform" : "true"                                
  }
   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }
  
}
resource "aws_instance" "app_server1" {    # Backend Server 1
  ami               = "ami-0866a3c8686eaeeba"                
                                        
  instance_type     = var.instance_type                 
  vpc_security_group_ids = [aws_security_group.app_sg.id]    
  key_name          = "wl6"                
  tags = {
    "Name" : "app1"         
  }
  subnet_id = var.private_subnet_id_1
}

resource "aws_instance" "app_server2" {    # Backend Server 2
  ami               = "ami-0866a3c8686eaeeba"                
                                        
  instance_type     = var.instance_type                 
  vpc_security_group_ids = [aws_security_group.app_sg.id]    
  key_name          = "wl6"                
  tags = {
    "Name" : "app2"         
  }
  subnet_id = var.private_subnet_id_2

}

resource "aws_instance" "bastion_host1" {    # Frontend Server 1
  ami               = "ami-0866a3c8686eaeeba"                
                                        
  instance_type     = var.instance_type                 
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]    
  key_name          = "wl6"                
  tags = {
    "Name" : "bastion_host1"         
  }
  subnet_id = var.public_subnet_id_1

}


resource "aws_instance" "bastion_host2" {    # Frontend Server 2
  ami               = "ami-0866a3c8686eaeeba"                
                                        
  instance_type     = var.instance_type                 
  vpc_security_group_ids = [aws_security_group.bastion_host_sg.id]    
  key_name          = "wl6"                
  tags = {
    "Name" : "bastion_host2"         
  }
  subnet_id = var.public_subnet_id_2
}