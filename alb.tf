module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "quotegen-app-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  create_security_group = false
  security_groups = ["${aws_security_group.quotegen-app-alb-sg.id}"]

  target_groups = [
    {
      name_prefix      = "tgp-"
      backend_protocol = "HTTP"
      backend_port     = 80 
      target_type      = "instance"
  
    }
  ]
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }]

  depends_on = [ module.vpc ]
}

resource "aws_security_group" "quotegen-app-alb-sg" {
  name        = "quotegen-app-nlb-sg"
  description = "Security group for the quotegen app ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow access to quotegen ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_quotegen_alb"
  }
}

data "aws_lb_target_group" "quotegen" {
  arn = "${module.alb.target_group_arns[0]}"
}