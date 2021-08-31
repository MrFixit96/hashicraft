# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY
# AWS_DEFAULT_REGION

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

# None

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "ami_id" {
  description = "The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under examples/nomad-consul-ami/nomad-consul.json. If no AMI is specified, the template will 'just work' by using the example public AMIs. WARNING! Do not use the example AMIs in a production setting!"
  type        = string
  default     = "ami-08a687d784d4d0d57"
}

variable "cluster_name" {
  description = "What to name the cluster and all of its associated resources"
  type        = string
  default     = "nomad-minecraft"
}

variable "server_instance_type" {
  description = "What kind of instance type to use for the nomad servers"
  type        = string
  default     = "t2.micro"
}

variable "instance_type" {
  description = "What kind of instance type to use for the nomad clients"
  type        = string
  default     = "m5.large"
}

variable "num_servers" {
  description = "The number of server nodes to deploy. We strongly recommend using 3 or 5."
  type        = number
  default     = 3
}

variable "num_clients" {
  description = "The number of client nodes to deploy. You can deploy as many as you need to run your jobs."
  type        = number
  default     = 1
}

variable "cluster_tag_key" {
  description = "The tag the EC2 Instances will look for to automatically discover each other and form a cluster."
  type        = string
  default     = "nomad-servers"
}

variable "cluster_tag_value" {
  description = "Add a tag with key var.cluster_tag_key and this value to each Instance in the ASG. This can be used to automatically find other Consul nodes and form a cluster."
  type        = string
  default     = "auto-join"
}

variable "ssh_key_name" {
  description = "The name of an EC2 Key Pair that can be used to SSH to the EC2 Instances in this cluster. Set to an empty string to not associate a Key Pair."
  type        = string
  default     = "hashicraft-nomad"
}

variable "region" {
  description = "Default Region"
  type        = string
  default     = "us-west-2"
}

variable "hvn_id" {
  description = "The ID of the HCP HVN."
  type        = string
  default     = "hashicraft-vault-hvn"
}

variable "cluster_id" {
  description = "The ID of the HCP Vault cluster."
  type        = string
  default     = "hashicraft-vault-cluster"
}

variable "peering_id" {
  description = "The ID of the HCP peering connection."
  type        = string
  default     = "hashicraft-peering"
}

variable "route_id" {
  description = "The ID of the HCP HVN route."
  type        = string
  default     = "hashicraft-hvn-route"
}

variable "cloud_provider" {
  description = "The cloud provider of the HCP HVN and Vault cluster."
  type        = string
  default     = "aws"
}
