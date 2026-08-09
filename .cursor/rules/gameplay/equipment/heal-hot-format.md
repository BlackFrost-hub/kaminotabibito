# 装备回复 hot 字段格式规则

## 格式概览

```text
hot: "段1+段2+..."
abilList: "ID1,ID2,..."
hotDuration: 3
```

- `+` 分隔多段，每段对应 `abilList` 中一个技能 ID，对应一次 `TriggerExecute`
- 段数与 `abilList` 中 ID 数量严格一一对应
- `hotDuration` 可选，仅用于 `A08C` 持续治疗；不填时默认 10 秒

---

## 单段内语法

用 `;` 分隔 token。

| token 格式 | 含义 | 结果 |
|---|---|---|
| `1000hp` | 固定 1000 生命值 | 累加到 HP 结果 |
| `30%hp` | 单位最大生命值 × 30% | 累加到 HP 结果 |
| `30%hpLost` | 单位已损失生命值 × 30% | 累加到 HP 结果 |
| `500mp` | 固定 500 魔法值 | 累加到 MP 结果 |
| `30%mp` | 单位最大魔法值 × 30% | 累加到 MP 结果 |
| `xxx:waitN` | 该 token 末尾加 `:waitN`，表示整段延迟 N 秒 | 整段延迟执行 |

- 同一段内先全部累加，再统一计算最终 HP / MP
- `wait` 作用于整段；如果某个 token 带 `:waitN`，则该段所有操作都延迟到 timer 回调里执行
- 不能先在外部累加再延迟执行；必须在 timer 回调里读取单位属性并计算，避免和其他装备逻辑冲突

---

## 执行流程

### 无 wait 段
1. 读单位属性，计算本段 HP / MP
2. 直接调用治疗封装或物品治疗封装
3. 执行对应 `TriggerExecute`

### 有 wait 段
1. 启动 timer
2. 在回调内读取单位属性、计算本段 HP / MP
3. 直接调用治疗封装或物品治疗封装
4. 执行对应 `TriggerExecute`

---

## 代码口径

- 现在这套规则**不再依赖 `udg_TempReal`**
- 具体实现优先用局部变量保存 HP / MP 计算结果
- 需要瞬间治疗时走 `doHeal`
- 需要物品治疗效果时走 `doHealItemEffect` / `doHealItemEffectById`
- 需要持续治疗时走 `startHot`

---

## 示例

| hot 字符串 | abilList | 行为 |
|---|---|---|
| `30%hp;1000hp;5000mp` | `A015` | 立即计算 HP / MP 后执行一次 |
| `30%hp;300mp+300mp` | `A015,A08C` | 第 1 段与第 2 段分别执行 |
| `30%hp;1000hp;1000mp:wait0+30%hpLost:wait3` | `A015,A08C` | 第 1 段立即，第 2 段延迟 3 秒 |
| `30%hp;2000hp:wait3` | `A015` | 3 秒后再读最大生命并计算 |

---

## 注意事项

- `japi.GetUnitState(unit, UNIT_STATE_MAX_LIFE)` 取动态最大生命值
- `jass.GetUnitState(unit, UNIT_STATE_LIFE)` 取当前生命值
- `japi.GetUnitState(unit, UNIT_STATE_MAX_MANA)` 取动态最大魔法值
- `已损失 HP = maxHP - currentHP`
- 防重 key 仍使用 `globalThis`，见同目录 `物品系统与装备技能规则.md`
