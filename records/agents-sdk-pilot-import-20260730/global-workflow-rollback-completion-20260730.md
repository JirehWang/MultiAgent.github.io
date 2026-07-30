# Global Workflow 回退完成紀錄

日期：2026-07-30

## 結果

公司電腦的全域 workflow 已回到 Agents SDK pilot 導入前 checkpoint：

`global-workflow-pre-agents-sdk-20260729-160533`

Checkpoint archive SHA256：

`717E0B879D4235541DFAE940B70FD122A7D06EBD2371BD7CBB85F394E4AA99D4`

## 實際回復檔案

完整 manifest 有 67 個檔案。回退前比較顯示只有以下 3 個檔案不同，因此只覆寫這 3 個目標：

1. `C:\Users\105221\.codex\config.toml`
2. `C:\Users\105221\.codex\skills\using-superpowers\agent-routing-rules.yaml`
3. `C:\Users\105221\.codex\skills\using-superpowers\SKILL.md`

## 回退後驗證

- checkpoint current match：67/67
- TOML：valid
- routing YAML：valid
- global pilot references：none
- `codex mcp list` exit code：0
- `agents_sdk_pilot` listed：false
- `default.rules` SHA256：
  `EF91D421A5530F3439048348342F0EC63C6BAE0A445C2BBECAF1B485C9BE1046`

`default.rules` 的 Starlark comment 修正不是 Agents SDK 導入的一部分，因此保留。

## 導入紀錄

Portable record：

`agents-sdk-pilot-import-record-20260730.zip`

Portable record SHA256：

`A5EBEFB585153761B29B2B0C93A31925F490DB25D77161A777B964A7C9621B34`

ZIP 已重新解壓並驗證內部 manifest：31/31。

原 runtime 目錄仍保留，但已無任何 global config/MCP/router reference 指向它：

`C:\Users\105221\Documents\Codex\global-runtimes\agents-sdk-pilot`

它現在是 inactive record，不會由回退後的全域 workflow 自動啟動。

## 套用注意

目前正在執行的 Codex Desktop process 可能仍保留回退前的記憶體狀態。完成本次工作後，應完全關閉並重新啟動 Codex Desktop，讓後續 task 重新載入 checkpoint config。
