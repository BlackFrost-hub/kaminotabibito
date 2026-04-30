# 第2版 Skip 收尾修复执行文档

## 目标

修复本轮审查发现的收尾缺口：

- 普通最后一页鼠标点击结束对话时，必须完整清理状态
- 普通最后一页按 `~` 结束对话时，必须完整清理状态

本次只修“直接结束分支的完整收尾”，不重做 `currentIndex` 方案，不扩展到 accept/reject 链。

## 问题说明

当前 [20．对话框渲染-任务回调与命中.ts](/C:/Users/Administrator/Desktop/syzl/TS/系统/09．表现系统/02．对话框系统/20．对话框渲染-任务回调与命中.ts:158) 的两个直接结束分支只做了：

- `onDialogFinished(state)`
- `showDialogFrames(state, false)`

这样会留下两类脏状态：

1. `state.queue` 没有清空，后续新对话可能无法重新起播
2. `g_activePlayerFlags[playerId]` 没有清理，活跃玩家同步标记残留

## 修改范围

只改 1 个文件：

- `TS/系统/09．表现系统/02．对话框系统/20．对话框渲染-任务回调与命中.ts`

## 执行要求

### 1. 抽一个“直接结束对话”的统一收尾函数

在 `20．对话框渲染-任务回调与命中.ts` 内新增一个小函数，职责固定为：

- `dzTimerPause(state.tickTimer)`
- `resetActivePlayerIdIfMatch(state.playerId)`
- `g_questCallbacksByPlayer[state.playerId] = undefined`
- `state.queue = []`
- `state.currentIndex = 0`
- `state.strNow = 0`
- `state.strLen = 0`
- `onDialogFinished(state)`
- `showDialogFrames(state, false)`

说明：

- 这里就是“普通最后页直接结束”的完整收尾
- 不要只隐藏 UI
- 不要遗漏 `queue` 清空和 `currentIndex` 重置

### 2. 鼠标点击结束分支改走统一收尾

修改 `handleDialogPanelClick(state)`：

- 当“普通页 + 已是最后一页 + 文本完整 + 点击结束”时
- 不再直接写 `onDialogFinished(state)` / `showDialogFrames(state, false)`
- 改为调用上面新增的统一收尾函数

### 3. `~` 结束分支改走统一收尾

修改 `skipDialogLocal()`：

- 当“当前已在普通最后一页，且本次 `~` 需要结束对话”时
- 不再直接写 `onDialogFinished(state)` / `showDialogFrames(state, false)`
- 改为调用统一收尾函数

## 非目标

本轮不要顺手改这些内容：

- 不改 `currentIndex` 主体设计
- 不改 `skip` 跳任务页/跳最后页逻辑
- 不改 accept/reject 的 `splice` 策略
- 不改任务 UI 刷新桥
- 不改 `sync=true` 注册方式

## 完成定义

满足以下条件才算完成：

1. 普通最后一页鼠标点击结束后，旧 `queue` 被清空
2. 普通最后一页按 `~` 结束后，旧 `queue` 被清空
3. 两个结束分支都会重置 `currentIndex = 0`
4. 两个结束分支都会执行 `resetActivePlayerIdIfMatch(state.playerId)`
5. 代码中不再存在这两个分支直接手写 `onDialogFinished(state)` + `showDialogFrames(state, false)` 的旧写法

## 验证

### 代码检查

检查 [20．对话框渲染-任务回调与命中.ts](/C:/Users/Administrator/Desktop/syzl/TS/系统/09．表现系统/02．对话框系统/20．对话框渲染-任务回调与命中.ts:1)：

- 最后页鼠标点击结束分支走统一收尾
- 最后页 `~` 结束分支走统一收尾
- 统一收尾里包含 `queue = []` 和 `currentIndex = 0`

### 行为检查

至少确认这 3 个场景：

1. 普通多页对话，点到最后一页后鼠标点击结束，再次点 NPC 能正常重新打开新对话
2. 普通多页对话，`~` 跳到最后一页，再按 `~` 结束，再次点 NPC 能正常重新打开新对话
3. 结束后不会残留“活跃对话玩家”状态

## 交付要求

执行完成后，提交一份简短完成报告，至少写清楚：

- 改了哪个统一收尾函数
- 鼠标点击结束分支是否已接入
- `~` 结束分支是否已接入
- 是否验证了“结束后再次打开 NPC 对话”
