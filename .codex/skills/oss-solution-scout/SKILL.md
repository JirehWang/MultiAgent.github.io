---
name: oss-solution-scout
description: Use when implementing code and at least two of these are true: the change likely needs more than 3 core modules, involves security/auth/stability/observability, requires long-term infrastructure maintenance, must follow an external standard, or the same category of problem has already blocked progress twice.
---

# OSS Solution Scout

## Purpose

Decide when to adopt or reference a mature open-source repository instead of building everything from scratch.
Prefer evidence over instinct.

## Use This Skill For

- Requests that are turning into a subsystem, not a small feature.
- Infrastructure or platform capabilities.
- Reliability- or safety-sensitive areas.
- Work that appears to need an established ecosystem implementation.

## Do Not Use This Skill For

- Small local fixes.
- Simple UI changes.
- Narrow business logic that fits naturally in the current codebase.

## Trigger Rule

Search for candidate repositories only if at least 2 of these are true:

- The implementation will likely require more than 3 core modules.
- The work involves security, authentication, stability, or observability.
- The work introduces infrastructure that will need long-term maintenance.
- The work must comply with an external standard or protocol.
- Progress has already been blocked twice by the same category of problem.

## Workflow

1. Define the needed capability in one sentence.
2. List non-negotiable constraints:
   - language or runtime
   - deployment model
   - license constraints
   - integration boundaries
   - required standards
3. If the trigger rule is met, use AnySearch first for repository discovery and alternative search.
4. Narrow to 2-4 serious candidates only.
5. Use DeepWiki to understand each candidate's purpose, architecture, and core modules.
6. Verify each candidate using GitHub pages, GitHub API, or official docs before recommending it.
7. Conclude with one of:
   - adopt a repo
   - reference a repo's design and implement locally
   - do not adopt; continue building in-repo

## Mature OSS Repository Criteria

Treat a repository as mature only if all required checks pass, at least 3 maturity signals are positive, and no major negative signal is present.

Required checks:

- The repository has a clear license suitable for the intended use.
- There has been visible maintenance activity within the last 12 months.
- Its purpose and architecture are understandable from docs, examples, or repo structure.
- It is compatible with the current stack or has a realistic integration path.

Maturity signals:

- Recent commits, releases, or issue/PR activity indicate the project is still alive.
- Installation and usage documentation are clear enough to onboard without guesswork.
- The project includes production-oriented features such as configuration, logging, testing, migration support, upgrade notes, or observability hooks.
- There are signs of real adoption such as integrations, ecosystem references, community usage, or downstream examples.
- The project appears broader than a demo, prototype, or one-off script.

Major negative signals:

- Missing, unclear, or risky license status.
- No meaningful maintenance activity in the last 12 months.
- Sparse or confusing docs that make safe adoption difficult.
- Large operational complexity with weak maintenance or upgrade guidance.
- The repo solves only part of the need and would require heavy custom glue code.

Decision rule:

- Recommend as mature only if all required checks pass.
- Require at least 3 positive maturity signals.
- Reject maturity if any major negative signal is clearly present.
- If evidence is mixed or incomplete, mark the repo as uncertain rather than mature.

## Source Roles

- AnySearch: first-pass repository discovery, alternative search, and broad web/domain search.
- DeepWiki: fast repository understanding, architecture review, and candidate comparison.
- GitHub pages, GitHub API, and official docs: maturity verification and adoption risk checks.

## Known Strong Candidates

Use these as search seeds, not automatic adoption decisions.

### Document parsing for RAG, agents, and web research

Consider `opendatalab/MinerU` when the needed capability is high-quality conversion of PDFs, Office files, images, or web pages into Markdown/JSON for downstream LLM, RAG, or agent workflows.

Good fit signals:

- Inputs include complex PDFs, scanned pages, tables, formulas, multi-column layouts, handwriting, or mixed Office formats.
- The output needs reading-order Markdown, structured JSON, extracted images/tables/formulas, or intermediate visual QA artifacts.
- A workflow needs CLI/API/Docker/MCP integration rather than one-off text scraping.
- Local/offline processing, batch parsing, or CPU/GPU deployment choices matter.

Verification checklist before recommending MinerU:

- Confirm the current license in `LICENSE.md`; GitHub may report it as `NOASSERTION` because MinerU uses a custom Apache-2.0-based license with extra commercial and attribution terms.
- Check recent commits, release notes, and README/docs because installation, supported Python versions, model backends, and hardware requirements change quickly.
- Test representative documents before adoption; the project itself warns that complex layouts, scanned pages, and handwritten content can still fall short.
- Confirm deployment constraints: Python version, RAM/disk, Windows/Linux/macOS support, CPU-only versus GPU/VLM backend, Docker/WSL2 requirements, and model download/cache behavior.
- Prefer `pipeline` or online demo evaluation for feasibility checks before introducing full local GPU/VLM infrastructure.

Recommendation pattern:

- Adopt MinerU when document parsing quality and structured outputs are central to the workflow.
- Reference MinerU's architecture when only a small in-repo extractor is needed.
- Avoid adopting it for simple web page text extraction, small PDFs with reliable embedded text, or cases where license attribution/commercial terms cannot be accepted.

## Verification Rule

Do not treat AnySearch or DeepWiki alone as sufficient proof of maturity.
Always verify license, maintenance, release patterns, documentation quality, and integration feasibility with GitHub metadata, GitHub API data, and official documentation before recommending adoption.

## Output Format

Provide:

- capability needed
- trigger conditions met
- candidate repositories
- maturity assessment
- adoption recommendation
- main risks or unknowns

## Red Flags

Do not:

- search for repos just because one exists
- recommend an immature repo to save time
- skip license or maintenance checks
- force OSS adoption when local implementation is clearly smaller and safer
