# Design notes — terraform-aws-eks-blueprint

Working notes on the decisions in this repo. Written the way I document them for
client platforms (and the same format I use for ADRs).

## Subnet tagging

EKS discovers load balancers via subnet tags:

- `kubernetes.io/role/elb = 1` on public subnets → internet-facing ALB/NLB
- `kubernetes.io/role/internal-elb = 1` on private subnets → internal LBs
- `kubernetes.io/cluster/<name> = shared` on both

Getting these wrong is the #1 cause of "Service stuck in pending" on fresh clusters,
so they are applied by the network module, not left to the consumer.

## Single NAT vs NAT per AZ

- dev/staging: one shared NAT (`single_nat = true`) — a NAT Gateway is ~$32/month plus
  data processing; three of them for a sandbox is waste.
- prod: one per AZ (`single_nat = false`) — a single-AZ NAT is a blast-radius
  dependency for all three AZs of nodes.

## On-demand + spot node groups

- `core` (ON_DEMAND): tolerates system-critical pods (coredns, ebs-csi, ingress) —
  node affinity can pin them here.
- `spot` (SPOT, 3 instance families): stateless workloads with PDBs and HPA.
  Multiple families materially reduce interruption frequency.

Roadmap: replace spot node groups with Karpenter for bin-packing and faster scale-out.

## IRSA over instance profiles

The ebs-csi add-on runs with an explicit IRSA role scoped to its service account
(`system:serviceaccount:kube-system:ebs-csi-controller-sa`), not with node permissions.
Pattern scales: every workload that needs AWS access gets its own role with a `:sub`
condition — auditable in IAM, revocable without touching nodes.

## API endpoint exposure

Default here is public endpoint + `0.0.0.0/0` for convenience in dev. In production I
restrict `endpoint_public_access_cidrs` to office/VPN ranges — the variable is wired
through to the module for exactly that.

## State management

`versions.tf` ships with a commented S3 backend (bucket, DynamoDB lock table, encryption).
Local state is acceptable for a demo; any real environment moves to remote state on day one.
