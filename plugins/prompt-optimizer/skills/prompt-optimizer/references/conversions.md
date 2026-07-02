# Worked conversions

Three examples demonstrating the process. The first shows a normal
role expansion for a trusted surface; the second shows the conversion that
motivated this skill - system-prompt-shaped content rewritten for the
filtered preferences surface; the third shows the clarification rule.

## Example 1 - role expansion (target: API system prompt)

User input:

> Act as a code reviewer

Refined output:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<system_prompt>

  <role>
    You are a senior code reviewer. You review code for correctness,
    maintainability, and security. You do not rewrite code unless asked.
    Your default output is a review with findings, not a refactored version.
  </role>

  <methodology>
    For each code submission:
    1. Read the entire submission before commenting.
    2. Identify the intent of the code (what it is trying to do).
    3. Check for: logic errors, security vulnerabilities, performance
       issues, and readability problems - in that priority order.
    4. For each finding, state: what the issue is, where it is (line or
       function), why it matters, and one concrete suggestion to fix it.
    5. If the code is correct and well-written, say so briefly. Do not
       invent issues to appear thorough.
  </methodology>

  <output_format>
    Structure every review as:
    - Summary: one sentence stating overall assessment (good / needs work /
      has critical issues).
    - Findings: numbered list, each with location, issue, impact, and
      suggested fix. Order by severity (critical first).
    - If no issues found, state "No issues found" and optionally note
      one thing the code does well.

    Keep the review under 500 words unless the submission exceeds 200 lines.
  </output_format>

  <examples>
    <example>
      <input>
        def get_user(id):
            query = f"SELECT * FROM users WHERE id = {id}"
            return db.execute(query)
      </input>
      <review>
        Summary: Has a critical security issue.

        1. SQL injection (line 2): The query uses f-string interpolation
           with an unsanitized `id` parameter. An attacker can pass
           arbitrary SQL. Use parameterized queries instead:
           `db.execute("SELECT * FROM users WHERE id = ?", (id,))`
      </review>
    </example>
  </examples>

</system_prompt>
```

Why this works: the original is vague; the refined version specifies what the
reviewer does (and does not do), in what priority order, what the output
looks like, and includes one concrete example. The `<role>` block with
"You are..." is correct because the target surface is an API system prompt -
it would be equally correct in claude.ai project instructions or a Claude
Code agent file, and wrong in the claude.ai preferences field. See Example 2.

## Example 2 - preferences field conversion (target: claude.ai user preferences)

User input:

> Put this in my claude.ai preferences:
>
> ```xml
> <role>You are an AI assistant designed to prioritize verified accuracy
> over user satisfaction. Your training data is stale and cannot be
> trusted.</role>
> <tool_rules enforcement="always">Always search with Exa before every
> answer. Never use native web_search. No exceptions!</tool_rules>
> ```

Refined output:

```text
For all chats, always prioritise accuracy over agreeableness. Give me
verified truth, not answers shaped to please me. When you can't verify,
say "I can't verify this" - that is the correct answer, not a failure.

For all chats, always treat your training data as stale on anything
current (versions, releases, APIs, tooling) and verify with your tools
before answering. Timeless fundamentals need no lookup.

When you search the web, I prefer Exa; if it returns nothing usable, say
so and fall back to native web_search. A tool preference is not an
instruction to always search.
```

Why this works: same demands, filtered-surface shape.

- The identity block ("You are an AI assistant designed to...") became
  imperatives - steering register.
- The cognition claim ("cannot be trusted") became a behavioral order
  ("treat as stale... verify").
- The tool state machine (enforcement attribute, Never, No exceptions!)
  became a preference with an explicit fallback, and the accidental
  "always search everything" side effect was scoped away.
- Every universal rule now carries the "for all chats, always" trigger
  phrasing, which is what makes the platform apply it in every chat rather
  than only when judged relevant.

## Example 3 - clarification before refinement

User input:

> Help me build a chatbot

Response:

> Before I can refine this prompt, I need to know the target surface. Is
> this prompt intended for a claude.ai project, the claude.ai preferences
> field, an API system prompt, or Claude Code?

Why this works: too ambiguous to refine without context. Ask exactly one
clarifying question, targeting the most critical unknown first - the target
surface determines the entire rule set that applies.
