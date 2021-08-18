# Create BIG-IP launch template
resource "aws_launch_template" "bigip-lt" {
  name          = format("%s-bigip-lt-%s", var.projectPrefix, random_id.buildSuffix.hex)
  image_id      = data.aws_ami.f5_ami.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.bigip.key_name
  user_data     = base64encode(local.f5_onboard)

  network_interfaces {
    device_index                = 0
    description                 = "eth0"
    delete_on_termination       = true
    security_groups             = [module.external-security-group.security_group_id]
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name  = "${var.projectPrefix}-bigip-lt-${random_id.buildSuffix.hex}"
      Owner = var.resourceOwner
    }
  }
}

# Create BIG-IP autoscaling group
resource "aws_autoscaling_group" "bigip-asg" {
  name                = format("%s-bigip-asg-%s", var.projectPrefix, random_id.buildSuffix.hex)
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  health_check_type   = "EC2"
  vpc_zone_identifier = [var.extSubnetAz1, var.extSubnetAz2]
  target_group_arns   = var.nlb_target_group_arns

  launch_template {
    id      = aws_launch_template.bigip-lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    # preferences {
    #   min_healthy_percentage = 50
    # }
    # triggers = ["tag"]
  }

  tag {
    key                 = "Name"
    value               = "${var.projectPrefix}-bigip-${random_id.buildSuffix.hex}"
    propagate_at_launch = true
  }
  tag {
    key                 = "Owner"
    value               = var.resourceOwner
    propagate_at_launch = true
  }
}