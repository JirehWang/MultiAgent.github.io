# PromptHub Integration

Use this reference when the user wants to include PromptHub in the version-management workflow.

## Role Split

- `git hooks`: Auto-trigger checks before `git push`
- `git-version-management` skill: Analyze local versus remote revision state and recommend next Git actions
- `PromptHub`: Manage the skill, prompt variants, rule packs, and future agent assets as reusable artifacts
- `GitHub` / `gh`: Provide remote repository, PR, and collaboration state

## What PromptHub Improves

- Centralizes the skill and related prompts in one local-first workspace
- Preserves version history for the skill itself
- Makes it easier to distribute the same skill to Codex and other AI tools
- Lowers maintenance cost when the skill grows into multiple variants, languages, or rule sets

## What PromptHub Does Not Replace

- Git working tree inspection
- Ahead/behind calculation
- Pre-push enforcement
- Pull request or remote branch status checks

## Recommended Workflow

1. Keep the live executable skill in the global Codex skills directory.
2. Maintain the editable source-of-truth copy in a dedicated workspace or PromptHub-managed asset folder.
3. Use Git to version the source-of-truth files.
4. Use PromptHub to browse, version, compare, and distribute the skill to other AI tools.
5. Keep `pre-push` hooks focused on repo safety checks, not asset management.

## Practical Next Step

If PromptHub is installed later, register `git-version-management` there as a managed skill asset and treat PromptHub as the UI and distribution layer above the current Git hook workflow.
