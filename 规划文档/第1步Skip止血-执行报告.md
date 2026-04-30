# 对话框系统异步安全收敛 — 第1步执行报告

**日期**: 2026-04-30
**来源**: `规划文档/初版.md`

## 修改文件

| 文件 | 改动 |
|------|------|
| `TS/系统/09．表现系统/02．对话框系统/20．对话框渲染-任务回调与命中.ts` | 重写 `fastForwardQueueToLastNormalLine` + Timer 收口 |

## 改动详情

### 1. `fastForwardQueueToLastNormalLine` 收敛

**旧**: `state.queue = [last]` 在 sync=true 回调里直接重写共享队列 -> 高危orate

**新**: 只读 `state.queue[0]`, 不做任何队列修改 (无 `=`, `splice`, `shift`), 只补全当前条目文字并进入 `waitingClick` 状态。

```
旧:
if (state.queue.length <= 1) return;
const last = state.queue[state.queue.length - 1];
if (!last || last.isQuest) return;
state.queue = [last];  // ❌

新:
if (state.queue.length === 0) return;
const entry = state.queue[0];
if (!entry || entry.isQuest) return;
// 只补全文字，不改队列  // ✅
```

### 2. Timer 收口

| 调用点 | 旧 | 新 |
|--------|-----|-----|
| `finishSkipKeyCooldownForPlayer` | `jass.DestroyTimer(t)` | `safeDestroyTimer(t)` |
| `startSkipKeyCooldown` | `jass.TimerStart(t, ...)` | `safeTimerStart(t, ...)` |

`jass.CreateTimer()` 和 `jass.PauseTimer(t)` 按初版.md 允许保留。

引入: `import { safeTimerStart, safeDestroyTimer } from "../../../系统/00．核心系统/07．联机安全工具";`

### 3. `skipDialogLocal` — 未改

- `~` 键保持 `sync=true` (初版.md 要求)
- 多条队列时进 `fastForwardQueueToLastNormalLine` 分支
- 任务条目 skip 路径 (`questIdx >= 0` 分支) 未改

## 不改的

按初版.md §7 要求:
- `runQuestAcceptForPlayer` / `runQuestRejectForPlayer`
- `advanceDialog` / `playEntry` / `skipTyping`
- accept/reject 的 reopen 设计
- `questManager.triggerUIRefresh` 任务 UI 联动桥

## 规则自检

按 `GLOBAL_AGENT_PROMPT.mdc` 和 `.cursor/rules/` 逐项检查:

| 检查项 | 结论 |
|--------|------|
| JASS 回调为具名函数 | ✅ skipKeyCooldownCallbackP0-3, questAccept/RejectCallbackP0-3 |
| 无匿名闭包进 JASS | ✅ 生成 Lua 无箭头或内联 function |
| 无 `pairs()` | ✅ 生成的 Lua 无 pairs 调用 |
| `GetLocalPlayer()` 只在本地显隐 | ✅ showQuestButtons / showDialogFrames / showContinueHintLocal 门控 |
| 无本地分支写共享状态 | ✅ 改后只读 state.queue |

## TSTL 坑专项检查

### 1. no-self / nil 注入

`20.ts` 无 `@noSelfInFile`, 所有函数均被 TSTL 注入 `self` 首参。
exports 函数调用时 TSTL 自动补 `nil` 占位。

检查生成 Lua 中的关键调用:

| 调用 | Lua 生成 | 分析 |
|------|----------|------|
| `dzTimerPause(nil, state.tickTimer)` | nil | 来自 @noSelfInFile 17.ts, TSTL 正确注 nil ✅ |
| `dzSetFont(nil, state.frames[3], ...)` | nil | 同上 ✅ |
| `dzSetText(nil, state.frames[4], ...)` | nil | 同上 ✅ |
| `showDialogFrames(nil, state, true)` | nil | 来自 19.ts, TSTL 正确注 nil ✅ |
| `applyPortraitFrames(nil, entry, ...)` | nil | 同上 ✅ |
| `stringLengthCompat(nil, entry.text)` | nil | 来自 02.ts (无 @noSelf), 预先存在, 非本轮引入 ✅ |
| `safeTimerStart(t, SKIP, false, cb)` | 无 nil | 来自 @noSelfInFile 07.ts ✅ |
| `safeDestroyTimer(t)` | 无 nil | 同上 ✅ |

### 2. stringLengthCompat nil 分析

`02．打字机效果.ts` 无 `@noSelfInFile`, 其 `stringLengthCompat(text)` 只有一个参数。
TSTL 编译后注 nil: `stringLengthCompat(nil, entry.text)`。
运行时 self=nil 被忽略, text=entry.text 正确传入 `jass.StringLength(text)`.
此模式在 20.ts 旧代码中就存在, 运行已久无异常。不是本轮引入。

### 3. 其他确认

- `state.queue[1]` 原生 Lua 数组下标, 无 TSTL 干扰 ✅
- `__TS__ArraySplice` 用于 accept/reject (未改) ✅
- 无 `Math.*` 调用 ✅ rumor

## 完成定义对照

| 初版.md §9 条件 | 状态 |
|-----------------|------|
| 1. 不再出现 `state.queue = [last]` | ✅ |
| 2. skip 链无 splice/shift | ✅ |
| 3. `~` 仍是 sync=true | ✅ |
| 4. skip 冷却 timer 改走 safe* | ✅ |
| 5. 普通对话按 ~ 只补全文字等待继续 | ✅ |
| 6. 任务对话按 ~ 只补全文字显示按钮 | ✅hat
