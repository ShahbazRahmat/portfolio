###############################################################################
# Root module — composes the network and eks modules.
###############################################################################

module "network" {
  source = "./modules/network"

  name         = "${var.cluster_name}-${var.environment}"
  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
  az_count     = var.az_count
  single_nat   = var.environment != "prod" # one NAT per AZ only in prod
}

module "eks" {
  source = "./modules/eks"

  name                                 = "${var.cluster_name}-${var.environment}"
  kubernetes_version                   = var.cluster_version
  private_subnet_ids                   = module.network.private_subnet_ids
  public_subnet_ids                    = module.network.public_subnet_ids
  node_groups                          = var.node_groups
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs

  depends_on = [module.network]
}
