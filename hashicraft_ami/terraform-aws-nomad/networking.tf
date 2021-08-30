
# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A VPC USING THE VPC MODULE
# ---------------------------------------------------------------------------------------------------------------------

module "vpc-west" {
  source = "terraform-aws-modules/vpc/aws"

  providers = {
    aws = aws.west
  }

  name = "hashicraft-vpc-west"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = ["10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
