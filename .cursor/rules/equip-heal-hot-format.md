# 装备回复 hot 字段格式规则

## 格式概览

```
hot: "段1+段2+..."
abilList: "ID1,ID2,..."
```

- `+` 分隔多段，每段对应 abilList 中一个技能ID，对应一次 `TriggerExecute`
- 段数与 abilList 中 ID 数量**严格一一对应**

---

## 单段内语法（用 `;` 分隔 token）

| token 格式       | 含义                                     | 赋值目标        |
|-----------------|------------------------------------------|-----------------|
| `1000hp`        | 固定 1000 生命值                          | TempReal[1]     |
| `30%hp`         | 单位当前最大生命值 × 30%                   | TempReal[1]     |
| `30%hpLost`     | 单位已损失生命值（maxHP - currentHP）× 30% | TempReal[1]     |
| `500mp`         | 固定 500 魔法值                           | TempReal[2]     |
| `30%mp`         | 单位当前最大魔法值 × 30%                   | TempReal[2]     |
| `xxx:waitN`     | 该 token 末尾加 `:waitN`，表示整段延迟 N 秒 | —              |

- 同一段内**先全部累加**后再统一赋值，例：`30%hp;1000hp;5000mp` → TempReal[1] = maxHP×0.3+1000，TempReal[2] = 5000
- `wait` 作用于**整段**：若任意 token 有 `:waitN`，则该段所有操作（累加、赋值、TriggerExecute）均延迟 N 秒执行（在 timer 回调内完成）
- **不能先在外部累加再延迟执行**，必须在 timer 回调内读取单位属性并计算，防止与其他装备使用冲突覆盖全局变量

---

## 执行流程

### 无 wait 段（立即执行）
1. 读单位属性，计算 TempReal[1]（HP）、TempReal[2]（MP）
2. 赋值 `udg_TempReal[1]`、`udg_TempReal[2]`、`udg_TempUnit`、`udg_TempString[0]`
3. 执行 `TriggerExecute(gg_trg_HealItemEffect)`

### 有 wait 段（timer 内执行）
1. 启动 timer（N 秒后回调）
2. 在回调内：读单位属性 → 累加 → 赋值全局变量 → TriggerExecute

---

## 示例

| hot 字符串                                       | abilList       | 行为                                                                 |
|-------------------------------------------------|----------------|----------------------------------------------------------------------|
| `30%hp;1000hp;5000mp`                           | `A015`         | TempReal[1]=maxHP×0.3+1000，TempReal[2]=5000，立即执行一次             |
| `30%hp;300mp+300mp`                             | `A015,A08C`    | 第1次：TempReal[1]=maxHP×0.3，TempReal[2]=300；第2次：TempReal[2]=300   |
| `30%hp;1000hp;1000mp:wait0+30%hpLost:wait3`    | `A015,A08C`    | 段1 wait=0立即；段2 wait=3s后在timer里计算lostHP×0.3并执行             |
| `30%hp;2000hp:wait3`                            | `A015`         | wait=3s，3秒后读maxHP、累加TempReal[1]=maxHP×0.3+2000，执行一次        |

---

## 注意事项

- `jass.GetUnitState(unit, UNIT_STATE_MAX_LIFE)` 取最大生命值
- `jass.GetUnitState(unit, UNIT_STATE_LIFE)` 取当前生命值
- `jass.GetUnitState(unit, UNIT_STATE_MAX_MANA)` 取最大魔法值
- 已损失HP = maxHP - currentHP
- 防重 key 使用 globalThis（见 equip-heal-use-item.md）
