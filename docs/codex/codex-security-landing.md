# Codex Security 異地落地

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
