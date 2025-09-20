resource "aws_key_pair" "default" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_rsa.pub") # Change this to the path of your public key (usually "~/.ssh/id_rsa.pub" for Linux)
}

resource "aws_instance" "server" {
  ami           = "ami-08982f1c5bf93d976" # The AMI ID for Amazon Linux 2023
  instance_type = "t3.micro"
  key_name      = aws_key_pair.default.key_name

  tags = {
    Name = "ssh-server"
  }

  security_groups = [aws_security_group.ssh-access.name]
}

resource "aws_security_group" "ssh-access" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
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