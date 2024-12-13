resource "tls_private_key" "oei-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "oei-key-pair" {
  key_name   = var.key-pair
  public_key = tls_private_key.oei-key.public_key_openssh
}

resource "aws_instance" "linux_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key-pair
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  user_data              = var.ec2_user_data
  tags = {
    Name = var.instance-name
  }
}

resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Allow SSH access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name = "EC2-Security-Group"
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.oei-key.private_key_pem
  filename        = "private.pem"
  file_permission = "0400"
}

resource "null_resource" "name" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.oei-key.private_key_pem
    host        = aws_instance.linux_server.public_ip
  }

  provisioner "file" {
    source      = "./docker_files/Dockerfile"
    destination = "/home/ec2-user/Dockerfile"
  }

  provisioner "file" {
    source      = "./docker_files/app.py"
    destination = "/home/ec2-user/app.py"
  }


  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/Dockerfile",
      "sudo chmod +x /home/ec2-user/app.py",
      "sudo yum -y update",
      "sudo yum -y install docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu",
      "sudo docker build -t python-app .",
      "sudo docker run -d -p 8080:8080 python-app"
    ]
  }

  # wait for ec2 to be created
  depends_on = [aws_instance.linux_server]
}

output "container_url" {
  value = join("", ["http://", aws_instance.linux_server.public_dns, ":8080"])
}
