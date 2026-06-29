# Antigravity Model Routing

Use `antigravity-model-routing` before substantive work to choose the smallest capable official Antigravity reasoning model. Prefer the shared agent profile `MODEL.md` files bundled with that skill when a task maps cleanly to a profile.

The root conversation may start on the currently selected model. Keep initial routing small. For nontrivial work, identify the recommended model before execution and ask the user to switch the Antigravity model selector when the current model is clearly too weak or too expensive for the task.

Default daily driver: `Gemini 3.5 Flash`.

Use lighter models only for simple, reversible work:

- `Gemini 3 Flash`: tiny edits, simple formatting, quick browser/tool tasks, low-risk extraction.
- `GPT-OSS-120b`: low-sensitivity, repeatable, cost-first work where occasional reruns are acceptable.

Use higher models only when the task deserves it:

- `Gemini 3.1 Pro (low)`: medium-complexity multi-file work or repo exploration when `Gemini 3.5 Flash` is likely enough but risk is rising.
- `Gemini 3.1 Pro (high)`: debugging, verification, regression hunting, complex implementation, and high-uncertainty coding.
- `Claude Sonnet 4.6 (thinking)`: code review, careful debugging, and long-context reasoning where a strong reviewer is valuable.
- `Claude Opus 4.6 (thinking)`: architecture, multi-agent workflow design, hard tradeoffs, and high-risk decisions.

Use Antigravity's image tool, powered by `Nano Banana 2`, for generative image tasks such as UI mockups, page images, diagrams, and visual assets.

Antigravity subagents inherit the parent model. Before launching subagents for a complex task, choose the parent model that matches the highest-risk subtask, or split the work into separate conversations with different selected models.
