# Buff 系统规则

适用范围：
- `TS/系统/05．Buff系统/**`
- `TS/系统/03．技能系统/00．技能模板+函数/01．技能函数/19．拓展效果/**`
- 任何会新增、施加、清除 Buff / Debuff / HOT / DOT / 原生魔法效果的装备或技能代码。

## 1. 先区分三层

新增 Buff 前必须先判断它属于哪几层：

- **Buff 表/UI 层**：`TS/系统/05．Buff系统/01．Buff表.ts`，负责图标、说明、类型、驱散等级、表现特效和 Buff 池展示。
- **TS 运行逻辑层**：`registerManualBuff`、HOT、DOT、属性修改、伤害修正等，负责实际数值效果。
- **魔兽原生魔法效果层**：由 `objediting/abilities.lua` 里的原生技能施加，例如减速、残废、心灵之火、精灵之火、睡眠、飓风、寄生等。清除时必须用 `UnitRemoveAbility(unit, 原生BuffRawId)` 删除目标身上的魔法效果。

不能只加 Buff 表/UI 层就认为效果完整。

## 2. Buff 表字段规则

`01．Buff表.ts` 中新增条目时，至少要明确：

- `buffID`：项目内部 BuffID，例如 `C028`。
- `buffName`：显示名。
- `icon`：UI 图标。
- `effect`：表现特效路径；没有表现特效时填空字符串。
- `effectMode` / `effectAttachPoint`：需要挂点时必须写清楚，例如 `attach + overhead/origin/chest`；需要坐标特效时用 `point`。
- `type`：驱散和分类依赖这个前缀，例如 `Buff:`、`Debuff:`、`Debuff:control`、`Debuff:magic`。
- `interval`：仅表达 Buff 数据语义；真正 tick 逻辑必须在对应 TS 效果文件中实现。
- `maxStack`、`stackRule`、`stackRefresh`：叠层规则必须和代码实现一致。
- `dispelLevel`、`canPurge`：驱散逻辑依赖这两个字段。
- `tooltip`：说明必须和实际代码效果一致。

如果 Buff 需要实际数值效果，必须在 `19．拓展效果` 下写对应实现，不能只写表。

## 3. 原生 Buff 必须兼容清理

如果 Buff 是通过快速 Buff / 马甲技能 / 魔兽原生技能施加的，必须确认清除时能同步删除原生魔法效果：

- 走快速 Buff 系统时，优先使用现有 `SFB_setBuff` / `SFB_setSlow` / 快速 Buff 封装。
- 快速 Buff 对应的 `C001-C018/C024` 已在 Buff 池底层维护默认原生 Buff rawId 映射；清除或到期时会调用 `UnitRemoveAbility`。
- 如果新增了新的原生 Buff 类型，必须同时补：
  - `objediting/abilities.lua` 中的技能与 Buff 设置。
  - 快速 Buff 或施加入口的 BuffID 映射。
  - Buff 池清理所需的 `nativeBuffAbilityIds`，或在默认映射中补对应 BuffID。

禁止只用 TS Buff 池删除 UI，而不清理目标身上的原生魔法效果。

## 4. 持续逻辑必须检查 Buff 是否还存在

任何持续执行效果都必须把“Buff 被驱散/代码层清除”视为提前结束：

- HOT：每跳前检查对应 `BuffID` 是否还在 Buff 池，不存在就停止并清理。
- DOT：每跳前检查对应 `BuffID` 是否还在 Buff 池，不存在就停止并清理。
- 持续属性修改：必须通过 `onRemove` 回滚属性；如果还有周期逻辑，也要检查 Buff 是否存在。
- 持续伤害修正/易伤/减伤：不要缓存后永久生效，计算时必须以 Buff 当前存在为准，或在 `onRemove` 中回滚写入的属性。

只注册 `registerManualBuff` 不等于已经实现了持续效果中断。

## 5. `registerManualBuff` 使用规则

`registerManualBuff(target, buffID, duration, effectValue, extras)` 只能作为 Buff 池注册入口。

使用时必须按效果类型补齐：

- 有来源显示：传 `sourceName`。
- 有第二数值：传 `effectValue2`。
- 有额外表现模型：传 `effectModelOverride`。
- 需要清原生魔法效果：传 `nativeBuffAbilityIds`，或确认 Buff 池已有默认映射。
- 需要回滚属性/状态：传 `onRemove`，并确保重复施加、刷新、取最高值时不会重复扣回。

如果效果依赖 `effect/effect2`，调用方和读取方必须统一单位：百分比是 `0.3` 还是 `30` 要在入口规范化。

## 6. 属性 Buff 规则

属性类 Buff 不要只做 UI。

- 固定攻击力增加：走属性底层加减，清除时 `onRemove` 反向回滚。
- 伤害百分比增减：要对齐伤害系统读取逻辑。玩家英雄通常写玩家属性，非英雄写单位属性。
- 生命/魔法恢复：走治疗系统 `doHeal` 或 HOT 封装。
- 持续恢复：必须支持 Buff 被清除后提前停止。

英雄/玩家属性和单位属性不要混写；写入层级必须和伤害/属性读取方一致。

## 7. 驱散入口规则

清除 Buff 优先走统一入口：

- `移除单位指定Buff`
- `移除单位增益Buff`
- `移除单位负面Buff`
- `按驱散等级移除单位Buff`
- 技能侧引用 `02．通用函数/01．控制与Buff.ts` 里的中文别名。

不要在业务代码里只删自己的表状态。统一清除入口负责：

- 触发 `onRemove`。
- 停止 DOT/HOT 等运行态。
- 清 Buff 池/UI。
- 删除登记过的原生魔法效果。

## 8. TSTL 与回调规则

- 新增 Buff 文件优先 `/** @noSelfInFile */`，但必须检查调用方和被调用方 Lua 形态。
- JASS API 先绑局部别名，不直接写 `jass.Xxx(...)`。
- 定时器、JASS 回调使用模块级具名函数。
- 不准为了 TSTL 问题修改 `scripts/fix-lua-for-pack.js`。
- 构建后只看 `src` 下生成 Lua，重点查 `self/nil`、`registerManualBuff`、`onRemove`、`UnitRemoveAbility`、HOT/DOT tick 回调。

## 9. 新增 Buff 自检清单

新增或修改 Buff 后必须自检：

- Buff 表条目是否完整，`type/canPurge/dispelLevel` 是否符合驱散语义。
- 是否有实际效果实现，不只是 UI。
- 如果用了原生魔法效果，是否能 `UnitRemoveAbility` 清掉。
- 如果是 HOT/DOT/持续效果，Buff 被驱散后是否提前结束。
- 如果是属性修改，`onRemove` 是否正确回滚。
- 重复施加、刷新、最高值、叠层是否和 `stackRule` 一致。
- `npm run build` 通过。
- 生成 Lua 没有 `self/nil` 参数错位。
