---
name: mail-requirement-workflow-agent
description: Use when the user wants to turn a mail-sending requirement into a mailsending-ready Excel template and a matching markdown breakdown. Trigger for requests about collecting sender requirements, breaking them into a standard output format, filling the mailsending template, and notifying that automated sending can begin. Supports `.msg` requirement sources and conflict-minerals missing-submission workbooks.
---

# 寄信需求工作流 Agent

Follow this workflow exactly:

1. Identify the requirement source type.
   - Use `msg` mode when the user provides a `.msg` source mail.
   - Use `conflict-minerals` mode when the user provides a conflict-minerals missing-submission workbook plus CMRT and EMRT attachments.

2. Run the workflow entrypoint:
   - Script: `D:/py/mailsending/mail_requirement_workflow_agent.py`
   - Outputs:
     - one `mailsending`-ready `.xlsx`
     - one sidecar `.md` requirement breakdown

3. Keep the Excel output operational.
   - The workbook must contain only the `mailsending` import format:
     - `To`
     - `CC`
     - `Subject`
     - `Situation`
     - `Date`
     - `Body`
     - `Attachments`
     - `Image`
     - `Table Range`
   - Do not add explanation sheets to the workbook.

4. Report completion in the final response.
   - State where the `.xlsx` and `.md` were written.
   - State that the template is ready for automated sending.
   - Mention any remaining manual fields such as unresolved attachment paths or ambiguous dates.

## Commands

### `.msg` requirement source

```bash
python D:/py/mailsending/mail_requirement_workflow_agent.py msg --msg "<source.msg>" --output "D:/py/mailsending/輸出/<name>.xlsx"
```

### conflict-minerals requirement source

```bash
python D:/py/mailsending/mail_requirement_workflow_agent.py conflict-minerals --source "<source.xlsx>" --cmrt "<cmrt.xlsx>" --emrt "<emrt.xlsx>" --output "D:/py/mailsending/輸出/<name>.xlsx"
```

## Completion Rule

The task is complete only after:

- the `.xlsx` exists
- the `.md` exists
- the `.xlsx` active sheet is the mailsending import sheet
- the user is told the template is ready for automated sending
