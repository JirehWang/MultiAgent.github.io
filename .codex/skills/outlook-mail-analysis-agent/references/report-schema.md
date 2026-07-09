# Report Schema

## emails.csv

- `source_file`: Absolute path of the parsed email file
- `parse_format`: `eml` or `msg`
- `message_id`: Parsed `Message-ID` when available
- `in_reply_to`: Parsed `In-Reply-To`
- `references`: Flattened `References` chain
- `subject_raw`: Original subject
- `subject_normalized`: Lowercased subject with common reply/forward prefixes removed
- `sender`: Primary sender email address
- `to`: Pipe-separated recipient list
- `cc`: Pipe-separated CC list
- `date`: Parsed timestamp in ISO format when available
- `conversation_key`: Thread key used by the pipeline
- `thread_root_id`: Root message id or fallback root key
- `parent_message_id`: Resolved parent message id
- `first_reply_message_id`: Earliest child reply found
- `first_reply_delay_minutes`: Minutes until first reply
- `reply_status`: `replied`, `not_replied`, or `missing_date`
- `body_preview`: Short plain-text preview
- `warnings`: Parse or linkage warnings

## threads.csv

- `thread_key`: Thread identifier
- `root_message_id`: Root message id or fallback root key
- `subject`: Representative normalized subject
- `message_count`: Number of emails in the thread
- `started_at`: Earliest parsed timestamp
- `ended_at`: Latest parsed timestamp
- `participants`: Pipe-separated normalized participant list
- `has_reply`: Boolean-like value showing whether the thread has more than one message
