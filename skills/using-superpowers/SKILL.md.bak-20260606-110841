---
name: using-superpowers
description: Use when starting any conversation, classifying a task into workflow tiers, deciding which skills to invoke, handling coding tasks, or before any response including clarifying questions
---

# Superpowers-ZH 分流路由版

收到任何任务时，先使用本 skill 做入口判断。目标不是把所有流程都变重，而是按任务风险选择合适的 skill 路由。

## 核心规则

1. **先分流，再行动**：任何回应、澄清、读档、编辑、工具调用前，先判断任务情境。
2. **Skill 按情境调用**：只调用当前情境需要的 skill；不要因为列表里有就全部调用。
3. **设计先于编码**：创造性、功能性、行为变更任务先用 `brainstorming`。
4. **测试先于实现**：非 Fast-track 的代码实现或 bugfix 先用 `test-driven-development`。
5. **验证先于完成**：声称完成、已修复、测试通过前必须用 `verification-before-completion`。
6. **用户指令最高优先级**：若用户明确要求暂停、只分析、不改代码、或指定流程，优先遵守。

## 总入口流程

```text
收到任务
→ 使用 using-superpowers 判断情境
→ 判断 Fast-track 或完整 Superpowers Mode
→ 按路由表调用必要 skills
→ 执行任务
→ 完成前验证
```

## Workflow Tier

### Fast-track Mode

适用于影响范围极小、逻辑简单、无副作用的微调任务。

判定准则：

- UI/CSS 微调：颜色、间距、对齐、静态文字。
- 单一文件局部修改：移除小功能、修改单一变量/参数。
- 无副作用修改：不涉及跨文件联动、数据结构、核心业务逻辑、安全性或部署流程。

调用规则：

```text
using-superpowers
→ 必要时 brainstorming
→ 直接小改
→ git diff / 适当验证
→ verification-before-completion
```

Fast-track 可免除详细计划、多智能体派发、完整 TDD，但不得跳过完成前验证。

### 完整 Superpowers Mode

适用于高风险、跨文件联动、需要架构设计或中大型任务。

判定准则：

- 新增功能模块或全新页面/功能区块。
- 前后端、脚本、数据库、API、Sheet、缓存、同步机制等跨系统联动。
- 核心逻辑、架构、安全、权限、数据结构、部署流程变更。
- 用户要求计划、审查、多代理协作、严格 TDD。

调用规则：

```text
using-superpowers
→ brainstorming
→ writing-plans
→ subagent-driven-development（若有多项独立任务或高风险）
→ dispatching-parallel-agents（若 2 个以上任务可并行）
→ executing-plans
→ test-driven-development
→ requesting-code-review
→ verification-before-completion
→ finishing-a-development-branch（仅在分支/PR/merge/cleanup 阶段）
```

完整模式下，开始代码编辑前必须先完成需求分析、计划与必要的 TDD/多智能体安排。

## 情境到 Skill 路由表

| 情境 | 触发条件 | 必须/建议调用 |
|---|---|---|
| 任何任务入口 | 收到新请求、准备回应、准备问澄清问题 | `using-superpowers` |
| 需求探索 / 创造性工作 | 新功能、改流程、UI/UX、组件、行为修改、方案选择 | `brainstorming` |
| 中大型任务计划 | 跨文件、跨系统、高风险、用户要求计划、需求较模糊 | `writing-plans` |
| 执行既有计划 | 已有书面计划，要按步骤实施 | `executing-plans` |
| 多智能体协作 | 完整模式、任务可拆成 PM/Architect/Developer/Reviewer，或高风险需独立审查 | `subagent-driven-development` |
| 并行任务调度 | 2 个以上独立任务，无共享状态或顺序依赖 | `dispatching-parallel-agents` |
| 写功能 / 修 bug / 重构前 | 需要改代码逻辑、业务规则、测试、重构 | `test-driven-development` |
| 除错 / 异常 | bug、测试失败、行为异常、根因不明 | `systematic-debugging` |
| 收到 review 意见 | 用户贴 PR comment、review 反馈、要求处理审查意见 | `receiving-code-review` |
| 完成重要修改后自查 | 重要功能完成、重大修改完成、准备交付前 | `requesting-code-review` |
| 宣称完成前 | 要说完成、已修好、测试通过、可交付 | `verification-before-completion` |
| 分支收尾 | 测试通过后准备 PR、merge、cleanup、发布或整理分支 | `finishing-a-development-branch` |

## 调用组合范例

### 小型 UI/CSS 调整

```text
using-superpowers
→ Fast-track 判断
→ 直接编辑
→ verification-before-completion
```

### 新增一般功能

```text
using-superpowers
→ brainstorming
→ writing-plans
→ test-driven-development
→ requesting-code-review
→ verification-before-completion
```

### 跨系统高风险功能

```text
using-superpowers
→ brainstorming
→ writing-plans
→ subagent-driven-development
→ executing-plans
→ test-driven-development
→ requesting-code-review
→ verification-before-completion
```

### 已有计划要执行

```text
using-superpowers
→ executing-plans
→ test-driven-development（若涉及代码）
→ verification-before-completion
```

### 测试失败或线上异常

```text
using-superpowers
→ systematic-debugging
→ test-driven-development（修复前）
→ verification-before-completion
```

### 收到 code review

```text
using-superpowers
→ receiving-code-review
→ test-driven-development（若需改代码）
→ verification-before-completion
```

## 多智能体协作规范

完整模式下，如平台支持 subagent 工具，按任务需要建立：

- **PM Agent**：分析需求，厘清边界与条件。
- **Architect Agent**：审查系统架构，必要时产出 ADR。
- **Developer Agent**：负责主代码编写，套用适当技能。
- **Reviewer Agent**：负责代码审查与测试验证。

主代理负责统筹子代理结果，确认验证完成后再集成并汇报。

## 避免误用

- 不要在 Fast-track 小改中强制套完整多智能体流程。
- 不要因为 `brainstorming`、`test-driven-development`、`verification-before-completion` 已被本规则提到，就跳过实际 skill；当情境触发时仍要调用。
- 不要在没有 bug 或异常时调用 `systematic-debugging`。
- 不要在没有 review 反馈时调用 `receiving-code-review`。
- 不要在还没完成实现时调用 `finishing-a-development-branch`。
## PowerShell 授权降噪规则

在 Windows / PowerShell 环境中，为减少 Antigravity 反复请求命令授权：

- 读取文件、搜索文字、查看目录时，不要默认加 `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8;` 前缀。
- 优先使用平台原生 file/search 工具；必须使用 shell 时，直接使用 `Get-Content`、`Select-String`、`Get-ChildItem`、`rg`。
- 只有实际出现乱码、编码错误、或用户明确要求修正输出编码时，才临时设置 `[Console]::OutputEncoding`。
- 不要把 `[Console]::OutputEncoding` 与普通读档/搜索命令绑在同一个默认模板里。
- 若只是读取 UTF-8 文件，优先使用 `Get-Content -Encoding UTF8`，不要设置全局 Console 输出编码。

