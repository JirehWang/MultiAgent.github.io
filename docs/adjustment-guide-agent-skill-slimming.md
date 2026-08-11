# Agent／Skill 精簡與 Luna 入口調整指南

這份指南用來調整個人或團隊的全域 agent／skill 配置，目標是降低每次任務的載入與驗證成本，同時保留必要的準確性與風險防護。

適用於：

- 全域 skill 太多，日常任務被低頻專業能力干擾。
- 多個 skill 都在做分工、規劃或審查，造成重複路由。
- 每個小任務都被升級成多 agent 或完整驗證流程。
- 想讓 Luna 成為直接工作的入口，但不希望改動既有 Luna 執行能力。

不適用於：

- 只想刪除單一專案中的未使用依賴。
- 尚未知道現有 agent、skill、pack 之間的路由關係。
- 需要改變模型、權限、MCP 或平台私有設定的工作；那些應另行評估。

## 1. 先分清楚三件事

調整前先把下列三層分開，避免把「可用」誤當成「每次都要載入」：

1. **Source**：中央 repository 中保留的 skill／agent 原始檔。
2. **Default mount**：平台啟動時預設可見、可被一般路由直接使用的能力。
3. **Opt-in**：仍保留在 source，但只有任務明確需要時才掛載或啟用的能力。

第一階段建議只調整 default mount 與路由，不刪 source。這樣可以先觀察實際使用率，回滾也只需恢復 manifest 或重新掛載。

## 2. 建立最小入口模型

將執行流程分成入口、 bounded executor、規劃控制面三層：

| 層級 | 何時使用 | 責任 | 不應做的事 |
| --- | --- | --- | --- |
| **Luna** | 直接、狹窄、邊界清楚的工作 | 直接完成工作與基本檢查 | 不為小任務建立多 agent 流程 |
| **Terra** | 已切好的 bounded work packet | 執行明確範圍、產出與局部驗證 | 不重新規劃整個專案 |
| **Sol** | 需要拆分、跨邊界決策、共享 invariant、材料風險或可分離 tracks | 做一次短計畫、定義 work units、派送與回收結果 | 不直接實作大型 artifact |

建議的預設判斷：

```text
直接且狹窄       -> Luna
已知邊界的執行包 -> Terra
需要拆解或重大決策 -> Sol 計畫一次，再回到 Terra／Luna 執行
```

Sol 只在必要時出現；同一任務不要因為「看起來比較完整」而重複進入 Sol。只有假設被推翻、依賴缺失或 work-unit 邊界失效時，才重新規劃。

### 如何確認 Luna 不需要再改

如果現有設定已符合以下條件，Luna 部分先保持不動：

- 直接窄任務可以從 Luna 開始。
- Terra 有清楚的 bounded packet 定義。
- Sol 只負責規劃／派送，不會接管實作。
- 目前工作執行不會偷偷改變 active thread 的模型或建立額外可見任務。
- 基本與標準任務使用 executor-native check，不會自動觸發獨立審查。

這種情況下，應優先精簡重複 skill、預設掛載與驗證分支，而不是再增加 Luna 的控制規則。

## 3. 重新評估 skill 與 agent

逐一檢查每個能力的「使用頻率、上下文成本、風險價值、路由重疊」。

| 分類 | 放置方式 | 判斷條件 |
| --- | --- | --- |
| 高頻基礎能力 | Default | 跨多數任務都會用，且載入成本低 |
| 低頻專業能力 | Opt-in | 只在明確領域或明確指令出現時使用 |
| 重複控制能力 | 合併 | 多個 skill 都在做拆解、派送、規劃或審查 |
| 過時能力 | 延後刪除 | 無有效路由、無使用者、已有可靠替代物 |
| Agent profile | 暫不刪除 | 仍被 model-routing、adapter 或 pack 引用 |

第一階段通常不刪 agent profile。先移除無效路由與低頻 skill 的 default mount；等一段時間確認沒有引用，再做第二階段清理。

### 常見的合併方式

- 將平行分工、task decomposition、subagent execution 合併成一個 `delegation` skill。
- 將 UI strategy、visual preset、特殊設計風格改成 opt-in overlay，保留一個日常 UI default skill。
- 將完整輸出、project loop、重型規劃流程改為明確觸發，不要讓小任務自動載入。

合併後的 skill 只保留：觸發條件、分工規則、邊界、交接格式與最小驗證。詳細背景或大型 reference 應移到獨立 reference 檔案。

## 4. 用 manifest 控制 default 與 opt-in

不要讓 installer 直接掃描整個 `core/skills`。在中央 manifest 中明確列出兩組清單：

```json
{
  "core": {
    "default_skills": ["using-superpowers", "model-routing", "delegation"],
    "opt_in_skills": ["task-decomposition", "web-design-polish"]
  }
}
```

維護規則：

1. default 與 opt-in 必須完整覆蓋 source 目錄，且不得重複。
2. installer 預設只掛載 `default_skills`。
3. 需要特殊能力時，使用明確的 opt-in 參數或專案 pack。
4. 受管理的舊 opt-in platform link 可以移除，但 unmanaged 目錄應保留並警告。
5. Windows junction 不要用 `Move-Item` 當作刪除 link 的方式；先驗證 link target，再只移除 junction 本身，中央 source 保留作為回復點。

目前 repository 的對應實作是：

```powershell
.\scripts\Install-PlatformLinks.ps1 -Platform All -DryRun
.\scripts\Install-PlatformLinks.ps1 -Platform All
.\scripts\Install-PlatformLinks.ps1 -Platform All -IncludeOptInSkills
```

先執行 `-DryRun` 檢查數量與目標，再套用實際連結。

## 5. 驗證要分層，不要全部都做

精簡的目的不是取消驗證，而是讓驗證與風險匹配：

| 任務風險 | 驗證方式 |
| --- | --- |
| basic | executor-native check；不啟動獨立 reviewer |
| standard | 針對模組或 bug 的 focused test |
| multi_surface | 需要時加入 DDD／BDD 與整合檢查 |
| high_risk | 完整 staged gate chain、獨立 review 與安全／領域檢查 |

只有在 acceptance boundary 無法由執行者自行證明，或任務屬於 `multi_surface`／`high_risk` 時，才增加獨立 Terra review。不要因為使用了 agent 就自動加一輪 reviewer。

一次調整的最低驗證集合：

1. manifest coverage test：default＋opt-in 完整覆蓋 source。
2. central layout test：skill、profile、adapter 數量與必要檔案正確。
3. platform-link test：default link 指向中央 source，opt-in 不會被預設掛載。
4. model-routing test：Luna／Terra／Sol 邊界與 fallback 不互相矛盾。
5. 一次完整 central verification；不要每改一個文字檔就重跑整套高成本驗證。

## 6. 調整後的觀察與回滾

至少觀察一段實際使用週期，再決定是否進入第二階段：

- opt-in skill 若在多個不相關任務中反覆被需要，可提升為 default。
- 長期沒有明確觸發的 skill，維持 opt-in 或移入專案 pack。
- 若兩個 skill 的觸發條件、輸出與驗證高度重疊，優先合併，不要新增第三個 router。
- agent profile 只有在確認沒有 adapter、routing、pack 或文件引用後才移除。

回滾順序：

1. 恢復 `CENTRAL_MANIFEST.json` 的 default／opt-in 分類。
2. 重新執行 platform-link installer。
3. 若路由行為仍不一致，再恢復 routing、capability map 與測試檔。
4. 保留 source 與 platform-link backup，直到新配置完成一個觀察週期。

## 快速檢查表

- [ ] 我知道每個 skill 是 source、default 還是 opt-in。
- [ ] 我沒有為了小任務新增 Sol 或獨立 reviewer。
- [ ] Luna 仍是直接窄任務入口，Terra 與 Sol 的升級條件清楚。
- [ ] default／opt-in 清單沒有重複或遺漏。
- [ ] installer 不再掃描並掛載全部 source skill。
- [ ] opt-in source 尚未被物理刪除。
- [ ] 驗證依風險分層，沒有無產能的重複檢查。
- [ ] 完成一次 central verification，並記錄可回滾位置。
