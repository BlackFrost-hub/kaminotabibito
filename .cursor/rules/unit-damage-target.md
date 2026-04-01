# UnitDamageTarget 参数与伤害类型（项目参考）

`GetEventDamageSource()` 必须在受伤事件**同步阶段**立刻调用，不可在 Timer 延后里调用，否则会被后续事件覆盖。  
本项目已在 `01．伤害事件.ts` 的 `onAnyUnitDamagedAction` 里同步快照为 `entry.source`，通过回调参数传递，**不要再从 `udg_TempUnit[6]` 或 jass 全局读取来源**。

## 参数说明

| 参数位置 | 示例值 | 含义 |
|---------|--------|------|
| 1 | 单位 | 伤害来源 |
| 2 | 单位 | 伤害目标 |
| 3 | 实数 | 伤害量 |
| 4 | false | **是否攻击伤害**（true=普攻/远程触发类，false=纯法术/技能） |
| 5 | false | **是否远程攻击**（true=远程，false=近战，仅第4参为true时有效） |
| 6 | 见下方 | **攻击类型**：`ATTACK_TYPE_NORMAL` = 技能伤害；普攻一般用 `ATTACK_TYPE_MELEE`/`RANGED` |
| 7 | 见下表 | **伤害类型**（属性：普通/火/冰/精神等，决定显示文字与抗性） |
| 8 | WEAPON_TYPE_WHOKNOWS | 武器类型（通常填 WHOKNOWS） |

> **注意**：第 4、5 参是「是否攻击/远程」标记，**不是** burst/explosive。  
> **技能伤害由第 6 参决定**：`ATTACK_TYPE_NORMAL` = 技能类攻击类型。

## 示例

```jass
// 技能火焰伤害（非攻击）
UnitDamageTarget(src, tgt, 50.0, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)

// 普通攻击伤害（近战）
UnitDamageTarget(src, tgt, 30.0, true, false, ATTACK_TYPE_MELEE, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
```

## 伤害类型（第 7 参）可用值

| 常量 | 说明 |
|------|------|
| DAMAGE_TYPE_NORMAL | 普通伤害 |
| DAMAGE_TYPE_ENHANCED | 强化伤害（无视部分护甲） |
| DAMAGE_TYPE_FIRE | 火焰伤害 |
| DAMAGE_TYPE_COLD | 冰霜伤害 |
| DAMAGE_TYPE_LIGHTNING | 闪电伤害 |
| DAMAGE_TYPE_POISON | 毒素伤害 |
| DAMAGE_TYPE_DISEASE | 疾病伤害 |
| DAMAGE_TYPE_DIVINE | 神圣伤害 |
| DAMAGE_TYPE_MAGIC | 魔法伤害 |
| DAMAGE_TYPE_SONIC | 音波伤害 |
| DAMAGE_TYPE_ACID | 酸液伤害（金属性） |
| DAMAGE_TYPE_FORCE | 力量伤害 |
| DAMAGE_TYPE_DEATH | 死亡伤害 |
| DAMAGE_TYPE_MIND | 精神伤害（真实伤害） |
| DAMAGE_TYPE_PLANT | 植物伤害 |
| DAMAGE_TYPE_SLOW_POISON | 慢性毒素 |
| DAMAGE_TYPE_SHADOW_STRIKE | 暗影突袭 |
| DAMAGE_TYPE_UNIVERSAL | 通用伤害 |

## 本项目 TS 侧造成伤害的正确流程

1. （可选，Lua/DOT 等脚本伤害）在 `UnitDamageTarget` **之前**调用 `damageEventModule.setNextDamageTypeOverride(n)`，把数值压入队列，事件里会作为 `entry.damageTypeOverride` 传给回调（与引擎 japi 查询解耦）。**这不是**旧的「merged 位图」；普攻与否不由该数值推断。
2. 如是 DOT 秒跳伤害，调用 `damageEventModule.markNextPendingDamageAsDotTickBatch()`（须在受伤事件同步阶段与 override 队列对齐 `shift`）。
3. 调用 `(jass as any).UnitDamageTarget(src, tgt, amount, false, false, ATTACK_TYPE_NORMAL, cfg.damageType, WEAPON_TYPE_WHOKNOWS)`（参数含义见上表）。

伤害展示与逻辑分类（火/冰/精神/普攻等）：在 **jass 事件同步上下文**用 `08．伤害函数.ts`（`YDWEIsEventDamageType`、`isMagicDamage`、`isNormalAttack` 等）；`registerDamageCallback` 会收到快照后的 **`source`（第 5 参）与 `isNormalAttack`（第 6 参）**，不要在延后回调里依赖 `merged` 位运算或 `udg_TempUnit[6]`。
