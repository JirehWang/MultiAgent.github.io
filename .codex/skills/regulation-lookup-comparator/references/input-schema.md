# Regulation Ingestion Schema

在法規或控制項輸入時，優先整理為以下欄位：

- `regulation_name`
- `jurisdiction`
- `document_type`
- `document_number`
- `version_or_revision`
- `change_type`
  - `增修條文`
  - `舊版廢除並改新版`
  - `全新法規`
- `publication_date`
- `entry_into_force_date`
- `application_date`
- `transition_end_date`
- `official_source_url`
- `chapter_or_article`
- `topic`
- `requirement_text`
- `applicable_product_scope`
- `applicable_material_scope`
- `applicable_role`
- `required_evidence`
- `labeling_requirement`
- `technical_document_requirement`
- `declaration_requirement`
- `traceability_requirement`
- `test_requirement`
- `remarks`

如果是客戶或內規控制項，對應整理為：

- `source_document`
- `source_clause`
- `control_topic`
- `control_statement`
- `applicable_role`
- `required_submission`
- `effective_date`
- `note`

