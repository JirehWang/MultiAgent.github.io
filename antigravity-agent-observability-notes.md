# Antigravity 全域 Agent 調用觀察筆記

## 需求重點

你的需求不是單純列出有哪些全域 agent，而是要更細部地觀察：

- 每次 agent 調用是否合理
- 哪些 agent 被叫得太頻繁
- 哪些 agent 的 handoff 不合理
- 哪些 tool call 成本高但沒有帶來足夠價值
- 哪些 workflow 出現重複繞圈、context 斷裂或責任重疊

這類問題，本質上比較接近 `agent call observability`，而不是 `agent registry` 或 `agent orchestration UI`。

## 我會優先看的 Repo

### 1. Phoenix

Repo: [Arize-ai/phoenix](https://github.com/Arize-ai/phoenix)

最接近「拿來判斷 agent workflow 是否合理」的開源方案。

適合原因：

- 偏 `observability + evaluation + troubleshooting`
- 能看 trace、prompt、tool call、retrieval、response 之間的關係
- 比較容易看出多 agent workflow 中哪一步不自然
- 比較適合做「合理性診斷」，不只是記錄事件

比較能回答的問題：

- 為什麼某個 agent 在這個任務裡被叫了 4 次？
- 哪個 step 一直重試但沒有推進？
- 哪個 tool call 昂貴但貢獻很低？
- context 是在哪一段傳丟的？

### 2. AgentOps

Repo: [AgentOps-AI/agentops](https://github.com/AgentOps-AI/agentops)

如果你更想看 agent 的執行回放與 session replay，這個很對題。

適合原因：

- 偏 `agent monitoring`
- 強調 `session replay`
- 有 step-by-step execution graph 的思路
- 很適合追多 agent handoff 與操作順序

比較能回答的問題：

- 某個 agent 這次到底做了哪些步驟？
- 多 agent 之間的 handoff 是否過多？
- 有沒有不必要的中介 agent？
- 哪段流程只是把同一件事換個 agent 重做一次？

### 3. Langfuse

Repo: [langfuse/langfuse](https://github.com/langfuse/langfuse)

如果你想要比較完整的平台化能力，Langfuse 很成熟。

適合原因：

- 偏完整的 LLM engineering platform
- 有 monitor、debug、eval、metrics
- 適合跨產品或跨服務看整體健康度

限制：

- 它很強，但在「agent workflow 合不合理」這件事上，通常沒有 Phoenix 那麼直接

### 4. OpenLIT

Repo: [openlit/openlit](https://github.com/openlit/openlit)

如果你想把 agent observability 接到既有 OpenTelemetry 生態，OpenLIT 很值得看。

適合原因：

- `OpenTelemetry-native`
- 容易接進既有 telemetry/collector/dashboard
- 適合想把 agent 監控納入公司統一可觀測性系統

限制：

- 比較偏平台整合與全域監控，不一定是最直覺的 agent workflow 診斷工具

## 簡單結論

如果目標是觀察 `antigravity` 裡全域 agent 的調用是否合理，我的建議排序是：

1. `Phoenix`
2. `AgentOps`
3. `Langfuse`
4. `OpenLIT`

一句話理解：

- `Phoenix` = 偏診斷合理性
- `AgentOps` = 偏回放執行過程
- `Langfuse` = 偏產品級平台監控
- `OpenLIT` = 偏 OpenTelemetry 生態整合

## 不要期待「自動看懂所有全域 agent」

實務上，通常不會有一個 repo 能直接無痛理解你 `antigravity` 裡所有全域 agent 的設計意圖。

真正可行的方式通常是：

把每次 agent 調用統一打成 trace/span，再送進可觀測性工具裡看。

也就是說，重點不是先找一個神奇 repo，而是先把你的 runtime event 結構化。

## 建議的 Trace / Span 模型

你可以把每一次任務拆成這幾層：

- `workflow span`
- `agent span`
- `tool span`
- `llm call span`
- `handoff span`

### 1. workflow span

代表整個任務，例如：

- 使用者要求完成某件事
- 系統啟動一組 agent 協作

建議欄位：

- `workflow_id`
- `task_type`
- `entry_agent`
- `goal`
- `start_time`
- `end_time`
- `final_status`
- `total_cost`
- `total_tokens`
- `agent_count`

### 2. agent span

代表某個 agent 在 workflow 裡的一段工作。

建議欄位：

- `agent_name`
- `agent_role`
- `parent_workflow_id`
- `reason_for_invocation`
- `input_summary`
- `output_summary`
- `decision_type`
- `latency_ms`
- `cost`
- `token_in`
- `token_out`
- `retry_count`

### 3. tool span

代表 agent 呼叫某個 tool。

建議欄位：

- `tool_name`
- `tool_category`
- `caller_agent`
- `input_shape`
- `result_status`
- `result_summary`
- `latency_ms`
- `error_type`

### 4. llm call span

代表實際模型調用。

建議欄位：

- `model`
- `provider`
- `system_prompt_hash`
- `prompt_template_id`
- `token_in`
- `token_out`
- `latency_ms`
- `temperature`
- `finish_reason`

### 5. handoff span

代表 agent A 把工作交給 agent B。

這層非常重要，因為很多不合理都發生在 handoff。

建議欄位：

- `from_agent`
- `to_agent`
- `handoff_reason`
- `handoff_payload_summary`
- `expected_output`
- `actual_output_summary`
- `handoff_success`

## 怎麼判斷「調用是否合理」

你真正要觀察的，不只是有沒有調用，而是調用的品質。

可以先從以下幾個維度定規則：

### 1. 是否過度調用

訊號：

- 同一任務中同一 agent 被重複叫很多次
- 相似輸入觸發相同 agent 多次
- 明明前一步已經有答案，還再找一次不同 agent 重做

可能代表：

- routing 規則太鬆
- decision 邏輯不穩定
- agent 職責重疊

### 2. 是否錯誤 handoff

訊號：

- agent A 把工作交給 agent B，但 B 沒有足夠 context
- B 做完之後結果又回到 A 重問一次
- 多個 agent 在做非常相近的分析

可能代表：

- handoff payload 太薄
- 任務切分方式有問題
- agent 邊界定義不清

### 3. 是否高成本低價值

訊號：

- 某 agent/token 消耗很高，但最終輸出只是簡單整理
- 某工具延遲很高，但對最終決策沒有明顯影響
- 反覆查詢同一資料來源

可能代表：

- agent 選型不合理
- 工具調用時機不對
- 缺少快取或前置判斷

### 4. 是否循環或卡住

訊號：

- agent A -> B -> A -> B
- 同一 tool 連續失敗還重試
- 同一推理模式連續出現但沒有任務推進

可能代表：

- 缺少 stop condition
- 缺少 escalation path
- 失敗後 fallback 設計不足

### 5. 是否 context 斷裂

訊號：

- 後續 agent 重問前面已知資訊
- output 沒有承接上一段的關鍵結論
- tool call 明顯缺資料

可能代表：

- memory/context packing 不完整
- handoff schema 太弱
- agent prompt 對前文依賴定義不清

## Phoenix 與 AgentOps 的分工建議

如果你只想先做一版最務實的方案：

### 方案 A：先接 Phoenix

適合：

- 你想先看 trace 與合理性分析
- 你想找出哪個 agent 或哪段流程有問題

做法：

- 把 workflow、agent、tool、llm、handoff 打成 spans
- 先觀察高頻任務類型
- 再比對成功與失敗案例的差異

### 方案 B：Phoenix + AgentOps

適合：

- 你除了診斷，還想看 replay
- 你希望更容易和團隊一起 review 某次 agent 執行

做法：

- `Phoenix` 負責 tracing / diagnosis / evaluation
- `AgentOps` 補 execution replay / session 視角

## 對 Antigravity 的落地建議

如果我是從 `antigravity` 開始接，我會先做最小可行版本：

### 第一階段

- 為每次 workflow 產生唯一 `workflow_id`
- 為每次 agent invocation 打 `agent span`
- 為每次 tool call 打 `tool span`
- 為每次 agent handoff 打 `handoff span`

### 第二階段

- 記錄每次調用的 `reason_for_invocation`
- 記錄 `expected_output` 與 `actual_output_summary`
- 補 token、cost、latency

### 第三階段

- 定義「不合理調用」規則
- 對高頻異常情況做 dashboard 或 alert

## 最值得先收集的欄位

如果你不想一開始埋太多欄位，我建議至少先收：

- `workflow_id`
- `agent_name`
- `agent_role`
- `reason_for_invocation`
- `from_agent`
- `to_agent`
- `tool_name`
- `model`
- `latency_ms`
- `token_in`
- `token_out`
- `cost`
- `result_status`
- `error_type`

這一組欄位已經足夠讓你開始判斷很多「調用合理性」問題。

## 最後建議

如果你的核心問題是：

「我有很多全域 agent，但不知道它們在真實任務中的調用是否合理」

那最推薦的方向不是再找一個更大的 agent UI，而是：

1. 先把每次調用結構化成 trace/span
2. 先接 `Phoenix`
3. 如果需要執行回放，再補 `AgentOps`

這樣你才能真的看到：

- 哪些 agent 被濫用
- 哪些 handoff 沒必要
- 哪些工具調用成本過高
- 哪些 workflow 在重複做同樣的事

## 參考 Repo

- [Arize-ai/phoenix](https://github.com/Arize-ai/phoenix)
- [AgentOps-AI/agentops](https://github.com/AgentOps-AI/agentops)
- [langfuse/langfuse](https://github.com/langfuse/langfuse)
- [openlit/openlit](https://github.com/openlit/openlit)
