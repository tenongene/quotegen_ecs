resource "aws_autoscaling_group" "quotegen_ecs_asg" {

  name                      = "quotegen_ecs_asg"
  max_size                  = 8
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 4
  force_delete              = true

  launch_template  {
    name = aws_launch_template.quotegen-asg-ltemplate.name
  }

  target_group_arns   = [data.aws_lb_target_group.quotegen.arn]

  vpc_zone_identifier = module.vpc.public_subnets



  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "quotegen-asg-ltemplate" {
  name_prefix = "quotegen-asg-ltemplate"
  image_id      = "ami-0b11163bc5cc1a53b"
  instance_type = "t3.small"
  key_name = "quotegen-key"

  user_data = base64encode(<<EOT
#!/bin/bash
echo ECS_CLUSTER=${local.cluster_name} >> /etc/ecs/ecs.config
EOT
  )

  iam_instance_profile {
    arn = "arn:aws:iam::688300040733:instance-profile/ECS-EC2-InstanceProfile"
  }

}





