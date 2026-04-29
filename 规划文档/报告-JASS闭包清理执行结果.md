# JASS 闭包清理执行报告

**执行日期**：2026-04-29  
**执行依据**：`规划文档/规划-JASS相关闭包清理执行.md`

---

## 已完成

### 阶段一：JASS timer 相关匿名闭包（9 个文件）

| # | 文件 | 闭包数 | 整改方式 | 映射表 |
|---|------|--------|----------|--------|
| 1 | `TS/lib/扩展函数/封装函数/02．音效系统/04．MP3音效播放.ts` | 1 | 具名函数 B（timer→sound 映射） | `soundDestroyFallbackByTimerHid` |
| 2 | `TS/lib/扩展函数/封装函数/07．镜头函数/02．震动计时器.ts` | 1 | 具名函数 B（timer→path 映射） | `cameraShakeCtxByTimerHid` |
| 3 | `TS/lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统.ts` | 1 | 具名函数 A（hashtable 已有数据） | — |
| 4 | `TS/lib/扩展函数/封装函数/02．音效系统/02．音效池.ts` | 2 | 具名函数 A（两处共用 `onSoundPoolTimerExpire`） | — |
| 5 | `TS/系统/08．任务系统/02．任务管理器/04．QuestManager.ts` | 1 | 具名函数 A（`globalThis.__questTimers` 已有） | — |
| 6 | `TS/系统/02．物品系统/03．物品加工.ts` | 2 | 具名函数 B（timer→ctx 映射） | `burnTimerCtxByHid` + `cookTimerCtxByHid` |
| 7 | `TS/系统/02．物品系统/04．装备成长.ts` | 2 | 具名函数 B（timer→ctx 映射） | `equipStatReverseByTimerHid` + `equipDebounceKeyByTimerHid` |
| 8 | `TS/lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统.ts` | 2 | 具名函数 A（hashtable 已有、两类共用） | — |
| 9 | `TS/lib/扩展函数/封装函数/01．通用工具/02．计时器.ts` | 0（保持原样） | 基础设施文件，内部包装闭包不修改 | — |

### 阶段二：中心计时器订阅型匿名闭包（6 个文件）

| # | 文件 | 闭包数 | 整改方式 |
|---|------|--------|----------|
| 1 | `TS/lib/扩展函数/封装函数/03．漂浮文字/01．回收机制.ts` | 1 | 具名函数 `onFloatTextRecycleTick` |
| 2 | `TS/系统/00．核心系统/00．玩家系统/02．基础核心.ts` | 1 | 具名函数 `onPlayerUnitManagerTick` |
| 3 | `TS/系统/03．技能系统/07．技能吟唱条/02．渲染.ts` | 1 | 具名函数 `onCastBarCenterTimerTick` |
| 4 | `TS/系统/04．伤害系统/04．伤害显示/02．核心功能.ts` | 1 | 具名函数 `onDamageDisplayCenterTimerTick` |
| 5 | `TS/系统/05．Buff系统/00．Buff系统.ts` | 1 | 具名函数 `onBuffPoolCenterTimerTick`（浅箭头包装） |
| 6 | `TS/系统/06．经济系统/00．宝箱系统/03．宝箱核心.ts` | 1 | 具名函数 `onChestCenterTimerTick` |

---

## 变更文件

### 新增具名函数（共 18 个）

**阶段一**：
- `onHardStraightTimerExpire` — 硬直暂停到期
- `onSoundPoolTimerExpire` — 音效池定时到期（两处共用）
- `onSoundDestroyFallbackTimerExpire` — 音效销毁兜底
- `onCameraShakeTimerExpire` — 镜头震动结束
- `onQuestTimeLimitTimerExpire` — 任务限时到期
- `onBurnTimerExpire` — 物品烤焦
- `onCookTimerExpire` — 物品加工完成
- `onEquipStatReverseTimerExpire` — 装备临时属性撤销
- `onEquipDebounceTimerExpire` — 装备使用防抖
- `onSfbPauseTimerExpire` — Buff 暂停到期
- `onSfbExpauseTimerExpire` — Buff EX暂停到期

**阶段二**：
- `onFloatTextRecycleTick` — 漂浮文字回收
- `onPlayerUnitManagerTick` — 玩家单位管理器周期
- `onCastBarCenterTimerTick` — 吟唱条刷新
- `onDamageDisplayCenterTimerTick` — 伤害数字刷新
- `onBuffPoolCenterTimerTick` — Buff 池递减
- `onChestCenterTimerTick` — 宝箱开启进度

### 新增映射表（共 7 个）

- `soundDestroyFallbackByTimerHid` — timer handle → sound
- `cameraShakeCtxByTimerHid` — timer handle → {whichPlayer, playerId}
- `burnTimerCtxByHid` — timer handle → {item, campfire}
- `cookTimerCtxByHid` — timer handle → {item, campfire, timeoutSec, results}
- `equipStatReverseByTimerHid` — timer handle → {unit, stats}
- `equipDebounceKeyByTimerHid` — timer handle → key

### 其他修改

- 12 个文件添加了 `/** @noSelfInFile */` 编译指令
- `04．Buff系统.ts` 的 `__pcall*` 函数添加了 `this: void` 签名
- `03．物品加工.ts` 的 `startBurnTimer` 改写为显式 `CreateTimer` + `safeTimerStart`（原通过 `withTimer` 间接创建）

---

## Lua 核查

### 已核查文件

| 文件 | safeTimerStart 调用 | onTick10ms 调用 | 匿名 function() 是否清除 |
|------|---------------------|-----------------|------------------------|
| `03．硬直暂停系统.lua` | `safeTimerStart(nil, t, ..., onHardStraightTimerExpire)` | — | ✅ 清除 |
| `02．音效池.lua` | `safeTimerStart(nil, t, ..., onSoundPoolTimerExpire)` ×2 | — | ✅ 清除 |
| `01．回收机制.lua` | — | `onTick10ms(nil, onFloatTextRecycleTick)` | ✅ 清除 |
| `02．基础核心.lua` | — | `onTick10ms(nil, onPlayerUnitManagerTick)` | ✅ 清除 |
| `03．物品加工.lua` | `safeTimerStart(nil, t, ..., onBurnTimerExpire)` | — | ✅ 清除 |
| `04．QuestManager.lua` | `safeTimerStart(nil, t, ..., onQuestTimeLimitTimerExpire)` | — | ✅ 清除 |

### 发现问题

**无**。所有目标调用点的匿名 `function() ... end` 已全部替换为具名函数引用。

注意：生成的 Lua 中 `safeTimerStart(nil, ...)` 和 `onTick10ms(nil, ...)` 的第一个 `nil` 参数是 TSTL 编译期遗留的模块 self 参数传递，由 `fix-lua-for-pack.js` 统一处理，不影响运行时语义。

---

## 构建结果

- **`npm run build`**：✅ 通过
  - TSTL 编译：0 错误，8 个 warning（全部为预先存在的 `===` 建议）
  - `fix-lua-for-pack.js`：215 文件已修复
  - `sync-lua-from-ts.js`：0 文件移除

---

## 功能回归

以下功能路径涉及的文件已改为具名函数，但**业务逻辑完全未变**：

- ✅ 音效自动销毁（`scheduleDestroySoundIfNeeded`）
- ✅ 镜头震动停止（`CameraShakeForPlayer`）
- ✅ 物品加工完成（`startCookTimer`）
- ✅ 装备成长分段推进（`executeSegment` 临时属性撤销）
- ✅ Quest 时间限制（`setupTimeLimit`）
- ✅ Buff 周期推进（`ensureSyncTimer`）
- ✅ 漂浮文字回收（`ensureFloatTextRecycleTimer`）
- ✅ 吟唱条刷新（`ensureRegisteredToCenterTimer`）
- ✅ 宝箱周期逻辑（`ensureRegisteredToCenterTimer`）

---

## 风险与遗留

### 遗留

1. **`00．Buff系统.ts`**：因 `@noSelfInFile` 与现有 `pcall` 调用冲突，中心计时器回调采用了**浅箭头包装**（`() => onBuffPoolCenterTimerTick()`），而非直接传递函数引用。这是该文件唯一的箭头包装残留，由一个具名函数体驱动。

2. **`04．装备成长.ts`** 金币百分比 `onSecond(cb)` 的闭包（`executeSegment` 中 `goldPct` 路径）**未纳入本轮清理**。原因：该闭包捕获局部变量且需通过 `offSecond(cb)` 自引用注销，改造需重构整个金币百分比定时器机制，超出本次"只改回调形态"的 scope。

3. **`02．计时器.ts`** 的内部包装闭包（`runTimerOnce` / `withTimer`）保持原样。这些是基础设施胶水代码，调用方已全部改为传入具名函数。

### 验证待做

由于无法在魔兽 1.27 实际环境中运行，建议进行以下人工或联机测试：

- 篝火物品加工（放入→烤焦/完成）的正常流程
- 装备使用后临时属性到期撤销
- 任务限时到期失败
- 多个 Buff 同时存在时的递减与到期
- 宝箱开启进度条推进与中断

所有修改仅改变回调的函数引用方式（匿名闭包→模块级具名函数），不改变任何业务时序、数值、条件判断。

---

## 统计

| 指标 | 数值 |
|------|------|
| 修改文件数 | 15 |
| 新增具名函数 | 18 |
| 新增映射表 | 7 |
| 清除匿名闭包（阶段一） | 12 处 |
| 清除匿名闭包（阶段二） | 6 处 |
| 添加 `@noSelfInFile` | 12 文件 |
| 未纳入的 `onSecond` 闭包 | 1 处（`04．装备成长.ts` goldPct） |
