# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE SERVER NODES
# ---------------------------------------------------------------------------------------------------------------------

module "servers" {
  source = "github.com/hashicorp/terraform-aws-consul//modules/consul-cluster?ref=v0.8.0"

  cluster_name  = "${var.cluster_name}-server"
  cluster_size  = var.num_servers
  instance_type = var.server_instance_type

  cluster_tag_key   = var.cluster_tag_key
  cluster_tag_value = var.cluster_tag_value

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_server.rendered

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids

  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = var.ssh_key_name

  tags = [
    {
      key                 = "Environment"
      value               = "development"
      propagate_at_launch = true
    },
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH SECURITY GROUP RULES FOR NOMAD
# ---------------------------------------------------------------------------------------------------------------------

module "nomad_security_group_rules" {

  source = "./modules/nomad-security-group-rules"

  security_group_id = module.servers.security_group_id

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
}

# ---------------------------------------------------------------------------------------------------------------------
# THE USER DATA SCRIPT THAT WILL RUN ON EACH SERVER NODE WHEN IT'S BOOTING
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "user_data_server" {
  template = file("${path.module}/examples/root-example/user-data-server.sh")

  vars = {
    cluster_tag_key   = var.cluster_tag_key
    cluster_tag_value = var.cluster_tag_value
    num_servers       = var.num_servers
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE CLIENT NODES
# ---------------------------------------------------------------------------------------------------------------------

module "clients" {
  source = "./modules/nomad-cluster"

  cluster_name  = "${var.cluster_name}-client"
  instance_type = var.instance_type

  cluster_tag_key   = "nomad-clients"
  cluster_tag_value = var.cluster_name

  min_size = var.num_clients

  max_size         = var.num_clients
  desired_capacity = var.num_clients

  ami_id    = var.ami_id
  user_data = data.template_file.user_data_client.rendered

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnet_ids.default.ids

  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]

  allowed_inbound_cidr_blocks = ["0.0.0.0/0"]
  ssh_key_name                = var.ssh_key_name

  tags = [
    {
      key                 = "Environment"
      value               = "development"
      propagate_at_launch = true
    }
  ]
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH IAM POLICIES FOR CONSUL
# ---------------------------------------------------------------------------------------------------------------------

module "consul_iam_policies" {
  source = "github.com/hashicorp/terraform-aws-consul//modules/consul-iam-policies?ref=v0.8.0"

  iam_role_id = module.clients.iam_role_id
}

# ---------------------------------------------------------------------------------------------------------------------
# THE USER DATA SCRIPT THAT WILL RUN ON EACH CLIENT NODE WHEN IT'S BOOTING
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "user_data_client" {
  template = file("${path.module}/examples/root-example/user-data-client.sh")

  vars = {
    cluster_tag_key   = var.cluster_tag_key
    cluster_tag_value = var.cluster_tag_value
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE CLUSTER IN THE DEFAULT VPC AND SUBNETS
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "default" {
  id = module.vpc-west.vpc_id
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

