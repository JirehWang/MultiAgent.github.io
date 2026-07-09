# Devotional Agent Blueprint

## Main agent

- [devotional-orchestrator.toml](C:\Users\105221\.codex\agents\devotional-orchestrator.toml)

## Skills

- [devotional-exegesis](C:\Users\105221\.codex\skills\devotional-exegesis\SKILL.md)
- [biblical-theology-bridge](C:\Users\105221\.codex\skills\biblical-theology-bridge\SKILL.md)
- [spiritual-formation-guide](C:\Users\105221\.codex\skills\spiritual-formation-guide\SKILL.md)
- [devotional-question-architect](C:\Users\105221\.codex\skills\devotional-question-architect\SKILL.md)
- [spiritual-slide-composer](C:\Users\105221\.codex\skills\spiritual-slide-composer\SKILL.md)

## Intended flow

1. Exegesis
2. Biblical theology
3. Spiritual formation
4. Discussion and synthesis
5. Optional slide-ready transformation
6. Optional Bible-map packaging and NotebookLM upload handoff

## Design choice

Your original idea described three expert agents plus an optional Agent 0 question architect. I translated that into:

- one orchestrator agent
- five focused skills

This keeps the theological process staged, but avoids over-fragmenting runtime control.

## Agent 0 mapping

`Agent 0 / Question Architect` is represented by:

- [devotional-question-architect](C:\Users\105221\.codex\skills\devotional-question-architect\SKILL.md)

Its job is now split into two explicit modes:

- `Front-end architect mode`
  - define the controlling question and study spine before exegesis starts
- `Back-end discussion mode`
  - produce discussion questions, reflection prompts, and a golden sentence after the study is complete

## Bible map capability

Instead of creating a separate sixth skill, the existing slide-composer skill now also covers the Bible-map handoff workflow:

- FHL-locked viewport
- FHL-locked contour
- contour validation with a 95% gate
- NotebookLM package preparation
- NotebookLM MCP upload
- stop at upload
