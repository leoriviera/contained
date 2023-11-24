# locals {
#   availability_zone_subnets = {
#     for s in data.aws_subnet.available : s.availability_zone => s.id...
#   }
# }

# Create a security group for the load balancer
resource "aws_security_group" "load_balancer_sg" {
  vpc_id = var.vpc_id
  description = "Route traffic from the internet to the ASG"
}

# Accept traffic from the open internet
resource "aws_security_group_rule" "load_balancer_inbound" {
  security_group_id = aws_security_group.load_balancer_sg.id
  type              = "ingress"
  protocol          = "all"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all inbound traffic from the internet"
}

# Forward traffic to the load balancer scaling group
resource "aws_security_group_rule" "load_balancer_outbound" {
  security_group_id        = aws_security_group.load_balancer_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.scaling_group_sg.id
  description              = "Send outbound traffic to the contained ASG"
}

# Create an application load balancer
resource "aws_lb" "load_balancer" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  # TODO - create subnets from scratch
  # This makes the assumption all the subnets in the default VPC
  # are public. This is a little dangerous, especially for accounts
  # with multiple projects. The best way to work around this is to
  # create a new VPC for this project, and set up the relevant
  # subnets and networking
  # subnets = [for subnet_ids in local.availability_zone_subnets : sort(subnet_ids)[0]]
  subnets = var.vpc_subnets
}

# Create a target group for the ALB
resource "aws_lb_target_group" "asg_target_group" {
  vpc_id   = var.vpc_id
  port     = 3000
  protocol = "HTTP"
}

# Perform an HTTPS redirect
resource "aws_lb_listener" "https_redirect" {
  # TODO - Generate certificates using Terraform
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Forward HTTPS traffic to the ASG
resource "aws_lb_listener" "asg_forward" {
  certificate_arn   = var.certificate_arn
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 443
  protocol          = "HTTPS"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_target_group.arn
  }
}

# Create a record to point the server subdomain at the load balancer
resource "aws_route53_record" "server" {
  zone_id = var.hosted_zone_id
  name    = "${var.domain}."
  type    = "A"

  alias {
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
    evaluate_target_health = true
  }
}
