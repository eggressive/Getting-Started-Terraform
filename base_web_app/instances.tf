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
  key_name   = "${local.naming_prefix}-ec2_keypair"
  public_key = tls_private_key.tls_key.public_key_openssh
}

resource "local_file" "private_key" {
  content              = tls_private_key.tls_key.private_key_pem
  filename             = "${path.module}/private_key.pem"
  directory_permission = "0755"
  file_permission      = "0600"
}

resource "aws_instance" "nginx_instance" {
  count                  = var.instance_count
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
  subnet_id              = module.app.public_subnets[count.index]
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  key_name               = aws_key_pair.ec2_keypair.key_name
  iam_instance_profile   = aws_iam_instance_profile.nginx_profile.name
  depends_on             = [aws_iam_role_policy.allow_s3_all]

  user_data = templatefile("${path.module}/templates/startup_script.tpl", {
    s3_bucket_name = aws_s3_bucket.bucket.id
  })

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-nginx-${count.index}" })
}

# S3 access for instances
resource "aws_iam_role" "allow_nginx_s3" {
  name = "${local.naming_prefix}-allow-nginx-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-allow-nginx-s3-role" })
}

resource "aws_iam_role_policy" "allow_s3_all" {
  name = "${local.naming_prefix}-allow-s3-all-policy"
  role = aws_iam_role.allow_nginx_s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "arn:aws:s3:::${local.s3_bucket_name}",
          "arn:aws:s3:::${local.s3_bucket_name}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_instance_profile" "nginx_profile" {
  name = "${local.naming_prefix}-nginx-profile"
  role = aws_iam_role.allow_nginx_s3.name

  tags = local.common_tags
}