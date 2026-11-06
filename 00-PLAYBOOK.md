# GitHub Proof-of-Work Playbook
### For Shahbaz Kareem — Principal Cloud & DevOps Architect
Goal: turn your GitHub profile into verifiable proof of your skills, so Western hiring managers see **evidence, not claims**.

---

## Why this matters (30-second version)

When a hiring manager at a US/EU company reads "14 years, Principal-level, multi-region EKS", their first mental question is:
> *"Can I verify any of this?"*

A CV **claims**. A GitHub repo with green CI, a clean README, and an architecture diagram **proves**. For remote roles especially, your GitHub profile is your second CV — and for many hiring managers, the more trusted one.

You do **not** need to build production software. You need 3 repos that show how you *think and structure* real platform work. This kit contains the full starter content for each repo — you review it, adapt it, and publish it in your own commit rhythm.

---

## The 3 repos and what each one proves

| Repo | Proves | Target audience |
|---|---|---|
| `terraform-aws-eks-blueprint` | IaC maturity: modular Terraform, multi-AZ networking, IRSA, spot+on-demand node groups, CI-governed | DevOps / Cloud Architect / Platform roles |
| `eks-gitops-platform` | GitOps maturity: ArgoCD app-of-apps, AppProject RBAC, Helm charting, **canary deploys with automated rollback** | Platform Engineering / SRE roles |
| `k8s-observability-stack` | SRE maturity: kube-prometheus-stack, **multi-window SLO burn-rate alerting**, runbooks | SRE / Reliability-heavy roles |

All three are included in this kit as ready-to-push folders:
- `01-terraform-aws-eks-blueprint/`
- `02-eks-gitops-platform/`
- `03-k8s-observability-stack/`

---

## Part A — Setup (Day 1, ~1 hour)

### A1. Create / clean up your account
1. Username: **`shahbazkareem`** (or `shahbazrahmat`) — keep it professional and consistent with LinkedIn.
2. Profile photo: same as LinkedIn (a clear, professional headshot).
3. Enable **2FA** (Settings → Password and authentication).
4. Add an SSH key or use `gh` CLI: `https://cli.github.com` → `gh auth login`.
5. Settings → Emails → keep the noreply email enabled if you want privacy:
   ```
   git config --global user.name  "Shahbaz Kareem"
   git config --global user.email "ID+username@users.noreply.github.com"
   ```

### A2. Publish your profile README (from `04-github-profile/README.md`)
1. Create a new public repo named **exactly** `shahbazkareem` (matches your username).
2. Copy the template from `04-github-profile/README.md`, replace the `<...>` placeholders.
3. This renders on your profile home page — it is your landing page.

---

## Part B — The 21-day rollout (critical: do NOT push everything at once)

**Why slow:** a repo where 45 files appear in one commit looks generated. A repo where files appear in a logical build order with clear commit messages looks like **real engineering** — because it is. You are narrating a build.

Commit 1–2 times per day. Use these commit messages (or write your own in the same style):

### Week 1 — Repo 1: terraform-aws-eks-blueprint
| Day | Action | Example commit message |
|---|---|---|
| 1 | Create repo + README skeleton (roadmap) + `.gitignore` | `chore: init repo with README and project roadmap` |
| 2 | Push `versions.tf`, `providers.tf`, `variables.tf` | `feat: define provider constraints and input variables` |
| 3 | Push `modules/network/` (VPC, subnets, NAT) | `feat(network): multi-AZ VPC with public/private subnets` |
| 4 | Push `modules/eks/` (cluster, roles, node groups) | `feat(eks): cluster with on-demand + spot managed node groups` |
| 5 | Push addons + IRSA (OIDC provider, ebs-csi role) | `feat(eks): manage core add-ons and IRSA for ebs-csi-driver` |
| 6 | Push `.github/workflows/ci.yml` — get CI green | `ci: add fmt, validate and tfsec checks` |
| 7 | Polish README (badges, mermaid diagram, quickstart) | `docs: add architecture diagram and quickstart` |

### Week 2 — Repo 2: eks-gitops-platform
| Day | Action | Commit message |
|---|---|---|
| 8 | Repo init + README skeleton | `chore: init gitops platform repo` |
| 9 | `bootstrap/` root-app (app-of-apps) | `feat(bootstrap): argocd root application` |
| 10 | `projects/platform-project.yaml` (RBAC) | `feat(projects): restrict app project sources and destinations` |
| 11 | Platform apps (ingress-nginx, cert-manager, external-secrets) | `feat(platform): deploy ingress, cert-manager and external-secrets via argocd` |
| 12 | `charts/demo-app` skeleton | `feat(charts): demo-app helm chart` |
| 13 | Canary Rollout + AnalysisTemplate | `feat(demo-app): canary rollout with automated success-rate analysis` |
| 14 | CI (helm lint + kubeconform) + docs | `ci: add helm lint and kubeconform validation` |

### Week 3 — Repo 3 + launch
| Day | Action | Commit message |
|---|---|---|
| 15 | Repo 3 init + kube-prometheus-stack values | `feat: kube-prometheus-stack baseline values` |
| 16 | Recording + alert rules | `feat(alerts): multi-window slo burn-rate rules` |
| 17 | Loki stack values | `feat(logging): loki single-binary values for k8s logs` |
| 18 | Runbook `docs/runbook-high-5xx.md` | `docs: runbook for elevated 5xx alert` |
| 19 | SLO worksheet | `docs: slo definition worksheet` |
| 20 | Profile README final polish, repo descriptions + topics | `chore: polish profile` |
| 21 | Pin all 3 repos, update LinkedIn, add GitHub to CV | — |

**After Day 21:** message me — I will update your CV (add the GitHub URL to the header band) and your LinkedIn positioning.

---

## Part C — Making the repos discoverable and credible

1. **Repo descriptions + topics** (Settings → General → Description):
   `terraform-aws-eks-blueprint` → topics: `terraform`, `aws`, `eks`, `kubernetes`, `iac`, `irsa`
2. **Pin repos** on your profile (Customize your pins → the 3 repos).
3. **Licenses:** add MIT license to each repo (GitHub "Add file → Create new file → LICENSE").
4. **Green CI is non-negotiable.** The kit includes GitHub Actions workflows; make sure the badge in each README shows *passing*.
5. **LinkedIn:** add each repo under **Featured** with one line, e.g.:
   *"Multi-AZ EKS blueprint with IRSA, spot node groups and CI-governed Terraform."*
6. **Optional power move:** write one short post per repo on dev.to or LinkedIn (300–500 words: the problem the repo solves + the architecture diagram). One post per week for 3 weeks.

---

## Part D — The interview defense (most important section)

Assume every interviewer has read your repos. Before publishing, **re-write or understand every file in your own words**. Expect these questions:

- "Why a single NAT Gateway in dev?" → *cost control; prod gets one per AZ (documented in README's production-hardening section).*
- "Why IRSA instead of instance profiles?" → *least privilege per workload; see ADR-0002 in `05-written-communication-pack/` — bring that exact reasoning.*
- "Why ON_DEMAND + SPOT mix?" → *stateless workloads on spot for cost, critical system pods tolerate on spot via node affinity + Karpenter roadmap.*
- "Walk me through your canary rollout." → *10% → 30% → 60% → 100%, Prometheus success-rate analysis between steps, auto-rollback on failureLimit.*
- "Why multi-window burn-rate alerts instead of raw error alerts?" → *fewer false pages, catches both fast burns and slow leaks; see the SLO worksheet.*

**Rule: never publish a line you cannot defend.** If something in the kit doesn't match how you'd do it — change it. Your opinion is the value.

---

## Part E — Do / Don't

| Do | Don't |
|---|---|
| Commit in logical build order over 3 weeks | Push everything in one giant commit |
| Write real READMEs (they are 50% of the value) | Leave "TODO" or template text in published files |
| Keep CI green | Force-push after someone has seen it |
| Star repos you genuinely read (CNCF projects) | Buy stars or fake activity — instantly detectable |
| Say "reference implementation" | Claim these run your client's production (confidentiality!) |
| Anonymize everything client-related | Ever copy client Terraform/state/code |

---

## Part F — Maintenance (2 hours/week, forever)

- 1 meaningful commit per week across the 3 repos (dependency bumps count: `chore: bump kubernetes version to 1.31`).
- Answer one issue/discussion in a CNCF repo occasionally — public collaboration history is gold.
- Every time you solve a hard problem at work (sanitized), ask: *"Can this become a public ADR, runbook, or blog post?"* — that pipeline never runs dry.

---

## Related files in this kit

- `04-github-profile/README.md` — your profile landing page
- `05-written-communication-pack/` — RCA example, ADR template + example, async update template, writing guide
- `06-timezone-strategy.md` — exact overlap tables and how to present PKT
