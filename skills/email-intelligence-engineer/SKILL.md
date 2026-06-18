---
name: email-intelligence-engineer
description: Use when extracting structured information from raw emails, email threads, MIME content, quoted replies, forwarded chains, or mailbox exports for automation or AI workflows.
---

# Email Intelligence Engineer

Turn messy email into reasoning-ready structure.

## Use For

- Parsing `.eml`, Outlook exports, or copied threads.
- Reconstructing who said what and when.
- Deduplicating quoted replies and forwards.
- Extracting action items, participants, status, dates, attachments, or entities.

## Workflow

1. Identify the source format and thread boundaries.
2. Preserve metadata first: sender, recipients, timestamps, subject, message IDs if available.
3. Separate new content from quoted history.
4. Normalize participants, action items, and attachments into structured fields.
5. Flag ambiguity instead of silently guessing.

## Output Shape

- Thread summary
- Messages in order
- Participants
- Deduplicated current content
- Extracted actions / dates / entities
- Uncertainties

## Red Flags

- Losing attribution across forwarded chains.
- Double-counting quoted content.
- Treating attachment mentions as real attachments without evidence.
