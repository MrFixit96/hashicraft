// # ---------------------------------------------------------------------------------------------------------------------
// # CREATE AN HVN AND HCP VAULT CLUSTER
// # ---------------------------------------------------------------------------------------------------------------------

// resource "hcp_hvn" "vault_hvn" {
//   hvn_id         = var.hvn_id
//   cloud_provider = var.cloud_provider
//   region         = var.region
//   cidr_block     = "172.25.16.0/20"
// }

// # ---------------------------------------------------------------------------------------------------------------------
// # There is no current use for vault in this workflow, planned usaged might be using dynamic database secrets to allow 
// # the Minecraft server to connect to a database.
// # ---------------------------------------------------------------------------------------------------------------------

// resource "hcp_vault_cluster" "hcp_vault" {
//   hvn_id     = hcp_hvn.vault_hvn.hvn_id
//   cluster_id = var.cluster_id
//   public_endpoint = true
//   tier = "dev"
// }

// # ---------------------------------------------------------------------------------------------------------------------
// # This admin token will be used with the Vault provider to manage Vault configuration.
// # ---------------------------------------------------------------------------------------------------------------------

// resource "hcp_vault_cluster_admin_token" "token" {
//   cluster_id = var.cluster_id
// }

// # ---------------------------------------------------------------------------------------------------------------------
// # CREATE VPC PEERING BETWEEN HVN AND AWS
// # ---------------------------------------------------------------------------------------------------------------------

// data "aws_vpc" "peer" {
//   id = module.vpc-west.vpc_id
// }

// data "aws_arn" "peer" {
//   arn = data.aws_vpc.peer.arn
// }

// resource "hcp_aws_network_peering" "peer" {
//   hvn_id              = hcp_hvn.vault_hvn.hvn_id
//   peering_id          = var.peering_id
//   peer_vpc_id         = data.aws_vpc.peer.id
//   peer_account_id     = data.aws_vpc.peer.owner_id
//   peer_vpc_region     = var.region
// }

// resource "hcp_hvn_route" "peer_route" {
//   hvn_link         = hcp_hvn.vault_hvn.self_link
//   hvn_route_id     = var.route_id
//   destination_cidr = data.aws_vpc.peer.cidr_block
//   target_link      = hcp_aws_network_peering.peer.self_link
// }

// resource "aws_vpc_peering_connection_accepter" "peer" {
//   vpc_peering_connection_id = hcp_aws_network_peering.peer.provider_peering_id
//   auto_accept               = true
// }