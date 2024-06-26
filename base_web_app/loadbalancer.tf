# aws_elb_service_account
data "aws_elb_service_account" "root" {}

# aws_elb_service_account
data "aws_elb_service_account" "root" {}

# aws_lb
resource "aws_lb" "nginx" {
  name               = "${local.naming_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets[*].id
  depends_on         = [aws_s3_bucket_policy.web_bucket]

  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.bucket.bucket
    prefix  = "alb-logs"
    enabled = true
  }

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-alb" })
}

# aws_lb_target_group
resource "aws_lb_target_group" "nginx_tg" {
  name     = "${local.naming_prefix}-nginx-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app.id

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-nginx-alb-tg" })
}

# aws_lb_listener
resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }

  tags = merge(local.common_tags, { Name = "${local.naming_prefix}-nginx-lb-listener" })
}

# aws_lb_target_group_attachment
resource "aws_lb_target_group_attachment" "nginx" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.nginx_tg.arn
  target_id        = aws_instance.nginx_instance[count.index].id
  port             = 80
}
