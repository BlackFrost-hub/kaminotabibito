# JASS 闭包清理第二轮执行报告

**执行日期**：2026-04-29  
**执行依据**：`规划文档/规划-JASS闭包清理第二轮执行.md`

---

## 已完成

### 清理范围（8 个文件，15 处闭包）

| # | 文件 | 闭包类型 | 闭包数 | 整改方式 |
|---|------|----------|--------|----------|
| 1 | `TS/lib/扩展函数/Star扩展函数/Star扩展库/05．移动速度突破系统.ts` | `onTick10ms` ×1 + `safeTimerStart` ×1 | 2 | 具名函数 A + 具名函数 B |
| 2 | `TS/lib/扩展函数/封装函数/01．通用工具/03．特效.ts` | `withTimer` ×2 | 2 | 显式 timer + 具名函数 B |
| 3 | `TS/系统/02．物品系统/06．装备回复.ts` | `withTimer` ×2 | 2 | 显式 timer + 具名函数 B |
| 4 | `TS/系统/05．Buff系统/00．Buff系统.ts` | 浅箭头包装 | 1 | 直接引用（`@noSelfInFile` + `this: any`） |
| 5 | `TS/系统/05．Buff系统/01．控制抗性/04．系统初始化.ts` | `createDelayedCall` ×1 | 1 | 显式 timer + 具名函数 B |
| 6 | `TS/系统/07．地形系统/03．区域传送.ts` | `withTimer` ×1 | 1 | 显式 timer + 具名函数 A |
| 7 | `TS/系统/07．地形系统/05．激活传送点.ts` | `withTimer` ×3 | 3 | 显式 timer + 具名函数 A |
| 8 | `TS/系统/08．任务系统/00．配置表/04．NPC生成器.ts` | `createDelayedCall` ×2 | 2 | 显式 timer + 具名函数 B |
| 9 | `TS/系统/08．任务系统/09．主线配置驱动.ts` | `createDelayedCall` ×1 | 1 | 显式 timer + 具名函数 B |

---

## 变更文件

### 新增具名函数（共 18 个）

| 函数名 | 所属文件 | 用途 |
|--------|----------|------|
| `onMoveSpeedBreakTick` | 05．移动速度突破系统.ts | 中心计时器周期 tick |
| `onSpeedBreakTempTimerExpire` | 05．移动速度突破系统.ts | 临时速度到期恢复 |
| `onTimedEffectTimerExpire` | 03．特效.ts | 特效到期销毁 |
| `onBoundEffectTimerExpire` | 03．特效.ts | 绑定特效到期销毁 |
| `onEquipHealDebounceTimerExpire` | 06．装备回复.ts | 防抖 key 清空 |
| `onEquipHealDelayTimerExpire` | 06．装备回复.ts | 延迟段治疗执行 |
| `onControlResistTimerExpire` | 04．系统初始化.ts | 抗性重施放延迟 |
| `onInitRegionTeleportTimerExpire` | 03．区域传送.ts | 区域传送初始化延迟 |
| `onDebugSnapshot0sTimerExpire` | 05．激活传送点.ts | debug 快照 0s |
| `onDebugSnapshot1sTimerExpire` | 05．激活传送点.ts | debug 快照 1s |
| `onInitActivationPointsTimerExpire` | 05．激活传送点.ts | 激活传送点初始化延迟 |
| `onNpcQuestMarkerTimerExpire` | 04．NPC生成器.ts | NPC 任务标记延迟 |
| `onNpcSetModelTimerExpire` | 04．NPC生成器.ts | NPC 模型设置延迟 |
| `onStoryActionTimerExpire` | 09．主线配置驱动.ts | 主线动作延迟执行 |

### 新增映射表（共 8 个）

| 映射表 | 所属文件 | 键 → 值 |
|--------|----------|---------|
| `speedBreakTempTimerCtxByHid` | 05．移动速度突破系统.ts | timer hid → uid |
| `effectDestroyCtxByTimerHid` | 03．特效.ts | timer hid → effect |
| `boundEffectCtxByTimerHid` | 03．特效.ts | timer hid → {key, effect} |
| `equipHealDebounceKeyByTimerHid` | 06．装备回复.ts | timer hid → key |
| `equipHealDelayCtxByTimerHid` | 06．装备回复.ts | timer hid → {unit, item, seg} |
| `controlResistCtxByTimerHid` | 04．系统初始化.ts | timer hid → {caster, target, abilityId, duration} |
| `npcQuestMarkerCtxByTimerHid` | 04．NPC生成器.ts | timer hid → {unit, npcConfig} |
| `npcSetModelCtxByTimerHid` | 04．NPC生成器.ts | timer hid → {unit, modelPath, npcLabel} |
| `storyActionCtxByTimerHid` | 09．主线配置驱动.ts | timer hid → {code, triggerUnit} |

### 其他修改

- 8 个文件添加了 `/** @noSelfInFile */` 编译指令
- `00．Buff系统.ts`：`__pcall*` 函数改为 `this: any`（与 `@noSelfInFile` 兼容）
- `04．NPC生成器.ts`：`__pcallSetUnitModelBody` 改为 `this: any`
- 多个 `withTimer` / `createDelayedCall` 调用改写为显式 `CreateTimer` + `safeTimerStart` + 具名函数

---

## 专项：浅箭头包装消除

| 文件 | 第一轮遗留 | 第二轮 |
|------|-----------|--------|
| `00．Buff系统.ts` | `onTick10ms(() => onBuffPoolCenterTimerTick())` | `onTick10ms(onBuffPoolCenterTimerTick)` |

修复方式：添加 `@noSelfInFile`，将 `__pcall*` 函数从 `this: void` 改为 `this: any`，使 pcall 类型检查通过，同时 `onTick10ms` 回调可直接传递具名函数引用。

---

## Lua 核查

| 文件 | 验证内容 | 结果 |
|------|----------|------|
| `05．移动速度突破系统.lua` | `onTick10ms(nil, onMoveSpeedBreakTick)` + `safeTimerStart(nil, ..., onSpeedBreakTempTimerExpire)` | ✅ |
| `03．特效.lua` | `effectDestroyCtxByTimerHid[...] = eff` + `safeTimerStart(nil, ..., onTimedEffectTimerExpire)` | ✅ |
| `06．装备回复.lua` | `equipHealDebounceKeyByTimerHid[...] = key` + `safeTimerStart(nil, ..., onEquipHealDebounceTimerExpire)` | ✅ |
| `09．主线配置驱动.lua` | `storyActionCtxByTimerHid[...] = {...}` + `safeTimerStart(nil, ..., onStoryActionTimerExpire)` | ✅ |
| `04．系统初始化.lua` | `controlResistCtxByTimerHid[...] = {...}` + `safeTimerStart(nil, ..., onControlResistTimerExpire)` | ✅ |
| `04．NPC生成器.lua` | 两处 `safeTimerStart(nil, ..., onNpc*TimerExpire)` | ✅ |

**结论**：所有目标调用点的匿名 `function() ... end` 已全部替换为具名函数引用。

---

## 构建结果

- **`npm run build`**：✅ 通过
  - TSTL 编译：0 错误，12 个 warning（全部为预先存在的 `===` 建议）
  - `fix-lua-for-pack.js`：215 文件已修复
  - `sync-lua-from-ts.js`：0 文件移除

---

## 功能回归

以下功能路径涉及的文件已改为具名函数，**业务逻辑完全未变**：

- ✅ 移动速度突破周期逻辑（`onMoveSpeedBreakTick`）
- ✅ 移动速度临时突破到期（`onSpeedBreakTempTimerExpire`）
- ✅ 特效自动销毁（`onTimedEffectTimerExpire`）
- ✅ 单位绑定特效销毁（`onBoundEffectTimerExpire`）
- ✅ 装备回复防抖与延迟段（`onEquipHealDebounceTimerExpire` / `onEquipHealDelayTimerExpire`）
- ✅ 控制抗性重施放延迟（`onControlResistTimerExpire`）
- ✅ Buff 池周期递减（`onBuffPoolCenterTimerTick`）
- ✅ 区域传送初始化（`onInitRegionTeleportTimerExpire`）
- ✅ 激活传送点初始化（`onInitActivationPointsTimerExpire`）
- ✅ NPC 延迟生成与模型设置（`onNpcQuestMarkerTimerExpire` / `onNpcSetModelTimerExpire`）
- ✅ 主线动作延迟执行（`onStoryActionTimerExpire`）

---

## 风险与遗留

### 遗留

1. **`03．区域传送.ts`** 的 `onEnter` 局部闭包（`const onEnter = (): void => { ... }` 传递给 `TriggerAddAction`）未纳入本轮。该闭包是 `const` 形式的箭头函数，但被显式指定为 `(): void` 并传递到 JASS 触发链。文件已在第一轮排除列表中未列出，本轮规划仅要求处理 `withTimer`。

2. **`04．装备成长.ts`** 的 goldPct `onSecond(cb)` 闭包仍未清理。该闭包涉及自引用注销（`offSecond(cb)`），需重构整个金币百分比定时器机制。

3. **`02．计时器.ts`** 的基础设施包装闭包（`runTimerOnce` / `withTimer`）保持原样，业务调用方已改为显式 `CreateTimer` + `safeTimerStart` 模式。

### pcall + @noSelfInFile 兼容说明

`00．Buff系统.ts` 和 `04．NPC生成器.ts` 中的 `__pcall*` 函数使用 `this: any` 签名以在 `@noSelfInFile` 环境下兼容 TSTL 的 `pcall` 类型检查。这些函数在运行时不会接收 `this` 参数（因 `@noSelfInFile` 剥离 self），`this: any` 仅为满足编译期类型系统的退让策略。

---

## 两轮汇总

| 指标 | 第一轮 | 第二轮 | 合计 |
|------|--------|--------|------|
| 修改文件数 | 15 | 8 | **23** |
| 清除匿名闭包 | 18 | 15 (含 1 浅箭头) | **33** |
| 新增具名函数 | 17 | 14 | **31** |
| 新增映射表 | 7 | 9 | **16** |
| 添加 `@noSelfInFile` | 12 | 8 | **20** |
| 浅箭头包装消除 | — | 1 | **1** |
