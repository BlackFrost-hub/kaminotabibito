# 伤害类型全局变量清空（JASS，可选）

当前「伤害事件」仅用 Lua 侧对 `udg_TempDamageType` 等赋 0/false 做清空，**不要求** JASS 里必须有 `ClearDamageTypeGlobals`。

若实际运行中仍出现类型残留（例如下一批伤害仍显示上一批的远程/普攻），再在 JASS 中加上下面的函数，并在 伤害事件.ts 里取消对 `ExecuteFunc("ClearDamageTypeGlobals")` 的注释。

## 变量表需存在

- `integer udg_TempDamageType`（属性位 1～1024 + 类型位 2048/4096/8192/16384 均由 JASS 用 OperatorIntegerAdd 累加到此变量）

## JASS 函数（可选，仅残留时用）

```jass
function ClearDamageTypeGlobals takes nothing returns nothing
    set udg_TempDamageType = 0
endfunction
```
