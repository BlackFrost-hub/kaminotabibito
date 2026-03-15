# udg_TempUnit 数组约定

**关键**：JASS 里声明为数组后，Lua 中 `udg_TempUnit` 是 JASS 数组对象，**不要**用 `g.udg_TempUnit = {}` 覆盖，否则会丢失该对象，JASS 读不到。只写 `(jass as any).udg_TempUnit[下标] = unit`。

| 下标 | 含义 |
|------|------|
| `udg_TempUnit[1]` | 当前操作单位（装备拾取/丢弃、移速、回复、狂暴等） |
| `udg_TempUnit[3]` | dot/buff 目标（Lua 造成 DOT 时写入，供 JASS 读） |
| `udg_TempUnit[4]` | dot/buff 来源（Lua 造成 DOT 时写入，供 JASS 读） |
| `udg_TempUnit[5]` | 受到伤害的单位（伤害事件中由伤害事件系统写入） |
| `udg_TempUnit[6]` | 伤害来源（伤害事件中由伤害事件系统写入；DOT 回调里读此取“当前这段伤害的来源”） |
