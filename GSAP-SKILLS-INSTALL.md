# GSAP Skills 安裝與路由

這個專案內含 GreenSock 官方提供的 GSAP AI Skills，讓 Codex、Claude Code、Cursor 等 AI coding agent 能依照 GSAP 的正確模式產生動畫程式碼。

## 已包含的 Skills

- `gsap-core`：基本 tween、easing、stagger、responsive animation
- `gsap-timeline`：時間軸、動畫排序、巢狀 timeline
- `gsap-scrolltrigger`：滾動觸發、pin、scrub、視差效果
- `gsap-plugins`：Flip、Draggable、Observer、SplitText 等插件
- `gsap-utils`：clamp、mapRange、interpolate、snap 等工具
- `gsap-react`：React／Next.js 的 `useGSAP`、scope 與 cleanup
- `gsap-performance`：transform、batching、will-change 與效能原則
- `gsap-frameworks`：Vue、Svelte 等框架的 lifecycle 與 cleanup

## 在另一台電腦安裝

先複製本專案：

```bash
git clone https://github.com/JirehWang/MultiAgent.github.io.git
cd MultiAgent.github.io
```

將本專案內的 `.codex/skills/gsap-*` 複製到目標 Agent 的全域 Skills 目錄。

### Windows PowerShell（Codex）

```powershell
$target = "$HOME\.codex\skills"
New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item ".codex\skills\gsap-*" -Destination $target -Recurse -Force
```

### macOS／Linux（Codex）

```bash
mkdir -p ~/.codex/skills
cp -R .codex/skills/gsap-* ~/.codex/skills/
```

安裝後重新開啟 Codex 或開始新的任務，讓 Skills 清單重新載入。

## 路由規則

只在以下情境使用 GSAP Skills：

- 產品展示頁、品牌官網或遊戲／互動頁
- 滾動敘事、視差、複雜頁面轉場
- SVG、文字、拖曳或時間軸動畫
- 需要精準排序、同步、倒放或控制多段動畫

一般表單、後台 Dashboard、CRUD 介面、簡單 hover 或淡入淡出，優先使用 CSS 或專案既有動畫框架，不調用 GSAP Skills。

如果專案已經指定 Motion、Framer Motion 或其他動畫框架，應遵守既有技術選擇，不要強行混用 GSAP。

## 執行期套件

這些檔案是給 AI agent 使用的指引，不會自動安裝 GSAP runtime。若程式真的要使用 GSAP，另須在前端專案中安裝：

```bash
npm install gsap @gsap/react
```

GSAP Skills 原始來源：[greensock/gsap-skills](https://github.com/greensock/gsap-skills)
