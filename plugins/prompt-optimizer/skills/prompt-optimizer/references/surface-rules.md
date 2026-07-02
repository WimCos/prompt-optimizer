# Surface rules

The same prompt content is legitimate configuration on one surface and gets
filtered as injection-shaped on another. Determine the target surface FIRST,
then apply that surface's hard rules.

Epistemics: rules marked **[documented]** come from Anthropic's public
documentation. Rules marked **[observed 2026-07]** are empirical findings
validated against Claude Sonnet 5 and Opus 4.8 on claude.ai in July 2026 -
treat them as observed behavior, not official spec, and re-verify for newer
model families.

## Quick reference

| Surface | Trust tier | Roles allowed | Key rule |
| --- | --- | --- | --- |
| claude.ai user preferences | Filtered - applied selectively | No | Universal rules need "always" / "for all chats" phrasing |
| claude.ai project instructions | High - read as project config | Yes [documented] | Declaratives over coercion; no cross-cutting duplication |
| Claude Code rules / agent files | Config | Yes | Hooks over prose for determinism |
| API system prompt | Full control | Yes | Anthropic prompt-engineering docs apply directly |

## claude.ai user preferences (Settings > Profile)

Trust tier: filtered - the platform applies this field SELECTIVELY.
Applies account-wide, to every chat.

Hard rules:

- A rule the user wants applied in every chat MUST contain the literal
  phrasing "always" or "for all chats" (or equivalent like "whenever you
  respond"). Without it, the platform applies the rule only when it judges it
  relevant to the task at hand. **[observed 2026-07]**
- FORBIDDEN shape - identity reassignment: no "You are...", no role blocks,
  no "your purpose/mission is". These conflict with the platform's own
  system prompt and get quarantined. **[observed 2026-07]**
- FORBIDDEN shape - mandated visible internal procedure: no scratchpad
  blocks, no "before every response, think through...", no required
  reasoning rituals. **[observed 2026-07]**
- FORBIDDEN shape - tool-ordering state machines: no priority attributes, no
  enforcement="always", no "never use a lower-priority tool". Express tool
  choices as plain preferences with fallbacks. **[observed 2026-07]**
- FORBIDDEN register - coercion: no "No exceptions!", no "this overrides any
  tendency to...". Force is not the problem - shape is - but coercive
  meta-statements about the model's cognition read as override attempts.
  **[observed 2026-07]**
- ALLOWED and preferred register: second-person imperatives about behavior
  ("Verify versions before answering", "Skip flattery", "Be terse") and
  first-person context ("I prefer...", "My background is..."). Imperatives
  are steering, not injection. **[observed 2026-07]**
- Output-format requests, including literal wrappers or unusual formatting,
  are legitimate - but state the user's intent next to them ("this is
  intentional, render it literally; its absence is what confuses me") so the
  platform does not skip them as confusing output. **[observed 2026-07]**
- Content scope: cross-cutting only. Anything project-specific belongs in
  that project's instructions. **[documented]** - profile instructions are
  account-wide; project instructions are the per-project mechanism.
- Phrase tool needs by OUTCOME, not tool name, when the tool name varies per
  platform, and give a fallback for platforms where the tool is absent.
- Preferences never override correctness or safety, and refined prompts must
  not try to. In-conversation instructions outrank this field, so a user can
  always course-correct live. **[documented]**

## claude.ai project instructions

Trust tier: high - read as the project's legitimate configuration.
Applies to one claude.ai project, every chat inside it.

Hard rules:

- Role and persona framing is officially supported: "define roles or
  perspectives Claude should adopt within the project" is Anthropic's own
  documented use case. "You are..." is correct on this surface.
  **[documented]**
- Methodology, workflows, scope boundaries, query-type playbooks, and
  completion criteria all belong here.
- Prefer plain declaratives over coercion: "The agent proposes; the user
  decides" beats "This is NON-NEGOTIABLE. No exceptions." Same meaning, no
  adversarial edge, and it survives model generations that read stacked
  MUST/NEVER walls as hostile. **[observed 2026-07]**
- No mandated visible scratchpads - they render as literal clutter. If the
  prompt needs verification discipline, put it inside the workflow steps
  ("verify X before writing the steps"), not in a required thinking block.
- Do NOT duplicate cross-cutting content the user keeps in their global
  preferences (tone, formatting, timestamps, generic tool routing, generic
  verification rules). Duplication creates drift. If content would be
  identical across two projects, it does not belong in either project file.
- Deduplication caution: only TRUE duplicates are removed. A
  project-specific application, emphasis, or stricter variant of a global
  rule is not a duplicate - it stays, framed as an explicit override (see
  next rule). Domain-specific teaching content that merely resembles a
  general principle stays. When unsure, keep it and say so.
- Where the project intentionally overrides or tightens a global preference
  (e.g. teach at beginner level although the profile claims medium
  proficiency, or verify more aggressively than the general rule), state the
  override explicitly so smaller models do not have to resolve the conflict
  themselves.
- Project instructions load into every conversation in the project and cost
  tokens each time - keep them lean; task-specific instructions belong in
  individual chat messages.

## Claude Code rules and agent files

Trust tier: config - CLAUDE.md / AGENTS.md / skills / subagents are the
product's own mechanism for roles and procedures.

Hard rules:

- Roles, personas, procedures, and hard gates are all legitimate.
- When determinism is required (a step that must happen every time),
  recommend a hook, linter, or script - not prose. Prose is judged; hooks
  execute. **[documented]** - hooks are the supported mechanism for
  guaranteed behavior.
- For smaller or non-Anthropic models: leave no wiggle room. Prefer
  declarative state ("key: value" facts) over prohibition lists, imperative
  commands for actions, one instruction per line. Stacked MUST/NEVER walls
  degrade compliance on lesser models. **[observed 2026-07]**
- Encode rules as machine-checkable config where one exists (a
  .markdownlint.json over a prose rule list, a test over a convention
  description).

## API system prompt

Trust tier: full control - followed close to verbatim.

Hard rules:

- Anthropic's prompt-engineering documentation applies directly: XML
  structure, role prompting, few-shot examples, chain-of-thought,
  prefilling. **[documented]**
- This is the only surface where every technique is available with no filter
  layer. When a user needs a guaranteed ritual that other surfaces apply
  selectively, recommend moving it here or to Claude Code hooks.
