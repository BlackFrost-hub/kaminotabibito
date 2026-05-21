# UnitDamageTarget 与伤害回调

- `GetEventDamageSource()` 只能在 `EVENT_UNIT_DAMAGED` 同步阶段读取。
- 不要再从 `udg_TempUnit[5] / [6]` 取受伤单位和伤害来源。
- 当前项目以 `TS/系统/04．伤害系统/01．伤害事件.ts` 的同步快照为准：
  - `entry.unit`
  - `entry.source`
  - `entry.isNormalAttack`

## UnitDamageTarget 参数

| 位置 | 含义 |
|------|------|
| 1 | 伤害来源 |
| 2 | 伤害目标 |
| 3 | 伤害量 |
| 4 | 是否攻击伤害 |
| 5 | 是否远程攻击 |
| 6 | 攻击类型 |
| 7 | 伤害类型 |
| 8 | 武器类型 |

## 项目约定

- 技能/法术伤害通常写：

```jass
UnitDamageTarget(src, tgt, amount, false, false, ATTACK_TYPE_NORMAL, damageType, WEAPON_TYPE_WHOKNOWS)
```

- 业务观察类伤害回调默认走：
  - `registerAppliedFinalDamageListener(target, attacker, applied, snapshot)`
- 业务改伤害走：
  - `registerDamageModifier(context)`

## 不要再用

- `registerDamageCallback` 做普通业务伤害监听
- `merged` 位图
- 延后回调里重新读伤害上下文
