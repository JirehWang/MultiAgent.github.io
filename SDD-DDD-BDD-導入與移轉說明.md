# SDD → DDD → BDD 導入與移轉說明

## 1. 文件目的

本文件說明目前已完成的 SDD、DDD、BDD 驗證流程導入方式、架構、使用元件、供應鏈決策，以及如何將同一套設定移轉到另一台電腦。

目前的設計是「依任務風險分級啟用驗證」，不是每個任務都強制執行完整 SDD → DDD → BDD → TDD。

## 2. 最終驗證分級

| 任務類型 | 必要驗證 |
|---|---|
| 簡單問答、文件、機械性修改 | 基本正確性檢查 |
| 單一模組功能或 bug fix | 輕量 SDD＋TDD／最強可行測試＋完成驗證 |
| 多模組、API、資料庫、使用者流程 | SDD＋適用的 DDD／BDD＋TDD＋整合或 E2E 驗證 |
| 金流、權限、合規、安全、高風險變更 | 完整 SDD → DDD → BDD → TDD，並加 review、security／domain gate、整合或 E2E 驗證 |

標準化規則如下：

1. 先由 workflow router 判斷任務類型與風險。
2. 路由完成後，再依高風險 > 多階段 > 標準 > 基本的優先序正規化驗證等級。
3. 保留主要 agent、支援 agent 與 workflow node，但覆寫該等級所需的 gates、artifacts 與 verification scope。
4. 每個驗證階段都必須產生可追溯的證據；若不適用，必須明確記錄 exempted 及理由。

## 3. 各階段實際如何驗證

### SDD：需求與驗收條件

SDD 的目的不是撰寫長規格，而是確認「要解決什麼問題、做到什麼程度、哪些不做」。

必要產物：

- specification：需求、範圍、非目標、限制。
- plan：實作方案、依賴、風險與驗證策略。
- tasks：可執行的工作拆分。
- acceptance-checklist：可觀察、可驗收的條件。

通過標準：

- 每一項範圍內需求都有可觀察的驗收條件。
- 範圍與非目標清楚。
- 沒有會阻斷實作的重大未決歧義。
- 後續測試可以追溯回需求或驗收條件。

目前採用的是本機 `validation-standards` adapter，參考 GitHub Spec Kit Core 的 artifact 形狀；沒有把 Spec Kit CLI 安裝成全域強制依賴。

### DDD：領域模型與架構邊界

DDD 只在任務包含領域規則、不變條件、資料所有權、bounded context、服務拆分或跨服務契約時啟用。

必要產物：

- ubiquitous language：關鍵名詞與定義。
- bounded contexts 與 ownership：哪些模型、資料、責任屬於哪個邊界。
- invariants：不可被破壞的領域規則。
- aggregate boundaries：一致性與交易邊界。
- integration contracts：跨模組或跨服務的交換契約。
- project-native architecture tests：若專案已有架構測試框架，應用測試確認邊界。

通過標準：

- 主要領域規則有明確 owner。
- aggregate／模組邊界與一致性責任清楚。
- API、事件、資料庫或服務契約沒有未解決的 ownership 衝突。
- 架構測試能阻止已知的違規依賴。

目前參考 Context Mapper DSL 的建模概念，以及 ArchUnit／ArchUnitNET 的結構性架構測試概念；上述套件目前沒有安裝。

### BDD：外部行為與使用者情境

BDD 只在使用者流程、外部可觀察行為、服務契約或跨系統互動具有驗證價值時啟用。

必要產物：

- Given／When／Then 形式的 scenario。
- scenario 與 SDD acceptance criteria 的對應關係。
- 失敗情境、權限情境、邊界輸入或錯誤回應。

通過標準：

- 情境描述的是可觀察行為，而非實作細節。
- 正常流程與重要失敗流程都有覆蓋。
- 每個關鍵 scenario 可由專案原生測試 runner 執行，或明確記錄為人工驗證。
- BDD 結果能追溯回需求與驗收條件。

目前參考 Gherkin 的語法與 Cucumber BDD practices，但不強制安裝 Cucumber；優先使用專案原生的 pytest、Jest、Playwright、Cypress 或其他 runner。

## 4. 已架設的本機元件

| 元件 | 位置 | 用途 | 狀態 |
|---|---|---|---|
| Workflow routing rules | `C:\Users\105221\.codex\skills\using-superpowers\agent-routing-rules.yaml` | 任務分級、stage contract、供應鏈政策、路由與狀態欄位 | 已導入 |
| Superpowers workflow instructions | `C:\Users\105221\.codex\skills\using-superpowers\SKILL.md` | 定義先分類、再正規化驗證等級的總流程 | 已導入 |
| Validation standards adapter | `C:\Users\105221\.codex\skills\validation-standards\SKILL.md` | SDD／DDD／BDD 驗證契約與證據格式 | 已導入 |
| Global workflow smoke test | `C:\Users\105221\.codex\skills\validation-standards\scripts\validate_global_workflow.py` | 驗證 YAML、TOML、JSON、路由、stage contract 與供應鏈規則 | 已導入 |
| Workflow router profile | `C:\Users\105221\.codex\agents\workflow-router.toml` | 將 validation-standards 納入全域路由 | 已導入 |
| Global agent/skill map | `C:\Users\105221\.codex\global-agent-map\global-agent-skill-relationship-map.md`、`.json` | 維持 agent、skill、workflow 關聯 | 已導入 |

這次的核心實作是「規則與 adapter」，不是把所有 OSS 工具都裝進全域環境。因此目前不會因為某個專案沒有 Java、.NET 或 Cucumber 而被迫安裝不必要的 runtime。

## 5. 實際使用的套件與未安裝元件

### 已使用

- Python 3.11 標準函式庫 `tomllib`：解析 TOML。
- Python 標準函式庫 `json`、`pathlib`：解析設定與處理路徑。
- `PyYAML`：smoke test 解析 YAML；它是驗證腳本環境依賴，不是被導入到各專案的產品 runtime。

### 已審查但未安裝

| OSS／工具 | 可支援階段 | 目前決策 |
|---|---|---|
| GitHub Spec Kit Core | SDD | 參考標準；未安裝全域 CLI |
| Fission-AI OpenSpec | SDD | 可作較輕量替代；未安裝，若使用須關閉 telemetry |
| Context Mapper DSL | DDD | Java／DDD 建模時可按專案安裝；目前未安裝 |
| ArchUnit | DDD | Java 架構測試；目前未安裝 |
| ArchUnitNET | DDD | .NET 架構測試；目前未安裝 |
| Gherkin | BDD | 情境語法參考；目前未安裝 |
| Cucumber 各語言 runner | BDD | 非強制；優先使用專案原生 runner |

供應鏈基線：只採用已審查的核心 OSS 參考，不採用未審查的 community extension、preset、workflow、schema 或第三方 skill。若未來安裝，應固定版本或 commit、保留 license／notice、檢查 transitive dependencies／SBOM，並先經 skill-gatekeeper 審查。

## 6. 移轉到另一台電腦

### 必須複製的檔案

將以下檔案依相同相對結構複製到目標電腦的 `%USERPROFILE%\.codex`：

```text
skills\using-superpowers\agent-routing-rules.yaml
skills\using-superpowers\SKILL.md
skills\validation-standards\SKILL.md
skills\validation-standards\scripts\validate_global_workflow.py
agents\workflow-router.toml
global-agent-map\global-agent-skill-relationship-map.md
global-agent-map\global-agent-skill-relationship-map.json
```

來源電腦的完整路徑是：

```text
C:\Users\105221\.codex\
```

不要把 `C:\Users\105221` 原樣寫死到另一台電腦；目標機應替換成該使用者自己的 `%USERPROFILE%`。全域 map 若含有絕對路徑，也必須一併改成目標機路徑。

### 目標電腦環境

建議使用：

- Python 3.11 或以上。
- 可匯入 `yaml` 的 PyYAML。
- 已可正常執行 Codex 的 `.codex` 目錄結構。

### 移轉後驗證

在目標電腦執行：

```powershell
py -3.11 "$env:USERPROFILE\.codex\skills\validation-standards\scripts\validate_global_workflow.py"
```

預期結果：

```text
SUMMARY | total=191 passed=191 failed=0
```

若結果不是全數通過，先處理路徑、YAML／TOML／JSON 解析或版本差異，不應先忽略失敗項目。

## 7. 非企業環境可以增加的能力

非企業或個人專案可以增加工具，但建議以「專案級、按需安裝」為原則，不要把全部工具變成全域必需品。

### 建議選項

- SDD：選擇 Spec Kit Core 或 OpenSpec 其中一個。Spec Kit 較完整、流程較嚴謹；OpenSpec 較適合既有系統的小步變更。不要同時把兩套都設成全域主流程。
- DDD：Java 專案可加入 Context Mapper 與 ArchUnit；.NET 專案可加入 ArchUnitNET。若只是小型 CRUD 專案，維持輕量 domain checklist 即可。
- BDD：團隊需要跨角色閱讀 feature file 時，再加入 Gherkin 與對應 Cucumber runner；否則以 pytest、Jest、Playwright 等原生測試搭配 Given／When／Then 情境即可。
- 一般品質：可加入 pre-commit、CI smoke test、coverage、SBOM、OSV／依賴弱點掃描。
- 社群擴充：個人專案可以開放「人工審查後使用」的 community extension lane，但企業基線仍維持禁止未審查擴充。

### 企業與非企業差異

| 控制項 | 企業基線 | 非企業可選方案 |
|---|---|---|
| 版本 | 固定版本／commit | 仍建議固定；可在測試專案先升級 |
| OSS 範圍 | 只用已審查核心 | 可加入人工審查過的社群擴充 |
| SBOM／license | 必須 | 建議加入，尤其要交付或公開時 |
| Telemetry | 預設關閉 | 可依組織政策決定；OpenSpec 建議仍關閉 |
| 驗證深度 | 依風險強制 gate | 可用專案規模縮減，但要保留可追溯性 |

## 8. 官方參考

- [GitHub Spec Kit](https://github.com/github/spec-kit)
- [Spec Kit 文件](https://github.github.com/spec-kit/)
- [OpenSpec](https://github.com/Fission-AI/OpenSpec)
- [Context Mapper DSL](https://github.com/ContextMapper/context-mapper-dsl)
- [ArchUnit](https://github.com/TNG/ArchUnit)
- [ArchUnitNET](https://github.com/TNG/ArchUnitNET)
- [Gherkin](https://github.com/cucumber/gherkin)
- [Cucumber BDD](https://cucumber.io/docs/bdd/)

## 9. 本次完成狀態

- SDD／DDD／BDD 分級規則：已導入。
- 路由後驗證等級正規化：已導入。
- stage contract 與 evidence schema：已導入。
- 供應鏈政策與未審查元件阻擋：已導入。
- 全域 smoke test：已通過 `191/191`。
- Spec Kit、OpenSpec、Context Mapper、ArchUnit、ArchUnitNET、Cucumber：尚未安裝。

這份文件的用途是讓另一台電腦先複製「可控的驗證基線」，之後再依該台電腦的專案技術棧，按需增加工具。
