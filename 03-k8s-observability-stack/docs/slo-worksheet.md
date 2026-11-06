# SLO Worksheet — Availability

How the targets in `alerts/` were derived. Fill one of these per user-facing service;
do not copy numbers blindly — the budget must reflect what the business actually loses.

## 1. The service

| Field | Value |
|---|---|
| Service | `<service>` (example: checkout API) |
| Users | Authenticated customers, ~`<X>` req/s peak |
| SLI | `(non-5xx responses) / (total responses)` from `http_requests_total` |

## 2. Choosing the target

| Target | Budget / 30 days | Fits when |
|---|---|---|
| 99% | 7.2 h | Internal tools |
| **99.9%** | **43.2 min** | Customer-facing API — **chosen** |
| 99.95% | 21.6 min | Payment path only |
| 99.99% | 4.3 min | Core banking ledger (banking clients) |

**Chosen: 99.9%** — 43.2 minutes of error budget per 30-day window. Tight enough to
matter, loose enough that a single bad deploy doesn't nuke the quarter.

## 3. Burn-rate alert thresholds (standard multiwindow)

| Window pair | Threshold | Time to exhaust budget | Action |
|---|---|---|---|
| 1 h + 5 m | 14.4x | ~2 days → but seen in minutes | Page immediately |
| 6 h + 30 m | 6x | ~7 days | Page (secondary) |
| 6 h alone | 1x | ~30 days | Ticket — above schedule |

## 4. Review cadence

- **Monthly:** did we keep the budget? If > 50% burned by week 2 → freeze risky deploys.
- **Quarterly:** is 99.9% still the right number? Raise it only when two consecutive
  quarters stayed green with > 30% budget left (otherwise you're just paying to page yourself).

## 5. Common mistakes this worksheet avoids

- Setting 99.99% because it looks good in a demo → constant paging → alert fatigue → real pages ignored.
- Measuring SLI from the load balancer only → misses in-cluster failures between services.
- No error budget → no rational deploy freeze policy → every outage is a surprise argument.
