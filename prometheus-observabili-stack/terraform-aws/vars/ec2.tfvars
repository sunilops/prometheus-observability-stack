# EC2 Instance Variables
region         = "us-east-1"
ami_id         = "ami-0d6706b99f85f1a04"
instance_type  = "t3.micro"
key_name       = "prometheus-stack-key"
instance_count = 1
volume_size    = 20

vpc_id     = "vpc-0b5e19a31fdebcca5"
subnet_ids = ["subnet-095117cc876569470"]  

name        = "prometheus-stack"
owner       = "sunil"
environment = "dev"
cost_center = "personal-projects"
application = "monitoring"
