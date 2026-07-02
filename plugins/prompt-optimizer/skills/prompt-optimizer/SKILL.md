---
name: prompt-optimizer
description: Refine, optimize, or rewrite prompts for the Claude ecosystem with surface-aware rules. Use when the user wants to improve a prompt, system prompt, project instructions, user preferences, CLAUDE.md/AGENTS.md content, or agent persona - or to convert a prompt from one surface to another (e.g. a system prompt into claude.ai preferences). Trigger phrases - /prompt-optimizer, refine this prompt, optimize my system prompt, rewrite my preferences, improve my project instructions, convert this prompt for Claude Code, why is my prompt being ignored.
license: MIT
---

# Prompt Optimizer

Transform basic, underspecified prompts into structured, high-quality
instructions that produce consistent, reliable AI behavior. Produce
ready-to-use prompts, not generic advice.

The core insight this skill encodes: **the same prompt content is legitimate
configuration on one surface and gets filtered as injection-shaped on
another.** A role definition is correct in an API system prompt and in
claude.ai project instructions, and it is quarantined in the claude.ai user
preferences field. Knowing the target surface is not optional - it determines
every rule that follows.

**Target surface** - the place your prompt goes (the claude.ai preferences
box, a project's instructions, a Claude Code file, or an API system prompt).
Different surfaces trust your prompt differently.

## Process

### 1. Determine the target surface

The four surfaces are: claude.ai user preferences, claude.ai project
instructions, Claude Code rules/agent files, API system prompt.

If the user has not stated the surface, ask - it is always the first
clarifying question. Ask exactly one question per response and wait for the
answer; never present a list of questions.

Then read `references/surface-rules.md` and apply that surface's hard rules.

### 2. Analyze

Before writing anything, determine:

- What is the user trying to accomplish with this prompt?
- What are the implicit requirements the user has not stated?
- What failure modes would a naive version produce?
- Does any content overlap the user's global preferences or belong on a
  different surface? If yes, propose the single right home instead of
  duplicating - content identical across two projects belongs in neither
  project file.
- Does a prior refinement artifact already exist at or near the destination
  (an earlier dated sibling, a misnamed previous attempt)? If yes, do NOT
  adopt its content. Refine from the original source only; the prior
  artifact is evidence of naming convention, nothing more. If your output
  converges with it, that convergence must fall out of independent work,
  proven by the section accounting table (see Validate).

### 3. Produce

Generate the refined prompt as a complete, self-contained document that obeys
the target surface's hard rules. Use these sections, including only what is
relevant:

- **role** - who Claude is and what it does, one paragraph maximum.
  OMIT on the claude.ai preferences surface; convert to imperatives there.
- **constraints** - hard rules and guardrails, stated as declaratives.
- **methodology** - concrete steps with observable outcomes.
- **examples** - at least one input/output pair; two to three covering
  different scenarios is ideal. One good example teaches more than five
  paragraphs of abstract rules.
- **output_format** - structure, length, tone, required elements. Never a
  mandated visible thinking or scratchpad block, on any surface.

### 4. Validate

Before presenting the result, verify:

- The prompt obeys every hard rule of its target surface. For the
  preferences surface specifically: every universal rule carries "always" or
  "for all chats"; zero identity statements; zero procedure scripts; zero
  tool state machines.
- **Section accounting (mandatory when refining an existing prompt):** list
  EVERY top-level section of the ORIGINAL, and mark each one exactly one of:
  kept / merged into {where} / removed because {reason}. The removal summary
  in the delivery is generated from this table, not from memory of what you
  did. A section of the original that appears in neither the output nor the
  table is a defect - this is the check that catches content silently lost
  to anchoring or false deduplication.
- The output contains at least one worked input/output example. The Produce
  step requires it; this check catches its omission - the section table only
  audits what was in the original, not what the skill requires you to add.
- Deduplication removes only TRUE duplicates of the user's global
  preferences - a project-specific application, emphasis, or stricter
  variant of a general rule is NOT a duplicate. When unsure whether content
  is a duplicate, keep it.
- Every instruction changes behavior - remove decorative text.
- No instruction contradicts another or silently conflicts with the user's
  global preferences.
- Examples are consistent with the stated rules.
- Vague language ("thorough", "comprehensive", "detailed") is replaced with
  specific, measurable criteria.

### 5. Deliver

When file access is available, write the refined prompt to a file and
summarize what changed. The summary's removed/merged list comes from the
section accounting table - include every removed or merged row with its
reason, plus any claims you did not verify.

Naming and location: follow the user's established convention for the
artifact type when one exists - inspect the destination directory first
(e.g. a `project-instructions/` directory of `project-instructions-<name>.xml`
files with dated siblings means the refined version is named
`project-instructions-<name>-<YYYY-MM-DD>.xml`, not something new). Only when
no convention is discoverable, fall back to
`prompt-{YYYYMMDD-HHMM}-{slug}.md` or `.xml`.

In chat-only contexts, deliver inline - same process, different last step.

## Register rules

Three registers exist for any instruction. Firmness is never the problem -
shape is. Keep the demand, fix the shape.

| Register | Example | Verdict |
| --- | --- | --- |
| Begging | "I'd really rather you didn't..." | Never use - weak, and buys nothing |
| Steering | "Verify before answering. Skip flattery. Open with the answer." | Default everywhere - imperatives instruct behavior without redefining identity |
| Identity | "You are a senior code reviewer..." | Trusted surfaces only (project instructions, Claude Code files, API) - never the claude.ai preferences field |

## Core principles

- **Context over verbosity** - the minimal set of high-signal instructions.
  Every sentence must earn its place.
- **Concrete over abstract** - specify observable behavior, never "be
  helpful".
- **Examples over rules** - always include at least one input/output example.
- **Semantic structure** - XML tags for Claude targets, with self-describing
  names. There are no magic tag names, and renaming a tag does not change how
  content is judged: a `<role>` renamed to `<what_i_expect_from_you>` is
  still an identity block if the content says "You are...". Filters read
  meaning, not labels.
- **Positive framing** - state what to do; reserve negatives for critical
  guardrails.
- **Outcome over mechanism** - when a tool name varies per platform, phrase
  the instruction by outcome ("start each reply with the current time from
  your time tool") rather than tool name, and give a fallback for platforms
  where the tool is absent.
- **Config over prose** - on the Claude Code surface, when determinism is
  required, recommend a hook, linter, or config file. Prose is judged; hooks
  execute.

## Constraints

- Do not invent capabilities the target model or platform does not have. If
  the original prompt implies an unverifiable capability, flag it as a
  question.
- Do not state unverified rationales as fact. When a justification inside a
  refined prompt rests on a claim you have not checked (e.g. "schemas break
  across minor versions"), either verify it, mark it as unverified in the
  delivery summary, or drop the claim and keep the rule.
- Do not borrow conventions from other AI platforms and present them as
  Claude best practices. Stick to Anthropic's documented patterns: XML
  structure, role prompting, few-shot examples, chain-of-thought, prefilling.
- For Claude targets, output valid XML with a single root element. For other
  target models, follow that model creator's current documented best
  practices - ask which model the prompt targets if unknown.
- Platform behavior changes between model generations. The surface rules in
  this skill were validated in July 2026 (Claude Sonnet 5 / Opus 4.8 era).
  When advising for a newer model family, verify against current Anthropic
  documentation before relying on them.

## What not to do

- Padding with motivational language ("You are an expert who excels at...").
  State the role in one factual sentence.
- Listing responsibilities without an observable output format.
- Writing a system-prompt-shaped block for the claude.ai preferences field,
  or "fixing" one by renaming its tags.
- Omitting "always" / "for all chats" from a preferences rule the user wants
  applied universally - without the phrasing it is applied only when judged
  relevant.
- Mandating visible scratchpads or reasoning rituals, on any surface.
- Duplicating cross-cutting content into a project file when it belongs once
  in the user's global preferences.
- Classifying project-specific content as duplication because it RESEMBLES
  generic content, then silently dropping it. Teaching emphasis, domain
  rules, and stricter variants stay; removals are always named.
- Adopting a prior refinement artifact found at the destination instead of
  refining from the original. Prior outputs are naming evidence, not
  content - anchoring on them re-imports their mistakes and bypasses every
  validation step.
- Inventing a filename or location when the destination directory already
  shows a naming convention.
- Over-structuring with deeply nested XML when flat sections are equally
  clear.

## References

- `references/surface-rules.md` - the four-surface decision table with hard
  rules per surface. Read it whenever the target surface is known.
- `references/conversions.md` - worked examples, including a full
  system-prompt-to-preferences conversion.
