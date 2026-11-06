# SAMPLE RCA — Blameless Postmortem
> **How to use:** this is a sample written to the exact standard remote-first teams
> expect. Replace the details with one of YOUR real incidents (sanitized — no client
> names, no confidential data) and publish it in a repo's `docs/` folder. It doubles
> as interview material: "Tell me about a hard incident" → link this.
>
> **Golden rule of blameless writing:** describe what the *system* allowed, not who
> "caused". Every human action is framed as something the system made reasonable.

---

# RCA-2025-041: coredns packet drops during node-group rolling upgrade

**Status:** Closed · **Severity:** SEV-2 · **Impact window:** 2025-10-14 14:12–14:38 PKT (26 min)
**Services affected:** DNS resolution cluster-wide; intermittent 5xx on 3 internal APIs
**Author:** S. Kareem · **Reviewers:** Platform team

## 1. Summary

During a routine managed node-group upgrade on a non-production EKS cluster, DNS
resolution degraded for ~26 minutes. The cluster had 2 coredns replicas but both were
temporarily scheduled onto the same node being recycled. Parent-namespace workloads
experienced intermittent NXDOMAIN during the drain window. Customer impact was
contained to an internal environment; the same pattern in production would have been
a SEV-1.

## 2. Timeline (PKT)

| Time | Event |
|---|---|
| 14:05 | Node-group upgrade started (planned, max_unavailable=1) |
| 14:12 | Node `ip-10-0-41-87` draining — both coredns pods co-located on it |
| 14:14 | First NXDOMAIN alerts from app health checks |
| 14:19 | On-call identified DNS as the layer (not app code) |
| 14:22 | Cordon removed for new node; coredns pods began rescheduling |
| 14:30 | Cluster Proportional Autoscaler raised coredns desired count to 4 |
| 14:38 | NXDOMAIN rate at zero — incident closed |

## 3. Impact

- ~26 minutes degraded DNS on one non-prod cluster
- 3 internal APIs intermittently failing (5xx spikes to 4.1%)
- No customer-facing impact (non-prod environment)

## 4. Root cause

The coredns add-on's default anti-affinity allowed replicas to co-locate on one node.
`max_unavailable=1` protected the node count, but nothing protected **DNS capacity**
during the drain — a classic case of the topology-aware scheduling assumption
("replicas spread out") silently not holding.

**Five whys:** upgrades drained a node → both coredns pods were on it → pod
anti-affinity wasn't enforced (soft `preferredDuringScheduling`) → the add-on default
was never reviewed against our HA requirements → HA requirements for platform add-ons
were never written down.

## 5. What went well / what didn't

**Well:** detection in 2 min via app health alerts; on-call diagnosis path (app →
network → DNS) took 5 min; blast radius contained by environment separation.

**Didn't:** our own upgrade runbook didn't list "check critical add-on topology before
draining"; coredns replica count was still the add-on default, not sized to the cluster.

## 6. Action items

| # | Action | Owner | Due | Status |
|---|---|---|---|---|
| 1 | Pin coredns pods with `requiredDuringScheduling` anti-affinity across AZs | S.K. | 2025-10-21 | Done |
| 2 | Cluster-proportional autoscaling for coredns (min 4 replicas) | S.K. | 2025-10-21 | Done |
| 3 | Add "critical add-on topology check" to node-upgrade runbook | M.R. | 2025-10-24 | Done |
| 4 | Write the platform add-on HA requirements doc (feeds item 3) | Platform team | 2025-11-07 | In progress |
| 5 | PDB for coredns (`minAvailable: 2`) | S.K. | 2025-10-21 | Done |

## 7. Lessons

Blameless framing, kept for the record:

- The engineer who ran the upgrade followed our runbook exactly. The system lacked a
  guardrail, and this incident is how we learned where the guardrail goes.
- "Default add-on settings" are someone else's opinion about your cluster. Review them
  like you'd review any dependency.
