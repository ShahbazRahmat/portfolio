# Async Writing Guide — How Remote Teams Judge Your Written Communication

Interviewers for remote roles cannot see how you code in week one — but they can see
how you write from the first email. This guide is the checklist I use (and what I look
for when hiring).

## 1. BLUF — Bottom Line Up Front

State the conclusion in the first sentence. Details after. Never build suspense.

❌ *"Hi team, I was looking at the cluster this morning and noticed some pods
restarting, so I dug into the logs and checked the events, and it looks like..."*

✅ *"Prod is stable, no action needed — root cause was a bad helm values merge; RCA
by Friday. Details below for those interested."*

## 2. Every message answers: what, so what, what now

| Element | One line that does the job |
|---|---|
| What | "Canary for checkout stuck at 30%." |
| So what | "Release train delayed ~2h; no customer impact." |
| What now | "Rolling back now; will post RCA draft in #releases by 17:00 UTC." |

## 3. Timezone discipline (your differentiator)

- Always write **both** timezones: *"Sync at 14:00 UTC (19:00 PKT)."*
- End your day with a written handoff — your 17:00 PKT note is the EU/US person's
  morning briefing. See the template in `weekly-async-update-template.md`.
- Commit messages and PR descriptions never reference local-only times.

## 4. PR and code review writing (where engineers are judged most)

- PR description: **what** changed, **why**, **how to test** — 3 short sections, every time.
- Review comments: ask about behaviour, not style. ❌ "Why didn't you use X?" ✅
  "What happens here if the two replicas land on the same node? I hit that in
  <linked incident> — a required anti-affinity would cover it."
- Disagree in writing, commit to the decision. The written record is the team's memory.

## 5. Meetings in async teams

- Agenda or no meeting. Document or it didn't happen.
- Your camera-on intro, then let the doc carry the detail.
- After: decisions + owners + dates in the channel within 2 hours. If you're the note
  taker every time without rotating, that's a career growth signal to fix, not a compliment.

## 6. The artifact ladder (publish one rung per month)

1. **README** that a stranger can follow → you communicate clearly
2. **Runbook** that an on-call stranger can follow at 3 AM → you communicate under pressure
3. **ADR** that a skeptical reviewer accepts → you communicate reasoning
4. **RCA** that names no villains and changes the system → you communicate leadership

All four live in this kit. Each one is interview evidence: "How do you communicate as
a remote engineer?" → *"Here are four artifacts where I do exactly that."*
