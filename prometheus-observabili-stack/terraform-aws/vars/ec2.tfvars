# EC2 Instance Variables
region         = "us-east-1"
ami_id         = "ami-xxxxxxxxxxxxxxxx"   3replace wit your own ami ID
instance_type  = "t3.micro"
key_name       = "prometheus-stack-key"
instance_count = 1
volume_size    = 20

vpc_id     = "vpc-xxxxxxxxxxxxxxxxx"       # replace with your own VPC ID
subnet_ids = ["subnet-xxxxxxxxxxxxxxxxx"]  # replace with your own subnet ID 

name        = "prometheus-stack"
owner       = "sunil"
environment = "dev"
cost_center = "personal-projects"
application = "monitoring"
