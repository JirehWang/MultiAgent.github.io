---
name: architecture-review
description: Use before implementing or reviewing a repository code change, or finalizing a consequential software design, when module ownership, reuse, contracts, dependencies, compatibility, lifecycle, or quality boundaries may be affected; also use when the user explicitly requests an architecture grill or architecture review.
---

# 架構審查

在實作前檢查程式變更是否沿用清楚的責任邊界、既有能力與契約，並為本次變更建立可驗證、不可事後放寬的結果審查條件。這是治理與設計入口，不取代原本的語意實作負責者。

## 使用時機

- 使用者要求建構、修改、新增或刪除程式碼，且可能影響模組責任、共用行為、契約、依賴、相容性、持久資料或高影響品質要求。
- 使用者要求架構設計、架構 grill、重用／重複碼判斷，或依架構條件審查程式變更。
- 使用者提出會決定長期模組／服務邊界、公開契約、共用資料、部署邊界或外部整合的軟體設計，即使尚無程式碼，也先用同一套影響分流。
- 對既有專案的原始碼變更，至少先做輕量分流；不代表每次都要正式 grill。
- 全域路由會對實質的程式碼建構／新增／修改／刪除／重構，以及程式碼 diff 審查，自動載入本 skill 作為 overlay；不需要使用者另外指定或手動開啟。本 skill 不取代路由選定的主要實作／審查負責者。

純問答、純文件工作，以及不影響行為或契約的機械式修改，通常不需啟動正式審查；使用者明確要求時除外。

## 執行步驟

1. **確認範圍。** 摘要預期成果、可觀察行為、明確不包含事項、操作類型（建構／修改／新增／刪除）、目標專案與限制。只詢問無法從專案證據取得、且會改變設計的資訊。
2. **先找證據與重用候選。** 檢查專案架構規則、相關模組、相同業務語意的函式／服務、呼叫點、契約、資料模型與測試。記錄檔案／符號證據；找不到候選時，說明搜尋範圍，不宣稱已證明全專案不存在相似能力。
3. **評估影響與審查深度。** 按架構審查格式的五個面向各評 0–2 分，總分 0–10：範圍與邊界、契約與資料、責任與依賴、相容性與生命週期、風險與未知事項。0–2 分通常不需正式 grill；3–5 分採聚焦式 grill；6–10 分採完整架構 grill。公開／跨服務契約、共用 schema、持久資料、依賴方向、仍有呼叫端的共用能力刪除，以及驗證／授權／隱私等高影響規則，至少觸發聚焦式 grill；責任、遷移、相容或回復未明時升級完整 grill。每個非零分數都附證據或標示未知。觸發聚焦或完整 grill 時，依 Goldfish 角色矩陣啟動 fresh-context、唯讀審查；不需正式 grill 時不啟動 Goldfish。
4. **只 grill 未解的重大決策。** 先利用程式庫證據排除不適用方案，再對每項決策提供 2–3 個可行、互斥的選項及「其他／自行說明」。說明證據、行為、主要取捨與未知事項；有本機證據支持才標示建議。只有使用者才能決定的產品取捨或重大架構取捨，必須等待使用者決定。
5. **記錄架構決策與凍結審查條件。** 將下列八項要求具體化為適用於本次變更的條件：預期成果、責任歸屬、重用判斷、契約、依賴、生命週期、風險與品質、驗收方式。每項條件要有穩定 ID、來源需求／決策、可觀察的通過／失敗條件、證據或檢查方式及負責者。不適用項目記錄理由。實作前呈現並凍結基線。
6. **設定實作閘門。** 只有範圍與必要決策明確、適用條件可驗證且必要檢查已指定時，才標記 `READY_FOR_IMPLEMENTATION`。仍需使用者決策時標記 `NEEDS_CLARIFICATION`；缺少必要專案背景或證據時標記 `BLOCKED`。後兩種狀態下不得開始依賴該決策或證據的實作。
7. **保留既有實作路由。** 審查入口不接管程式碼實作。沿用原本符合領域語意的實作負責者；影響公開／共用 API、事件、schema 或提供端／消費端邊界時，條件式交接既有 API 契約治理流程。只有重大架構設計需要時才使用 architect-deep。
8. **依同一基線審查結果。** 實作後逐條檢查凍結條件，記錄條件 ID、PASS／FAIL／NOT_RUN／BLOCKED／EXEMPTED、證據與發現。總結為 `PASS`、`FAIL` 或 `BLOCKED`。不得因結果不理想而事後降低條件；若設計或範圍改變，重新開啟受影響的決策與條件。

## Goldfish reviewer 觸發與角色選擇

Goldfish 是既有 focused/full architecture grill 的獨立審查執行方式，不是另一套嚴重度，也不接管路由選出的實作負責者。審查在本機證據探索及候選設計／決策資料包完成後進行，時間點在重大設計選擇定案、結果審查條件凍結及實作之前。若後續需求或實作跨越已凍結邊界，只重開受影響的審查面向。

### 執行觸發

- 使用既有 0–10 架構影響分數及強制升級條件：0–2 且無覆寫條件不啟動；3–5 執行聚焦 Goldfish；6–10 或既有完整升級條件執行完整 Goldfish。
- 使用者明確要求獨立／反方設計審查時至少啟動聚焦 Goldfish（除非使用者明確要求完整審查）；不得因此跳過專案證據蒐集。若影響評分或覆寫條件要求完整 grill，仍採完整審查。
- 新建專案以「預計架構」評分。長期產品、多模組、共用資料、部署邊界或外部整合依一般門檻審查；一次性原型／無長期整合的獨立工具不因為是新專案而自動觸發。
- `multi_stage` 或 `high_risk` validation tier 本身不等於 Goldfish 觸發條件；必須有需要審查的設計成果或重大架構決策。純安全稽核與合規比較仍走其領域流程；一般程式碼差異審查仍走 code-review 流程，只有架構影響分流要求 grill 時才加 Goldfish 設計審查。

### reviewer 角色矩陣

角色選擇依[架構審查格式中的 Goldfish 角色矩陣](docs/architecture-review-format.zh-TW.md)。每次觸發固定包含 `Zoom Out`、`Comprehension` 和 `Design Critic`，再依非零影響面向及文件條件加入最少必要角色；相同角色只啟動一次。聚焦審查不啟動整套角色清單。完整審查只有在決策資料包依採納的 reviewer 意見修訂後，才執行中段 `Zoom Out`；`Implementation Readiness`、`Codebase Details`、`Structural Validator` 與 `Style Editor` 仍由各自條件控制，不因審查深度為完整而全部派發。

`Synthesizer` 是彙整步驟，不是額外的設計裁決者：合併重複發現、保留意見分歧與未知，且不刪除缺少反證的 reviewer 發現。只有 reviewer 角色輸出可作為獨立發現；協調者負責呈現與使用者決策，不替 Goldfish 選方案。

### 隔離與失敗處理

- 每個 Goldfish reviewer 使用獨立 fresh context 與唯讀工具，讀取相同版本的最小決策資料包及其角色所需的來源範圍：待審設計、明確約束、必要的已引用程式碼／契約／證據，以及角色檢查規準。若啟動中段 `Zoom Out`，它只讀取修訂後資料包、變更摘要及已採納的 reviewer 建議。不得傳入先前對話或未記錄的主觀假設；reviewer 不能編輯產物、實作或再委派。
- 每項發現須附資料包中的證據位置、影響、未解問題或驗收風險；無證據的結論標為 `UNKNOWN`，不得包裝成缺陷。Synthesizer 保留互相矛盾的證據與意見。
- 若使用者要求不使用子代理，或執行環境無法保證新脈絡／唯讀隔離，標記 Goldfish 為 `NOT_RUN` 並說明原因；不可用同一對話中的自我審查冒充 Goldfish。保留原本適用的領域檢查、使用者決策閘門和風險揭露。

## Jev 與紀錄規則

- 完成本機程式庫證據檢查後，若 grill 有 2–3 個具體、可行且可公平比較的選項，且專案資料政策明確允許外部評估，審查流程應依全域 `skill_overlay_catalog.architecture-review.scorer_cli` 路徑自動呼叫 Jev CLI 一次。以 stdin 傳入符合評分介面的最小化摘要；不得傳原始碼、diff、密鑰、客戶資料、完整對話或本機路徑。只有完成實際清理後才將 `sanitized` 設為 true；資料政策未知時視同不允許。
- 少於兩個合格選項時不呼叫並標示 `ineligible`；資料政策不允許或未確認時標示 `blocked_by_policy`。缺少 Jev 憑證、網路不可用或回應無效時，分數標示為「無法取得」；不得挪用 Jev 路由信心或捏造分數。Jev 結果只是參考，不核准設計，也不取代使用者決策。
- 若本機環境沒有 `TYPESAFE_API_KEY` 或不能連線，CLI 會回傳 `unavailable`；繼續本機審查，不重試，也不阻擋實作流程。
- 預設將本次審查紀錄留在目前工作／任務產物，不自動將生成文件寫入專案。只有長期架構決策且專案已有 ADR 慣例時，才依該慣例新增 ADR。
- 本入口透過 `using-superpowers` 的 `required_skill_overlays` 自動套用於實質程式碼變更與 diff 審查；自動分流屬於 agent 工作流，不等同 CI／GitHub PR 強制檢查。決策與條件紀錄目前仍保留在當前任務，未自動寫入專案或中央資料庫。

## 回覆格式

依階段回報精簡紀錄：

- **分流／設計：** 成果與範圍、操作類型、受影響邊界、分數與證據、審查深度、重用候選與判斷、未解決的使用者決策。
- **實作前：** 已選設計、審查條件基線版本、每個條件的 ID／證據方式，以及 `READY_FOR_IMPLEMENTATION`、`NEEDS_CLARIFICATION` 或 `BLOCKED`。
- **結果審查：** 變更版本／diff 參照、逐條條件結果與證據、`PASS`／`FAIL`／`BLOCKED`、剩餘風險與後續處理。

## 參考文件

- [架構審查格式](docs/architecture-review-format.zh-TW.md)
- [架構審查工作流](docs/architecture-review-workflow.zh-TW.md)
- [架構變更結果審查條件](docs/architecture-result-review-criteria.zh-TW.md)
- [Jev 架構選項評分介面](docs/jev-option-scoring-interface.zh-TW.md)
- [架構審查功能實作藍圖](docs/architecture-review-implementation-blueprint.zh-TW.md)
