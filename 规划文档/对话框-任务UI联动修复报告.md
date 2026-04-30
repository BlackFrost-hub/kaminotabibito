# 对话框-任务UI联动修复报告

**日期**: 2026-04-30
**修改人**: 🤖 Claude Code

## 问题

对话框系统接受/完成任务后，任务UI面板不会自动更新。需要等到下次手动打开面板才显示变化。

### 根因

`TS/系统/09．表现系统/02．对话框系统/09．对话构建.ts` 中的 `refreshTaskUIForAllClientsSoon()` 是空函数体：
```typescript
function refreshTaskUIForAllClientsSoon(): void {
  // 任务UI刷新已由 questManager.registerUIRefreshCallback 自动处理，
  // 不再需要手动调用旧 taskUI.refreshList。
}
```

对话框接受任务时走 `setQuestState()` → `questDB.acceptQuest()`，绕过了 `questManager.onQuestAccepted()`，因此 `questManager.triggerUIRefresh()` 不会被调用。而注释所说的 `registerUIRefreshCallback` 只在 `questManager.onQuestAccepted/onQuestCompleted/onQuestFailed` 内触发，这些方法在对话框路径从未被调用。

### 影响范围haba

- **对话框接受任务** — 任务不出现于UI ✓
- **对话框提交完成任务** — 任务不移除 ✓
- **资源/击杀类任务提交** — 同上 ✓

## 修改列表

### 1. `TS/系统/09．表现系统/02．对话框系统/09．对话构建.ts`

**新增 require** (行30-32):
```typescript
const { questManager } = require("系统.08．任务系统.02．任务管理器.index") as {
  questManager: { triggerUIRefresh: (playerId: number, questId?: string) => void };
};
```

**替换空函数** (行45-48):
```typescript
function refreshTaskUIForAllClientsSoon(playerId: number, questId?: string): void {
  questManager.triggerUIRefresh(playerId, questId);
}
```

**更新调用点** (行194, 行229):
```typescript
// 旧
refreshTaskUIForAllClientsSoon();
// 新
refreshTaskUIForAllClientsSoon(dialogOwnerId, questId);
```

### 2. `TS/系统/09．表现系统/02．对话框系统/12．任务提交流程.ts`

**参数类型** (行169):
```typescript
// 旧
refreshTaskUIForAllClientsSoon: () => void;
// 新
refreshTaskUIForAllClientsSoon: (playerId: number, questId?: string) => void;
```

**调用** (行227):
```typescript
// 旧
refreshTaskUIForAllClientsSoon();
// 新
refreshTaskUIForAllClientsSoon(dialogOwnerId, questId);
```

## 未修改

- `07．任务状态.ts` 的 `setQuestState()` — 纯数据操作，UI 刷新应由调用方触发
- QuestManager 本体 — 保持通过 JASS bridge 接受任务的独立路径不变 equivoc

## 生成 Lua 验证

```
09．对话构建.lua:52-53:
local function refreshTaskUIForAllClientsSoon(self, playerId, questId)
    questManager:triggerUIRefresh(playerId, questId)

09.lua:252 (onAccept):
refreshTaskUIForAllClientsSoon(nil, dialogOwnerId, questId)

12．任务提交流程.lua:307 (onComplete):
refreshTaskUIForAllClientsSoon(nil, dialogOwnerId, questId)
```

## 联机安全分析assurance

| 检查项 | 结论 |
|--------|------|
| `triggerUIRefresh` 全端同步执行 | ✅ 遍历 `uiRefreshCallbacks` 数组，无 `GetLocalPlayer()` 分支控制流程 |
| 回调 `onQuestManagerUiRefresh` 全端对称 | ✅ 设 `pagesDirty`、调 `rebuildPages` 均全端执行 |
| `rebuildPages` → `rebuildTaskUIFacadeListPool` | ✅ 全端同步的帧数据重建，不写共享状态入本地分支 |
| `DzFrameSetText` 在本地路径 | ✅ 不在，所有帧文本创建/更新均在全客户端同步路径 |
| 只显藏分叉 | ✅ `DzFrameShow` 在 `15．任务UI本地显示.ts` 调用，其他全���同步 |
| `require` 绝对路径 | ✅ `系统.08．任务系统.02．任务管理器.index` |
| 匿名闭包 | ✅ 无新增匿名闭包进 JASS |

**风险评估**：低。此改动唯一作用是触发已有的 `questManager.registerUIRefreshCallback` 机制，与 JASS bridge 路径行为一致。
