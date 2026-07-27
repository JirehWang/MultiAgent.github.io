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
3. 法規比較是否命中 regulation workflow。
4. 暫時移走一個公司 capability 後，其他 skills 是否仍正常，缺失請求是否回到 global skill pool。

## 8. 更新與回滾

更新前先檢查：

```powershell
git pull --ff-only
git log -1 --oneline
```

建議先將現有 Antigravity skills 備份到日期命名資料夾，再重新複製。
不要把本機的 `.gemini` 憑證、快取或 session 反向提交到本 repository。
