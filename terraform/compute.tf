resource "aws_launch_template" "frontend" {
  name_prefix   = "${var.project_name}-frontend-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.frontend_instance_type

  key_name = "linux-key"   # ← ADDED

  vpc_security_group_ids = [aws_security_group.compute.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1
yum update -y
amazon-linux-extras enable ansible2
yum install -y ansible git
ansible-pull -U https://github.com/aayudhanve2002-source/front-ansible.git -i localhost, playbook.yml
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-frontend-instance"
      Tier        = "frontend"
      Environment = "dev"
    }
  }

  tags = {
    Name        = "${var.project_name}-frontend-lt"
    Tier        = "frontend"
    Environment = "dev"
  }
}

############################
# FRONTEND AUTO SCALING GROUP
############################
resource "aws_autoscaling_group" "frontend" {
  name                = "${var.project_name}-frontend-asg"
  desired_capacity    = var.frontend_desired_capacity
  max_size            = var.frontend_max_size
  min_size            = var.frontend_min_size
  vpc_zone_identifier = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.frontend.arn]

  tag {
    key                 = "Name"
    value               = "${var.project_name}-frontend-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "frontend"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
}

############################
# BACKEND LAUNCH TEMPLATE
############################
resource "aws_launch_template" "backend" {
  name_prefix   = "${var.project_name}-backend-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.backend_instance_type

  key_name = "linux-key"   # ← ADDED

  vpc_security_group_ids = [aws_security_group.compute.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
set -e
exec > /var/log/user-data.log 2>&1
yum update -y
amazon-linux-extras enable ansible2
yum install -y ansible git
ansible-pull -U https://github.com/aayudhanve2002-source/back-ansible.git -i localhost, playbook.yml
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-backend-instance"
      Tier        = "backend"
      Environment = "dev"
    }
  }

  tags = {
    Name        = "${var.project_name}-backend-lt"
    Tier        = "backend"
    Environment = "dev"
  }
}
############################
# BACKEND AUTO SCALING GROUP
############################
resource "aws_autoscaling_group" "backend" {
  name                = "${var.project_name}-backend-asg"
  desired_capacity    = var.backend_desired_capacity
  max_size            = var.backend_max_size
  min_size            = var.backend_min_size
  vpc_zone_identifier = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-backend-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Tier"
    value               = "backend"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
}