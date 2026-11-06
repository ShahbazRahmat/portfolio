# GitOps workflow — operating manual

How changes move from idea to production in this repository, and what to do when
something goes wrong.

## Change types and paths

| Change | Path | Review |
|---|---|---|
| Platform add-on version bump | `applications/platform/*.yaml` | 1 reviewer + CI green |
| Team workload change | `charts/<app>/` | App team + 1 platform reviewer |
| AppProject rule change | `projects/platform-project.yaml` | 2 platform reviewers (security-sensitive) |
| Root app change | `bootstrap/app-of-apps/` | 2 platform reviewers — this can orphan everything |

## Promotion flow

1. PR opens → CI runs `helm lint` + `kubeconform`. No green, no merge.
2. Merge to `main` → ArgoCD auto-syncs within ~3 minutes.
3. Canary apps advance step-by-step with Prometheus analysis between steps.
4. Any analysis failure → automatic rollback; an ArgoCD notification goes to the
   on-call channel with the sync ID.

## Break-glass (when GitOps itself is broken)

Manual kubectl changes are permitted in a P1 **only** with:

1. A timestamped note in the incident channel stating what was changed and why.
2. The same change committed to Git within 24 hours (`selfHeal: true` will otherwise
   revert it — that revert is a feature, not a bug).
3. The incident RCA links both.

## Drift policy

`selfHeal: true` means the cluster converges to Git on every drift. If someone edits
a live manifest by hand, it reverts within minutes. This is intentional: Git is the
single source of truth, and drift is treated as an incident, not a convenience.
