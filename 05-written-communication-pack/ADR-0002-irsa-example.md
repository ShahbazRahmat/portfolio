# ADR-0002: Use IRSA instead of node instance profiles for in-cluster AWS access

> **How to use:** this is a filled example of the template — publish one like it in
> `terraform-aws-eks-blueprint/docs/adr/`. It maps directly to the IRSA code already
> in the repo, so interviewer and repo tell the same story.

---

# ADR-0002: Use IRSA instead of node instance profiles for in-cluster AWS access

**Date:** 2025-10-20
**Status:** Accepted
**Deciders:** S. Kareem (Platform), with security review from the cloud security team

## Context

Workloads and add-ons on our EKS clusters need AWS permissions: the EBS CSI driver
manages volumes, ingestion jobs read from S3, controllers assume cross-account roles.
The legacy pattern — attach broad IAM policies to the **node** role — means every pod
on that node inherits those permissions, regardless of need. On multi-tenant clusters
(banking clients, PCI-DSS scope) that fails least-privilege review and makes audit
attribution ("who touched this bucket?") nearly impossible.

## Decision

**We will grant AWS permissions per Kubernetes service account using IRSA
(IAM Roles for Service Accounts)**, with a `StringEquals :sub` condition binding each
IAM role to exactly one service account. Node instance profiles keep only the
EKS-required baseline policies.

## Alternatives considered

| Option | Pros | Cons | Why not |
|---|---|---|---|
| **IRSA (chosen)** | Least privilege per workload; auditable in IAM; no node restarts to change permissions | OIDC provider per cluster; role-per-workload sprawl needs naming discipline | — |
| Node instance profiles | Zero setup; simplest mental model | Every pod inherits node rights; one leak = everything leaked; fails PCI scoping | Contradicts least-privilege requirement |
| EKS Pod Identity (2023+) | No OIDC provider needed; nicer UX | Newer; not yet on all client AWS Organizations' approved patterns list | Re-evaluate at next platform review (set below) |

## Consequences

**Positive:** IAM access review maps 1:1 to service accounts; revoking a workload's
AWS access needs no node touch; security teams can diff `:sub` conditions in PRs.

**Negative:** ~1 IAM role per AWS-needing workload (we manage via the IaC module);
each new cluster must create its OIDC provider (handled by the `eks` module).

**Follow-ups:** naming convention doc `sa-<namespace>-<workload>`; audit script that
lists IRSA roles with no matching service account (drift detection).

## Review trigger

When EKS Pod Identity is approved in client security baselines, or at the next
platform-wide security review — whichever comes first.
