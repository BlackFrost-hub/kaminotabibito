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

## 一句话

- JASS 数组互通：`(jass as any).udg_XXX[index]`
- 伤害上下文：不要再依赖 `udg_TempUnit[5/6]`
