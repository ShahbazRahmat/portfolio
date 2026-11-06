# Runbook — High 5xx Error Rate / SLO Burn-Rate Page

> **Applies to:** `SLOBurnRateFast`, `SLOBurnRateSustained`, `High5xxErrorRate`
> **Owner:** Platform team · **Last reviewed:** 2025-11
> **Severity shortcut:** if SLO burn is 14.4x and customer-impacting → treat as P1 immediately.

## 1. What this means

The service is returning 5xx at a rate that will consume the availability error budget
fast (or already has). Users are seeing failures **right now** — this is not a drill
even if the burn rate later normalises.

## 2. First 5 minutes (in order — do not skip ahead)

```bash
# 1. Confirm the blast radius — which service/namespace is the source?
kubectl top pods -A | sort -k3 -rn | head
kubectl get pods -A --field-selector=status.phase=Failed | head

# 2. Check the most common culprit first: a recent change
argocd app list                    # anything syncing/degraded in the last 30 min?
argocd app history demo-app        # was a canary mid-flight?

# 3. Is it load or errors?
kubectl -n demo logs deploy/demo-app --tail=200 | grep -c " 5[0-9][0-9] "

# 4. Node pressure?
kubectl get nodes | grep -v Ready
kubectl describe node <node> | grep -A5 Events
```

## 3. Decision tree

| Finding | Action |
|---|---|
| Canary rollout in flight + errors started with it | `kubectl argo rollouts abort demo-app -n demo` — analysis should auto-rollback; verify traffic back on stable |
| OOMKill / restart storm | `kubectl describe pod <p>` → check last state; scale down the change, keep the RCA for later |
| 5xx from upstream dependency (DB, API) | Check dependency dashboards first; if the dependency team is another TZ, post the handoff note (template below) |
| Node not Ready | Cordon + drain; let the cluster reschedule; open infra ticket after |
| No visible cause, errors continue > 15 min | Escalate: page secondary on-call; open a war-room channel with the incident commander |

## 4. If you must hand off (timezone boundary)

Post in the incident channel **before** you go offline:

```
HANDOFF [17:00 PKT / 13:00 UTC]
- Impact: 5xx at 2.3% on checkout API since 16:20 PKT
- Done: canary aborted, errors dropped to 0.8%, not yet normal
- Next owner: check Redis connection pool saturation (grafana panel "checkout-infra")
- Do NOT: restart the message brokers — suspected to worsen the leak (see 16:45 comment)
- Link: incident channel #inc-2025-1114, Prometheus graph <link>
```

## 5. After it's over

- Freeze deploys until RCA is published (24 h target).
- Write the RCA using the blameless template (`05-written-communication-pack/RCA-...`).
- Every action item gets an owner and a date, or it doesn't go in the doc.

## 6. Related dashboards

- SLO overview: Grafana → folder `SLO` → `availability-burn-rate`
- Golden signals: Grafana → `golden-signals/<service>`
- Logs: Grafana → Loki → `{namespace="demo"} |= "error" | json`
