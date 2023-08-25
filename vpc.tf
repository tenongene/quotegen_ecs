module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"


  name = "quotegen-vpc"
  cidr = "10.0.0.0/16"
  public_subnets = [ "10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24" ]
  azs = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  
  default_security_group_name = "quotegen-sg"
  default_security_group_tags = {
    description = "Quotgen app security group"
  }
  default_security_group_ingress = [

  {
		from_port   = 9100
		to_port     = 9101
		protocol    = "tcp"
		cidr_blocks = "0.0.0.0/0"
		description = "Metrics Export"
	},
  {
		from_port   =  80
		to_port     =  80
		protocol    = "tcp"
		security_groups = aws_security_group.quotegen-app-alb-sg.id
		description = "quotegen app access via ALB"
	},
  {
    
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = "107.194.138.115/32"
		description = "quotegen SSH access"
	
  }]

  default_security_group_egress  = [
    {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = "0.0.0.0/0"
	}
  ]
	
  map_public_ip_on_launch = true
}






