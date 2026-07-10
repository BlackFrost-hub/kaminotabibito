---
description: JASS 全局数组在 TS 里的最小约定
---

# JASS 全局数组

## 统一写法

- 与 JASS 共用的数组，统一用：
  - 读：`(jass as any).udg_XXX[index]`
  - 写：`(jass as any).udg_XXX[index] = value`

## 不要这样写

- `g.udg_TempReal[index]`
- `g.udg_TempUnit[index]`
- `jass.globals.udg_XXX[index]`

## 伤害系统废弃槽位

- `udg_TempUnit[5]`：不要再当“当前受伤单位”
- `udg_TempUnit[6]`：不要再当“当前伤害来源”

伤害系统改用：

- `entry.unit`
- `entry.source`
- 最终伤害回调的 `target / attacker / snapshot`

## 伤害与 `UnitDamageTarget`

- `GetEventDamageSource()` 只能在同步伤害事件里读
- `UnitDamageTarget(src, tgt, amount, false, false, ATTACK_TYPE_NORMAL, damageType, WEAPON_TYPE_WHOKNOWS)` 是常见的技能伤害写法
- 业务观察伤害优先走 `registerAppliedFinalDamageListener(target, attacker, applied, snapshot)`
- 业务改伤害优先走 `registerDamageModifier(context)`
