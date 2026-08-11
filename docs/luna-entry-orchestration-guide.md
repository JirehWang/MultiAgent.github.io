# Luna 入口與 Sol／Terra 升級路由指南

這份指南說明如何讓 Luna 成為日常工作的預設入口，同時保留 Terra 的 bounded execution 與 Sol 的必要規劃能力。核心目標是：小任務快速完成，只有真的需要拆解或重大決策時才增加控制流程。

## 適用條件

使用這個模型前，先確認平台能辨識三種責任；不需要因此改變 active thread 的模型，也不應為了模擬某個不存在的模型而新增 fallback agent。

- Luna：直接處理狹窄、邊界清楚的工作。
- Terra：執行已定義好的 bounded work packet。
- Sol：只在需要拆解、跨邊界決策、共享 invariant、材料風險或可分離 tracks 時做一次短計畫。

## 預設路由

```text
L0：直接且狹窄的任務       -> Luna
L1：清楚且有邊界的執行包   -> Terra
L2：需要拆解或重大決策     -> Sol 計畫一次，再派送 Luna／Terra
```

### L0／Luna

適合回答、研究、格式整理、單一檔案的明確修改，以及有單一驗證面的低風險工作。Luna 應直接產出結果並執行基本檢查，不應因為任務描述中出現多個步驟就自動建立多 agent 流程。

### L1／Terra

當工作已經可以寫成一個清楚的 packet 時使用 Terra。packet 至少要包含：範圍、非目標、輸出、驗收條件與局部驗證方式。Terra 不重新規劃整個專案，也不把自己的工作再包成另一層 delegation。

### L2／Sol

Sol 的工作是定義 work units、依賴、交接格式與完成條件，然後派送 bounded worker。Sol 不直接實作大型 artifact，也不替 routine worker 重做、修復或重跑全部驗證。

第一次計畫後，只有以下情況才重新進入 Sol：

- 原本的假設被實際結果推翻。
- 缺少關鍵依賴，導致原 work unit 無法執行。
- work-unit 邊界與共享 mutable boundary 發生衝突。

## 何時不應升級

以下情況維持 Luna，不要加入 Sol、Terra reviewer 或額外 agent：

- 使用者的意圖已經清楚。
- 修改範圍只有一個局部表面。
- 驗收可以由執行者在本地證明。
- 沒有共享資料契約、遷移、權限或安全 invariant。
- 沒有跨模組、跨系統或高後果風險。

「看起來更完整」不是升級理由；升級必須由邊界、風險或不可分離的依賴觸發。

## 驗證與審查

路由完成後，再依風險選 validation profile，不要把 reviewer 當成所有任務的固定步驟：

| Profile | 適用範圍 | 最小驗證 |
| --- | --- | --- |
| `basic` | 問答、文件、機械式小修改 | executor-native correctness check |
| `standard` | 單模組功能或 bug fix | focused test／SDD 或 TDD |
| `multi_surface` | 多模組、API、資料庫、user flow | 適用的 DDD／BDD、整合或 E2E |
| `high_risk` | payment、permission、compliance、security、migration | 完整 staged gate chain 與獨立 review |

獨立 Terra review 只在兩種情況加入：

1. acceptance boundary 無法由執行者自行證明。
2. 任務屬於 `multi_surface` 或 `high_risk`，且 validation contract 要求獨立證據。

基本與標準任務不應因為走過 agent router 就自動增加第二個 reviewer。

## Delegation 邊界

可以分工的工作必須具有不重疊的檔案或責任邊界；不要拆分以下內容：

- 共享 mutable contract 或 migration。
- 同一核心演算法的相互依賴修改。
- 權限、安全 invariant 或資料一致性規則。
- 需要同一段私有上下文才能正確完成的工作。

如果無法證明隔離會提高品質，就維持單一 Luna／Terra 執行路徑。

## 配置檢查

調整完成後，至少確認以下內容彼此一致：

- global guidance 把 Luna 定義為 Codex 的直接入口。
- orchestration skill 的 L0／L1／L2 與 model-routing 相同。
- capability map 與 installer 沒有把 Sol 當成 routine executor。
- active thread 的模型不會被路由偷偷改變。
- Antigravity 或其他平台的模型邊界維持獨立，不因 Codex 的 Luna 規則被覆蓋。

## 快速檢查表

- [ ] 直接窄任務從 Luna 開始。
- [ ] Terra 只接收清楚的 bounded packet。
- [ ] Sol 只在材料邊界或決策需要時出現。
- [ ] Sol 計畫最多一次，除非假設、依賴或邊界失效。
- [ ] 基本／標準任務沒有自動獨立 reviewer。
- [ ] 高風險任務仍保留完整驗證與獨立證據。
- [ ] 沒有用另一個 agent 靜默模擬缺失的 Luna 能力。
- [ ] routing、capability map、global guidance 與測試結果一致。
