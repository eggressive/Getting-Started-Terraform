# aws_lb
resource "aws_lb" "nginx" {
  name               = "globo-web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}

# aws_lb_target_group

# aws_lb_listener

# aws_lb_target_group_attachment
