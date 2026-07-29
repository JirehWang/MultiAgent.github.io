# 在 Google Antigravity 落地本 Repository

本 repository 保存目前的可攜式全域設定：

- `.codex/skills/`：Agent Skills
- `.codex/agents/`：Codex agent profile 參考檔
- `.codex/capabilities/`：專門能力 registry、同步政策與相關腳本
- `.codex/global-agent-map/`：agent／skill 關係圖

不包含登入憑證、session、history、SQLite、logs、attachments、cache，以及公司報告輸出或中間資料。

Google 官方目前將 Antigravity 的全域 skills 位置定義為
`~/.gemini/config/skills/`；Antigravity CLI 另可使用
`~/.gemini/antigravity-cli/skills/`。專案範圍的 skills 可放在
`<project-root>/.agents/skills/`。參考：

- [Authoring Google Antigravity Skills](https://codelabs.developers.google.com/getting-started-with-antigravity-skills)
- [Getting Started with Antigravity IDE](https://codelabs.developers.google.com/getting-started-agy-ide)

## 1. Clone

```powershell
git clone https://github.com/JirehWang/MultiAgent.github.io.git
Set-Location .\MultiAgent.github.io
```

## 2. 安裝到 Antigravity IDE／全域環境

以下命令只安裝一般 skills；`.system` 是 Codex 管理的系統內容，不複製到 Antigravity：

```powershell
$repoRoot = (Resolve-Path .).Path
$skillSource = Join-Path $repoRoot '.codex\skills'
$skillTarget = Join-Path $env:USERPROFILE '.gemini\config\skills'

New-Item -ItemType Directory -Force -Path $skillTarget | Out-Null

Get-ChildItem -LiteralPath $skillSource -Directory |
  Where-Object Name -ne '.system' |
  ForEach-Object {
    $destination = Join-Path $skillTarget $_.Name
    New-Item -ItemType Directory -Force -Path $destination | Out-Null
    Get-ChildItem -LiteralPath $_.FullName -Force |
      Copy-Item -Destination $destination -Recurse -Force
  }
```

## 3. 安裝到 Antigravity CLI

將上一步的 `$skillTarget` 改為：

```powershell
$skillTarget = Join-Path $env:USERPROFILE '.gemini\antigravity-cli\skills'
```

完成後執行 Antigravity 的必要 preflight：

```powershell
agy auth login
agy models
```

確認模型可用後，非互動呼叫應使用 `-p`／`--print`：

```powershell
agy -p "Use using-superpowers to classify this task, then report the selected primary owner."
```

## 4. 只安裝到單一專案

```powershell
$projectRoot = 'D:\path\to\your-project'
$skillTarget = Join-Path $projectRoot '.agents\skills'
```

然後使用第 2 節相同的複製流程。這能避免公司專用或實驗性 skill 影響其他專案。

## 5. Capability registry

Antigravity 原生索引的是 `SKILL.md`。`.codex/capabilities` 是本 repository
額外建立的 routing overlay，不是 Antigravity 的原生資料夾規格。

若要啟用 capability overlay：

1. 將 `.codex/capabilities` 複製到受控位置，例如
   `~/.gemini/config/capabilities/`。
2. 將 `registry.json` 內維護者機器的絕對路徑改成安裝機器上的 skills、
   capabilities 與 agent profile 路徑。
3. 在 `~/.gemini/GEMINI.md` 指定：
   - 先使用 `using-superpowers`
   - 需要專門領域時讀取 capability registry
   - registry 缺失或無效時回到一般 global skill pool
   - 雲端同步前執行 `scripts/Test-CapabilitySync.ps1`
4. 公司 capability 或公司資料情境必須取得該次同步的明確批准。

Codex 的 `.toml` agent profiles 不會自動轉成 Antigravity agent。Antigravity
主要透過 skills 的 frontmatter 與 `GEMINI.md` 規則選路；`.codex/agents`
應視為模型層級、角色邊界與交接契約的參考資料。

## 6. 建議的 GEMINI.md 規則

將以下內容合併到 `~/.gemini/GEMINI.md`：

```markdown
## MultiAgent global routing

- Use `using-superpowers` as the top-level workflow router.
- Select exactly one primary workflow owner and at most two support skills.
- Check the installed capability registry before broad skill fallback when a narrow specialist may exist.
- A single overlapping domain signal is not enough to select another capability.
- If a capability is missing or invalid, fall back to the normal global skill pool without modifying unrelated skills or agents.
- Before any capability-related cloud sync, enforce `sync-policy.json`.
- Company, company-context, and unknown-context sync require explicit user approval for that specific operation.
```

## 7. 驗證

在 repository 根目錄執行：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1
```

安裝後另開一個 Antigravity session，分別測試：

1. 一般程式修改是否命中 coding workflow。
2. Bible devotional 是否命中 devotional workflow。
3. Git／GitHub 任務是否命中版本管理 workflow。
4. 暫時移走一個日常 capability 後，其他 skills 是否仍正常，缺失請求是否回到 global skill pool。

## 8. Codex Security 異地落地

本 repository 已加入 `security-scan-contract`，用來約束安全掃描的範圍、證據、覆蓋率、修復與重掃驗證。它與 Codex Security 官方 CLI/SDK 分工如下：

- `security-scan-contract`：repo 管理的 routing／交接合約，會隨本 repository 的 `.codex/skills` 一起落地。
- `@openai/codex-security`：需要在目標機器另外安裝的 CLI/SDK 與官方掃描 skills。
- `security-auditor`：負責判讀漏洞是否成立，不由掃描器單獨宣稱安全。

### 8.1 前置條件

目標機器需要 Node.js 22+、Python 3.10+、Codex Security 使用權限，以及對待掃描 repository 的授權。掃描結果可能包含原始碼片段與漏洞細節，請使用 repository 外的私密輸出目錄。

### 8.2 從 repository 落地 skills

先在 repository 根目錄執行：

```powershell
git pull --ff-only
powershell -ExecutionPolicy Bypass -File .\scripts\verify.ps1

$repoRoot = (Resolve-Path .).Path
$skillSource = Join-Path $repoRoot '.codex\skills'
$skillTarget = Join-Path $env:USERPROFILE '.gemini\config\skills'

New-Item -ItemType Directory -Force -Path $skillTarget | Out-Null
Get-ChildItem -LiteralPath $skillSource -Directory |
  Where-Object Name -ne '.system' |
  ForEach-Object {
    $destination = Join-Path $skillTarget $_.Name
    New-Item -ItemType Directory -Force -Path $destination | Out-Null
    Get-ChildItem -LiteralPath $_.FullName -Force |
      Copy-Item -Destination $destination -Recurse -Force
  }
```

若只要落地到單一專案，將 `$skillTarget` 改成：

```powershell
$skillTarget = Join-Path $repoRoot '.agents\skills'
```

### 8.3 安裝 Codex Security CLI 與官方 skills

不要把登入憑證、session、SQLite、logs 或 scan results 提交回 repository。可用獨立 prefix 安裝：

```powershell
$toolRoot = Join-Path $env:USERPROFILE 'codex-security-tool'
npm install --prefix $toolRoot @openai/codex-security

$codexSecurity = Join-Path $toolRoot 'node_modules\.bin\codex-security.cmd'
& $codexSecurity --version
& $codexSecurity login
& $codexSecurity skills add
```

若使用 CI，改用 secret manager 提供 `OPENAI_API_KEY`，不要把 key 寫入腳本或 commit。

### 8.4 先 dry-run，再做 diff-first 掃描

```powershell
$scanRoot = (Resolve-Path .).Path
$scanDir = Join-Path $env:TEMP 'codex-security-results'

& $codexSecurity scan $scanRoot --output-dir $scanDir --dry-run
& $codexSecurity scan $scanRoot --output-dir $scanDir --working-tree --base HEAD
```

提交前或 CI 可改成：

```powershell
& $codexSecurity scan $scanRoot --output-dir $scanDir --diff origin/main --head HEAD
```

只有在需要廣泛覆蓋時才使用 `--mode deep`，並設定 `--max-cost`。掃描完成後檢查 `report.md`、`findings.json` 與 `coverage.json`；`coverage` 為 `partial` 或 `unknown` 時，不得宣稱 repository clean。

### 8.5 異地驗證與回滾

驗證順序：

1. `scripts/verify.ps1` 通過。
2. 新 Codex session 能讀取 `security-scan-contract`。
3. `codex-security scan --dry-run` 通過。
4. diff-first 掃描產生 report、findings 與 coverage。
5. 修復後重新掃描，確認原 finding 已被驗證為 resolved 或 fixed。

回滾時先停止使用新 skill，再將目標全域 skills 還原到更新前的備份；repository 變更使用 `git revert <commit>`，不要用 `git reset --hard` 覆蓋其他人的工作。

官方文件：<https://learn.chatgpt.com/docs/security/cli>

## 9. 更新與回滾

更新前先檢查：

```powershell
git pull --ff-only
git log -1 --oneline
```

建議先將現有 Antigravity skills 備份到日期命名資料夾，再重新複製。
不要把本機的 `.gemini` 憑證、快取或 session 反向提交到本 repository。
