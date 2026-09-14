# Ortiz Touring Concierge — concept v3

*A 30-minute consult with a travel advisor, in Kat's pocket.*

**v3 change (2026-07-26):** v2's consult was too thin — four questions where Kat's
original had eight for a reason. v3 keeps the concierge voice but restores real depth:
a known-destination fork up front, "who's going" moved to the second question (it
reframes everything — romantic getaway vs. family vacation), and the plan step now
argues its recommendations from Kat's actual data (loyalty tier, budget guardrail)
instead of just presenting a clean answer. Architecture stays a deterministic question
tree + one grounded Claude call for synthesis — not literal agents; see "Why not
agents" below.

## Who it's for and what it does

This is **Kat's app**. Its one job: **remove decision barriers** around travel choices.
She brings loose ideas ("somewhere warm in February" is a complete answer) to someone
very knowledgeable, and ends up with a relevant, organized, timely plan on budget.

Confidence, for this app, means two things (Chris, 2026-07-26):
1. **Reminders** — nothing slips; the right item surfaces at the right moment.
2. **Itinerary quality** — the app brings her important things about the trip, local
   events, and anything that sharpens planning and decision-making.

## The inversion from v1 (Map Room — rejected)

v1 was a dashboard with a question card on it. v2 is **question-led**: the conversation
is the app, and the data lives in the back office.

Two surfaces only:

### 1. The Front Desk (home)
The concierge speaks first, in first person, a few cards at a time — never a wall of
status. Three kinds of cards, in priority order:
- **Reminders**: "Your booking window opens Saturday at midnight — shall we set your
  priorities tonight? Five minutes." Every reminder arrives with the action attached.
- **Finds**: "The week you're in Juneau, the Sealaska Heritage celebration is on —
  worth an afternoon. Pencil it in?" (Claude-powered when a key is set; curated
  playbook content when not.)
- **Money notes**: "Final payment comes due Aug 16 — on plan, nothing needed from you."
  Budget is woven into the conversation, not a ledger tab.

Every card ends in a choice, and every choice includes a no-pressure path
("Remind me Friday", "Skip it", "Advise me"). That's the decision-barrier work.

### 2. The Binder (back office)
One quiet tab holding what the concierge keeps: trips and their plans, budget lines,
family details (ages, passports, loyalty tiers, notes). Look when you want; never
required.

### The Consult (flow, not a tab)
"Book a consult" starts a new trip. It's Kat's original wizard reborn as a
conversation: one question per screen, warm advisor voice, and **every single question
has an "I'm not sure — that's what I'm for" option** that turns the question into a
recommendation. Loose answers are first-class.

**Question order (v3):**

1. **Do you already know where you're going?** The fork v2 was missing. *Yes* reveals
   a destination field inline and skips straight past idea-generation. *No* moves into
   shaping the idea.
   - *(No path only)* **What kind of trip is this reaching for?** — shape, not vibe:
     weekend getaway (short, close, quick-turn), a city (new place, could be leisure
     or work), a cruise or theme park (destination-type — carries its own booking-window
     rules), the big bucket-list swing, or advise-me. Kept separate from purpose because
     "city" and "destination" collide when a single list tries to hold both — see below.
2. **Who's coming on this one?** Moved up from Kat's step 4 because it reframes
   everything downstream — the app can't tell a romantic weekend from a family
   vacation without it. One question does double duty as party *and* purpose: "Just
   the two of us" reads romantic, "The whole family" reads family trip, "Extended
   family joining" reads multi-gen, plus advise-me.
3. **Timing** — exact dates, a flexible window, school-breaks-only, or advise-me.
4. **Pace** — pack it in / balanced / slow, or advise-me (tuned to whoever's coming,
   from Q2).
5. **Budget** — a guardrail, or "tell me what this costs."
6. **The plan** — branches on Q1:
   - *No path (idea-generation):* candidates, each with a reason.
   - *Yes path (destination known):* not candidates — a **priority and booking
     sequence** for the actual place, same as Kat's milestone engine produces.
   - **Either way, the plan argues from data, out loud**: "Because you're Castaway
     Gold, your window opens at 105 days instead of 90 — Alaska Cruise Group booking
     already reflects that ranking" style reasoning, grounded in the family profile
     and budget guardrail — not just a clean-looking answer with the reasoning hidden.

The consult ends the way a good advisor meeting ends: organized, dated, on budget, and
"every item gets a date; I'll bring each one to you when it's time."

**Then what happens (the part that was missing):** "File it in the binder" isn't an
exit — it's the seed of an ongoing thread. Filing does two things, both demonstrated in
the v3 prototype:
1. The trip becomes a live row in the Binder's "Trips on file" — summarized from what
   was actually answered (party, timing, destination or shape), not a placeholder.
2. A fresh "Just filed" card appears at the top of the Front Desk, acknowledging what
   just happened and naming the next concrete thing the concierge will do (price it
   this week, watch the booking window, etc).
From there the trip is on the same footing as the Alaska cruise example that's been on
the Front Desk from day one — its dated milestones (from the rules engine, or from the
candidate-narrowing timeline) are what generate future reminder cards. The consult
doesn't hand off to a separate system; it's the front door to the same one.

## Why not agents

Chris raised whether this needs individual AI agents given how much the flow branches
and personalizes. Recommendation: **no** — a richer deterministic question tree (the
shape above) feeding **one well-briefed Claude call** for the recommendation/synthesis
step gets the same result (branching by trip type, personalized recommendations
grounded in family data, savings reasoning) without a backend or orchestration layer.
This is the existing `askClaudeJSON` pattern in Kat's code, just given a fuller prompt
(family profile, loyalty tiers, budget guardrail) at the synthesis step. Real
multi-agent orchestration would trade that simplicity for more free-form reasoning per
step, at the cost of the single-file/no-build/GitHub-Pages/solo-maintained foundation
the whole app family depends on. Not worth it for a single-user planning wizard.

## What carries over

- **Kat's aesthetic** — the navy/brass/Marcellus look from Voyage Concierge was her
  choice and it already reads "concierge." v2 keeps her palette and type; only the
  structure changes.
- Her rules engine (booking windows, milestone scheduling, loyalty tiers) powers the
  reminders. Storage/tombstones/AZ-time helpers unchanged. Claude layer optional, as before.
- Trip-type playbooks replace baked-in Disney assumptions (unchanged from v1 concept).
- **Trip-app handoff**: when a trip is close, the concierge offers to commission the
  keepsake trip app (research brief → vacation-app-builder pipeline).

## Decisions on record

- Name: **Ortiz Touring Concierge** (Chris). Solo-first, Gist sync later. No deploy
  without approval. Full build only after prototype v2 look/feel is approved.
