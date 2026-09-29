# terraform-aws

Provisions the AWS infrastructure for the Prometheus observability stack.

- `modules/security-group` — opens the ports the stack needs (22, 9090, 9093, 3000, 9100)
- `modules/ec2` — launches the EC2 instance and bootstraps Docker + Docker Compose via `user-data.sh`
- `prometheus-stack` — root module wiring the two together
- `vars/ec2.tfvars` — your environment-specific values (edit before applying)

## Usage

```bash
cd prometheus-stack
terraform init
terraform plan  --var-file=../vars/ec2.tfvars
terraform apply --var-file=../vars/ec2.tfvars
```

## Before you apply

Edit `vars/ec2.tfvars` and replace:
- `ami_id` — a current Ubuntu AMI for your region (check AWS console → AMI Catalog)
- `key_name` — the name of an EC2 key pair you already own
- `vpc_id` / `subnet_ids` — from your AWS VPC console (default VPC works fine)
- `region` — your preferred AWS region
