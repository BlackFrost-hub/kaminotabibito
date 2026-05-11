Buff系统说明

这个目录维护自定义 BuffUI、Buff 池、快速 Buff 的 UI 映射、DOT 同步与控制抗性。

常用入口：

- `00．Buff系统.ts`：底层 Buff 池、登记、查询、按 buffID 删除单条 Buff。
- `01．Buff表.ts`：BuffUI 展示数据，`type` 用于区分 `Buff:` 与 `Debuff:`。
- `05．Buff清除函数.ts`：显眼的通用清除入口，按 `type` 前缀清 Buff。

清除函数：

```ts
移除单位增益Buff(unit)
移除单位负面Buff(unit)
移除单位指定类型Buff(unit, "Debuff:control")
移除单位指定类型Buff(unit, "Debuff:magic")
```

说明：

- `D001-D004` 是纯 TS DOT，清除时停止 DOT 与自定义 BuffUI，不删除原生魔法效果。
- 快速 Buff 如果登记了原生魔法效果 rawId，清除时会同步 `UnitRemoveAbility`。
- 技能侧优先从 `TS/系统/03．技能系统/00．技能模板+函数/02．通用函数/01．控制与Buff.ts` 引用清除入口。
