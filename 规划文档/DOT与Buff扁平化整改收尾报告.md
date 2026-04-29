# DOT 与 Buff 扁平化整改收尾报告

## 执行依据

依据 `规划文档/规划-DOT与Buff扁平化整改收尾.md` 执行。

---

## 收尾内容

### 1. DOT flat key 解析严格化

文件：`TS/系统/04．伤害系统/01．DOT定义/04．DOT工具.ts`

**问题**：`parseDotFlatKey()` 使用 `parseInt` 解析 hid 部分，会错误接受 `antiHeal|123abc` 之类 key。

**修复**：新增 `parseStrictPositiveInt()` helper，要求整串必须为十进制数字且 > 0。

```typescript
function parseStrictPositiveInt(s: string): number | null {
  if (s === "") return null;
  for (let i = 0; i < s.length; i++) {
    const ch = s.substring(i, i + 1);
    if (ch < "0" || ch > "9") return null;
  }
  const n = parseInt(s, 10);
  if (isNaN(n) || n <= 0) return null;
  return n;
}
```

`parseDotFlatKey()` 改为调用 `parseStrictPositiveInt(hidStr)` 替代 `parseInt(hidStr, 10)`。

**效果**：`antiHeal|123abc` → 返回 `null`（之前会错误解析 hid=123）。

---

### 2. Buff flat key 解析严格化

文件：`TS/系统/05．Buff系统/00．Buff系统.ts`

**问题**：`parseBuffKey()` 使用 `parseInt` 解析 hid 部分，会错误接受 `123abc|D001` 之类 key。

**修复**：同样新增 `parseStrictPositiveInt()` helper，`parseBuffKey()` 改为调用它。

**效果**：`123abc|D001` → 返回 `null`（之前会错误解析 hid=123）。

---

### 3. `getBuffIdsOnUnit()` 返回稳定排序

文件：`TS/系统/05．Buff系统/00．Buff系统.ts`

**问题**：`getBuffIdsOnUnit()` 直接 `for...in buffByUnitAndId`，返回值依赖 Lua 表的枚举顺序，不稳定。

**修复**：收集完成后按 buffID 字典序排序。

```typescript
out.sort((a, b) => {
  if (a < b) return -1;
  if (a > b) return 1;
  return 0;
});
```

**效果**：`getBuffIdsOnUnit()` 返回值稳定，不暴露对象枚举顺序。

---

## 同轮发现并修复的额外问题

### 4. `pcall(nil, func)` 死代码（HIGH）

**问题**：`(pcall as any)(() => {...})` 被 TSTL 编译为 `pcall(nil, function()...end)`，标准 Lua 中 `nil` 不可调用，内部函数永远不执行。

**修复**：改为具名函数体模式 `pcall(__namedBody)`，与 `00．Buff系统.ts` 中已有模式一致。

- `06．DOT执行器.ts` — `isDotTargetPaused` 中 pcall 改为 `__pcallIsUnitPausedBody`
- `02．dot伤害.ts` — `notifyBuffPool` 中 pcall 改为 `__pcallNotifyBuffPoolBody`

### 5. `self`/`nil` 参数对齐修复（CRITICAL）

**问题**：
- `00．Buff系统.ts` 中 `m.clearDotByBuffPoolExpire(buffID, hid)` 缺少 `nil`，导致参数偏移（`self` 接收 `buffID` 字符串）
- `08．DOT基础工具.ts` 的 `createDotBaseUtils` 缺少 `self`，但调用方按默认行为传 `nil`

**修复**：
- `00．Buff系统.ts` — 先提取 `fn = m.clearDotByBuffPoolExpire` 再 `fn(nil, buffID, hid)`；`syncDotRemainingFromBuffPool` 同理
- `08．DOT基础工具.ts` — 恢复 `createDotBaseUtils(self, deps)` 签名，使内部闭包函数也带 `self`

### 6. 冒号调用修复

**问题**：TSTL 把 `deps.method()` 编译为 `deps:method()` 冒号调用，导致参数偏移。

**修复**：在所有工厂函数中提取 deps 属性到局部变量。

涉及文件：`03．DOT类型定义.ts`、`05．DOT状态同步.ts`、`06．DOT执行器.ts`、`07．DOT施加策略.ts`、`08．DOT基础工具.ts`

---

## 修改文件清单

| 文件 | 修改内容 |
|------|---------|
| `TS/系统/04．伤害系统/01．DOT定义/04．DOT工具.ts` | 新增 `parseStrictPositiveInt`；`parseDotFlatKey` 改用严格解析 |
| `TS/系统/05．Buff系统/00．Buff系统.ts` | 新增 `parseStrictPositiveInt`；`parseBuffKey` 改用严格解析；`getBuffIdsOnUnit` 加稳定排序；`clearDotByBuffPoolExpire`/`syncDotRemainingFromBuffPool` 修复 `self`/`nil` 对齐 |
| `TS/系统/04．伤害系统/01．DOT定义/06．DOT执行器.ts` | pcall 改为具名函数体模式；deps 提取局部变量 |
| `TS/系统/04．伤害系统/02．dot伤害.ts` | pcall 改为具名函数体模式 |
| `TS/系统/04．伤害系统/01．DOT定义/03．DOT类型定义.ts` | deps 提取局部变量 |
| `TS/系统/04．伤害系统/01．DOT定义/05．DOT状态同步.ts` | buffM 方法提取局部变量 |
| `TS/系统/04．伤害系统/01．DOT定义/07．DOT施加策略.ts` | deps 提取局部变量 |
| `TS/系统/04．伤害系统/01．DOT定义/08．DOT基础工具.ts` | deps 提取局部变量 |
| `规划文档/DOT与Buff扁平化改造执行报告.md` | 更新验收状态 |

---

## 验收结果

### 代码层验收

| 验收项 | 状态 | 说明 |
|--------|------|------|
| `parseDotFlatKey()` 不接受 `antiHeal|123abc` | ✅ | 使用 `parseStrictPositiveInt` 严格校验 |
| `parseBuffKey()` 不接受 `123abc|D001` | ✅ | 使用 `parseStrictPositiveInt` 严格校验 |
| `getBuffIdsOnUnit()` 返回值稳定排序 | ✅ | 按 buffID 字典序排序 |
| 不新增 `state[x][y]` 二级结构 | ✅ | 无 |
| 不新增容器 / activeKeys | ✅ | 无 |
| `self`/`nil` 参数对齐 | ✅ | 全部对齐 |
| 无 `pcall(nil, func)` 死代码 | ✅ | 全部改为具名函数体 |
| 无 `deps:` 冒号调用 | ✅ | 全部提取为局部变量 |

### 构建验收

| 验收项 | 状态 | 说明 |
|--------|------|------|
| TSTL 编译通过 | ✅ | 仅有预先存在的 warning |
| `07．装备提取.ts` TS2304 错误 | ⚠️ | 预先存在，非本轮引入 |

### 功能回归

| 验收项 | 状态 | 说明 |
|--------|------|------|
| DOT 叠加、刷新、到期清理 | ⚠️ | 需实机验证 |
| Buff 增加、覆盖、移除 | ⚠️ | 需实机验证 |
| BuffUI 显示 | ⚠️ | 需实机验证 |
| 联机 desync 测试 | ⚠️ | 需实机验证 |

---

## 风险说明

- 严格 key 解析可能导致之前被 `parseInt` 容错接受的脏数据 key 在解析时返回 `null`，进而在 `collectActiveDotPairs()` / `collectActiveBuffPairs()` 中被跳过。但这正是预期行为——脏 key 不应存在。
- `self`/`nil` 对齐修复改变了运行时参数传递，理论上修正了之前的 bug，但需要实机确认行为一致。
- pcall 具名函数体修复使之前被静默吞掉的错误现在能正确执行，可能暴露之前被隐藏的运行时问题。
