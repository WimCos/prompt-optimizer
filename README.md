# Prompt Optimizer

A Claude Code plugin that refines underspecified prompts into structured,
surface-correct, ready-to-use instructions for the Claude ecosystem.

The core insight it encodes: **the same prompt content is legitimate
configuration on one surface and gets filtered as injection-shaped on
another.** A role definition ("You are a senior code reviewer...") is correct
in an API system prompt, in claude.ai project instructions, and in a Claude
Code agent file - and it is quarantined in the claude.ai user preferences
field, where the platform applies content selectively. This plugin knows the
rules per surface and asks for the target surface before writing a single
line.

## The four surfaces

| Surface | Trust tier | Roles allowed | Key rule |
| --- | --- | --- | --- |
| claude.ai user preferences | Filtered - applied selectively | No | Universal rules need "always" / "for all chats" phrasing |
| claude.ai project instructions | High - read as project config | Yes | Declaratives over coercion; no cross-cutting duplication |
| Claude Code rules / agent files | Config | Yes | Hooks over prose when determinism is required |
| API system prompt | Full control | Yes | Anthropic prompt-engineering docs apply directly |

Full decision tables:
[surface-rules.md](plugins/prompt-optimizer/skills/optimize/references/surface-rules.md).
Worked examples, including a full system-prompt-to-preferences conversion:
[conversions.md](plugins/prompt-optimizer/skills/optimize/references/conversions.md).

## Install

From inside Claude Code:

```text
/plugin marketplace add WimCos/prompt-optimizer
/plugin install prompt-optimizer@prompt-optimizer
```

Or from a local clone:

```text
/plugin marketplace add /path/to/prompt-optimizer
/plugin install prompt-optimizer@prompt-optimizer
```

## Use

Invoke the skill directly:

```text
/prompt-optimizer:optimize refine this prompt: "act as a code reviewer"
```

Or just ask naturally - the skill triggers on requests like "optimize my
system prompt", "rewrite my claude.ai preferences", "improve my project
instructions", "convert this prompt for Claude Code", or "why is my prompt
being ignored".

The skill asks one clarifying question at a time (starting with the target
surface if unstated), produces the refined prompt as a file, and explains
what changed and why.

## Validity and epistemics

The surface rules mix two kinds of knowledge, labeled in the reference files:

- **[documented]** - from Anthropic's public documentation.
- **[observed 2026-07]** - empirical behavior validated against Claude
  Sonnet 5 and Opus 4.8 on claude.ai in July 2026. Platform behavior changes
  between model generations; the skill instructs the model to re-verify
  against current documentation when advising for newer model families, and
  you should too before relying on the observed rules.

Issues and PRs correcting stale rules are welcome - that is the main
maintenance burden of this plugin, by design.

## Skill format

The skill follows the [agentskills.io](https://agentskills.io) standard
(SKILL.md with frontmatter, progressive disclosure via references/), so it is
usable by other agents that support the standard - it is not coupled to
Claude Code.

## License

[MIT](LICENSE)
