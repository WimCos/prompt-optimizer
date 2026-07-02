# Prompt Optimizer

A skill that refines underspecified prompts into structured, surface-correct,
ready-to-use instructions for the Claude ecosystem. Distributed as a Claude
Code plugin marketplace and as an uploadable skill zip for claude.ai and
Claude Desktop.

The core insight it encodes: **the same prompt content is legitimate
configuration on one surface and gets filtered as injection-shaped on
another.** A role definition ("You are a senior code reviewer...") is correct
in an API system prompt, in claude.ai project instructions, and in a Claude
Code agent file **but** it is quarantined in the claude.ai user preferences
field, where the platform applies content selectively. This skill knows the
rules per surface and asks for the target surface before writing a single
line.

New to the term? **Target surface** simply means the place your prompt goes:
the claude.ai preferences box, a project's instructions, a Claude Code file,
or an API system prompt. Different surfaces trust your prompt differently:
same letter, different mailbox, different rules.

## The four surfaces

| Surface | Trust tier | Roles allowed | Key rule |
| --- | --- | --- | --- |
| claude.ai user preferences | Filtered - applied selectively | No | Universal rules need "always" / "for all chats" phrasing |
| claude.ai project instructions | High - read as project config | Yes | Declaratives over coercion; no cross-cutting duplication |
| Claude Code rules / agent files | Config | Yes | Hooks over prose when determinism is required |
| API system prompt | Full control | Yes | Anthropic prompt-engineering docs apply directly |

Full decision tables:
[surface-rules.md](plugins/prompt-optimizer/skills/prompt-optimizer/references/surface-rules.md).
Worked examples, including a full system-prompt-to-preferences conversion:
[conversions.md](plugins/prompt-optimizer/skills/prompt-optimizer/references/conversions.md).

## Install in Claude Code (plugin marketplace)

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

Invoke with `/prompt-optimizer:prompt-optimizer`, or just ask naturally - the
skill triggers on requests like "optimize my system prompt", "rewrite my
claude.ai preferences", "improve my project instructions", "convert this
prompt for Claude Code", or "why is my prompt being ignored".

## Use in claude.ai and Claude Desktop (skill zip)

The same skill works as an uploaded skill in claude.ai and Claude Desktop. This
is useful because prompt work is often done in the chat apps, not the terminal.

Grab the prebuilt zip from the latest
[GitHub Release](https://github.com/WimCos/prompt-optimizer/releases).

Or build the zip yourself:

***macOS / Linux***

```shell
./tools/zip-skill.sh
```

***Windows***

```powershell
./tools/zip-skill.ps1
```

This produces `dist/prompt-optimizer-skill.zip` containing the
`prompt-optimizer/` skill folder (SKILL.md at the folder root, with its
`references/`). Upload it in claude.ai under Settings > Capabilities >
Skills.

Notes for the chat surfaces:

- The skill name is unique (`prompt-optimizer`) because claude.ai skills are
  flat. They do not have plugin namespacing like Claude Code. If you also use
  other skill collections, names must not collide.
- In chat apps without file access, the skill delivers refined prompts
  as downloadable artifacts instead of writing files.

## How it behaves

The skill asks one clarifying question at a time (starting with the target
surface if unstated), applies that surface's hard rules, produces the refined
prompt, validates it against the surface checklist, and explains what changed
and why.

## Validity and epistemics

The surface rules mix two kinds of knowledge, labeled in the reference files:

- **[documented]** - from Anthropic's public documentation.
- **[observed 2026-07]** - empirical behavior validated against Claude
  Sonnet 5 and Opus 4.8 on claude.ai in July 2026. Platform behavior changes
  between model generations; the skill instructs the model to re-verify
  against current documentation when advising for newer model families, and
  you should too before relying on the observed rules.

Issues and PRs correcting stale rules are welcome - that is the main
maintenance burden of this project, by design.

## Repository layout

```text
.claude-plugin/marketplace.json    - Claude Code marketplace manifest
plugins/prompt-optimizer/          - the plugin package
  .claude-plugin/plugin.json       - plugin manifest
  skills/prompt-optimizer/         - the skill (SKILL.md + references/)
tools/zip-skill.sh                 - builds the claude.ai skill zip into dist/ (macOS/Linux)
tools/zip-skill.ps1                - same build for Windows (PowerShell)
```

The zip is a build artifact: it is not tracked in git (see `.gitignore`) and
is published as a GitHub Release asset instead, so the downloadable zip is
always tied to a tagged version and cannot silently drift from the source.

## Skill format

The skill follows the [agentskills.io](https://agentskills.io) standard
(SKILL.md with frontmatter, progressive disclosure via references/), so it is
usable by other agents that support the standard.

I have not tested the skill in other agents like OpenCode, Codex or Pi, nor
have I tested the prompts it creates against other models than the Claude
models.

## License

[MIT](LICENSE)
