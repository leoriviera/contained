# Create a security group for the ASG
resource "aws_security_group" "scaling_group_sg" {
  vpc_id = var.vpc_id
  description = "Route traffic from the load balancer to VM instances in the ASG"
}

# Allow traffic from the load balancer
resource "aws_security_group_rule" "asg_inbound" {
  security_group_id        = aws_security_group.scaling_group_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.load_balancer_sg.id
  description              = "Allow inbound traffic from the load balancer"
}

# Allow instances in the ALB to communicate with the open internet
resource "aws_security_group_rule" "asg_outbound" {
  security_group_id = aws_security_group.scaling_group_sg.id
  type              = "egress"
  protocol          = "all"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow ASG VM instances to access the open internet"
}

# Define a lanuch template for EC2 instances
resource "aws_launch_template" "launch_template" {
  description            = "A launch template for a contained VM"
  image_id               = tolist(data.aws_ami_ids.amazon_linux.ids)[0]
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.scaling_group_sg.id]
  user_data              = filebase64("${path.module}/user-data.sh")
  update_default_version = true
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      iops                  = 2500
      delete_on_termination = true
      throughput            = 150
    }
  }
}

# Create an auto-scaling group for the instances
resource "aws_autoscaling_group" "contained_asg" {
  min_size            = 1
  max_size            = 1
  # vpc_zone_identifier = [for id in data.aws_subnets.subnets.ids : id]
  vpc_zone_identifier = var.vpc_subnets
  target_group_arns   = [aws_lb_target_group.asg_target_group.arn]
  health_check_type   = "ELB"
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}
