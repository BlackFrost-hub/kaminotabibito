# 1.27 伤害来源 udg_TempDmgUnit2

在 1.27 下，从 Lua 调用 `GetEventDamageSource()` 可能拿不到事件上下文，DOT 反恢复会显示「无来源」。

**做法**：在地图 JASS 里加一个**伤害触发的第一条动作**，把来源写入全局，Lua 不再覆盖该全局：

```jass
set udg_TempDmgUnit2 = GetEventDamageSource()
```

伤害单位（受击者）为 `udg_TempDmgUnit`。若 GetEventDamageSource 在 JASS 里可用，在「单位受到伤害」动作最前面加上面一句即可；Lua 会读取 `udg_TempDmgUnit2` 作为伤害来源。
