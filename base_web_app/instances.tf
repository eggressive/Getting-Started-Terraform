##################################################################################
# DATA
##################################################################################

data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

##################################################################################
# INSTANCES #
##################################################################################
resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = "ec2_keypair"
  public_key = tls_private_key.tls_key.public_key_openssh
}

resource "local_file" "private_key" {
  content              = tls_private_key.tls_key.private_key_pem
  filename             = "${path.module}/private_key.pem"
  directory_permission = "0755"
  file_permission      = "0600"
}

resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  key_name               = aws_key_pair.ec2_keypair.key_name

  user_data = <<EOF
#! /bin/bash
sudo dnf install -y nginx
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server 1</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF

  tags = local.common_tags
}

resource "aws_instance" "nginx2" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  key_name               = aws_key_pair.ec2_keypair.key_name

  user_data = <<EOF
#! /bin/bash
sudo dnf install -y nginx
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server 2</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF

  tags = local.common_tags
}