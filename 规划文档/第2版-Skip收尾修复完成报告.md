# 第2版 Skip 收尾修复 — 完成报告

## 概述

按照《第2版-Skip收尾修复执行文档》完成"直接结束分支"的统一收尾改造。修复了两个直接结束分支未清空 `queue` 和未重置活跃玩家标记的脏状态问题。

## 改动范围

仅修改 1 个文件：`TS/系统/09．表现系统/02．对话框系统/20．对话框渲染-任务回调与命中.ts`

## 具体改动

### 1. 新增统一收尾函数 `finishDialogAndCleanup`

```typescript
function finishDialogAndCleanup(state: PlayerDialogState): void {
  dzTimerPause(state.tickTimer);
  resetActivePlayerIdIfMatch(state.playerId);
  g_questCallbacksByPlayer[state.playerId] = undefined;
  state.queue = [];
  state.currentIndex = 0;
  state.strNow = 0;
  state.strLen = 0;
  onDialogFinished(state);
  showDialogFrames(state, false);
}
```

### 2. 鼠标点击结束分支接入

`handleDialogPanelClick` 中"普通最后一页 + 文本完整 + 点击结束"分支，从旧写法改为 `finishDialogAndCleanup(state)`。

### 3. `~` 结束分支接入

`skipDialogLocal` 中"已在普通最后一页 + 打字完成 → 结束对话"分支，从旧写法改为 `finishDialogAndCleanup(state)`。

## 编译与自检

| 检查项 | 结果 |
|--------|------|
| `npx tstl` 编译 | 通过（无新增 warning） |
| 统一收尾为具名 `local function` | 通过 |
| 鼠标点击结束分支已接入 | 通过（Lua line 252） |
| `~` 结束分支已接入 | 通过（Lua line 419） |
| 收尾包含 `queue = []` + `currentIndex = 0` | 通过 |
| 收尾包含 `resetActivePlayerIdIfMatch` | 通过 |
| 旧的手写 `onDialogFinished` + `showDialogFrames` 不再存在于这两个分支 | 通过 |
