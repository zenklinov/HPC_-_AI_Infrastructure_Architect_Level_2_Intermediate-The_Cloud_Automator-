# Data Source for Ubuntu 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Generate SSH Key
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${path.module}/private_key.pem"
  content         = tls_private_key.pk.private_key_pem
  file_permission = "0400"
}

# Security Group
resource "aws_security_group" "sg" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and API traffic"

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
    from_port   = 8000 # App Port
    to_port     = 8000
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

# EC2 Instance
resource "aws_instance" "ai_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.kp.key_name
  vpc_security_group_ids = [aws_security_group.sg.id]

  # Root volume size for Docker images
  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "${var.project_name}"
  }

  # Connection for provisioners
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.pk.private_key_pem
    host        = self.public_ip
  }

  # Copy App Code
  provisioner "file" {
    source      = "../app"
    destination = "/home/ubuntu/app"
  }

  # Copy Ansible Code
  provisioner "file" {
    source      = "../ansible"
    destination = "/home/ubuntu/ansible"
  }

  # Execute Ansible
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get install -y ansible",
      "cd /home/ubuntu/ansible",
      "ansible-playbook playbook.yml"
    ]
  }
}
