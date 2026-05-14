# Boss自动通魔AI规划

## 目标

为重要 Boss 提供一个低配置的自动施法系统。Boss 的技能主要是通魔技能，因此系统应优先利用 Dz 扩展 API 自动读取技能数据，而不是为每个技能手写完整配置表。

第一版目标是简单、稳定、可控：

- Boss 自动扫描自身技能。
- 自动读取通魔命令 ID、目标类型、冷却、蓝耗、施法距离。
- 默认锁定最高仇恨目标。
- 从当前可用技能中随机选一个释放。
- 不追求复杂技能策略、阶段机制、权重表或精细走位。

## 核心 API

技能扫描：

```ts
EXGetUnitAbilityByIndex(boss, slot)
EXGetAbilityId(ability)
```

通魔数据读取：

```ts
DzGetUnitAbilityOrderId(boss, abilityId)
DzGetUnitAbilityDataB(boss, abilityId)
DzGetUnitAbilityRange(boss, abilityId)
DzGetUnitAbilityCost(boss, abilityId)
DzGetUnitAbilityCool(boss, abilityId)
DzGetUnitAbilityTargs(boss, abilityId)
```

仇恨目标：

```ts
getHighestThreat(boss, filter)
```

下达命令：

```ts
IssueImmediateOrderById(boss, orderId)
IssueTargetOrderById(boss, orderId, target)
IssuePointOrderById(boss, orderId, x, y)
```

## 目录重构规划

目标目录仍使用：

```text
TS/系统/03．技能系统/06．AI自动使用技能/
```

重构后的目录结构：

```text
06．AI自动使用技能/
├── 00．常量定义.ts
├── 01．辅助函数.ts
├── 02．技能扫描.ts
├── 03．目标选择.ts
├── 04．施法执行.ts
├── 05．核心业务逻辑.ts
├── index.ts
├── README.md
└── 规划-Boss自动通魔AI.md
```

旧文件处理：

- 旧 `01．核心功能.ts` 是配置式 AI 预览，删除或由新的 `05．核心业务逻辑.ts` 替换。
- 旧 `02．工具函数.ts` 中可复用的句柄、死亡、距离、冷却等逻辑迁到 `01．辅助函数.ts`，旧文件删除。
- 旧 `00．常量定义.ts` 保留文件名，但内容替换为 Boss 自动通魔 AI 的常量。
- 旧 `README.md` 改写为新系统说明，删除旧 `registerAISkill/registerAIUnit` 配置式 API 示例。
- `index.ts` 保留为目录入口，只导出新 Boss 自动通魔 AI API，并继续提供 `init()` 给技能系统总入口调用。

各文件职责：

- `00．常量定义.ts`：默认检查间隔、公共施法间隔、默认施法距离、扫描槽位数、DataB 枚举、统一目标类型、已知原生模板技能表。
- `01．辅助函数.ts`：JASS/JAPI 局部别名、句柄 ID、单位有效/死亡判断、距离、魔法、技能等级、当前冷却、同步随机。
- `02．技能扫描.ts`：扫描 Boss 技能，读取 `orderId/DataB/range/cost/cool/targs`，识别原生模板或通魔目标类型，生成技能缓存。
- `03．目标选择.ts`：从仇恨系统取最高仇恨目标，并按死亡、无效、距离过滤。
- `04．施法执行.ts`：按统一目标类型下达无目标、单位目标、点目标命令。
- `05．核心业务逻辑.ts`：Boss 注册、注销、刷新缓存、中心 tick、候选技能筛选、随机选择、公共施法间隔。

## 技能类型分流

Boss 自动扫描到技能后，先判断是否属于已知原生模板技能，再决定走哪条处理路径。

分流顺序：

1. 识别为已知原生模板技能：走模板技能处理。
2. 未识别为已知原生模板技能：走通魔 DataB 处理。

这样做的原因：

- 死亡缠绕、风暴之锤这类通用模板本身语义明确，不需要用通魔 DataB 推断。
- 通魔技能依赖 `DzGetUnitAbilityDataB` 判断点、单位、自身、无目标。
- 两类技能分开处理，后续遇到特殊模板时只扩展模板识别表，不影响通魔默认逻辑。

建议新增集中识别表：

```ts
const 已知原生模板技能表: Record<number, Boss技能模板类型> = {
  // 死亡缠绕模板: "unit",
  // 风暴之锤模板: "unit",
};
```

模板类型第一版只需要：

```ts
type Boss技能模板类型 = "none" | "self" | "unit" | "point" | "unitOrPoint";
```

识别函数：

```ts
function 获取已知原生模板目标类型(abilityId: number): Boss技能模板类型 | null {
  return 已知原生模板技能表[abilityId] ?? null;
}
```

如果返回非空，候选缓存中的目标类型直接使用模板类型；如果返回空，再读取 `DzGetUnitAbilityDataB` 并转成目标类型。

## DataB 目标类型约定

通魔技能的 `DataB` 用来判断施法命令形态。

| DataB | 语义 | AI处理 |
|---:|---|---|
| 0 | 没有 / 无目标 | 默认按自身或无目标处理 |
| 1 | 单位目标 | 对最高仇恨目标发布单位目标命令 |
| 2 | 点目标 | 对最高仇恨目标当前位置发布点目标命令 |
| 3 | 单位目标或者点目标 | 第一版优先按单位目标处理，失败风险低；必要时后续可改为点目标兜底 |

`DataB = 0` 的默认处理：

- 第一版优先 `IssueImmediateOrderById(boss, orderId)`。
- 如果后续确认某些自身通魔必须单位目标施放，可以加极少数 override，将该技能改为 `IssueTargetOrderById(boss, orderId, boss)`。

## 系统入口

建议在现有 `06．AI自动使用技能` 下扩展，不另起大型系统。

新增公开入口：

```ts
注册Boss自动通魔AI(boss, options?)
取消Boss自动通魔AI(boss)
刷新Boss自动通魔技能缓存(boss)
```

建议参数：

```ts
interface Boss自动通魔AI参数 {
  检查间隔Ms?: number;      // 默认 1000
  公共施法间隔Ms?: number;  // 默认 1500
  默认施法距离?: number;    // 默认 1000
  扫描槽位数?: number;      // 默认 64
}
```

## 缓存结构

Boss 注册后建立单位级状态：

```ts
interface Boss自动通魔状态 {
  boss: any;
  bossId: number;
  技能列表: Boss通魔技能缓存[];
  下次允许施法时间Ms: number;
  参数: Boss自动通魔AI参数;
}
```

每个技能缓存：

```ts
interface Boss通魔技能缓存 {
  abilityId: number;
  orderId: number;
  来源类型: "template" | "channel";
  目标类型: "none" | "self" | "unit" | "point" | "unitOrPoint";
  dataB: number;
  range: number;
  cost: number;
  cool: number;
  targs: number;
}
```

缓存刷新时机：

- 注册 Boss 时扫描一次。
- Boss 技能可能动态变化时，外部调用 `刷新Boss自动通魔技能缓存(boss)`。
- 第一版不每 tick 扫描，避免无意义开销。

## Tick 流程

每次周期检测：

1. 遍历已注册 Boss。
2. 跳过死亡、无效、暂停或当前不可施法的 Boss。
3. 如果未到公共施法间隔，跳过。
4. 读取最高仇恨目标。
5. 过滤目标死亡、无效、超距。
6. 遍历缓存技能，筛出候选技能。
7. 从候选技能中随机选择一个。
8. 根据缓存的 `目标类型` 发布命令。
9. 命令发布成功后记录公共施法间隔。

## 候选技能过滤

技能进入候选列表需要满足：

- `abilityId != 0`
- `orderId != 0`
- Boss 拥有该技能且等级大于 0
- 技能不在冷却中
- Boss 当前魔法值大于等于技能蓝耗
- 最高仇恨目标在施法距离内
- 已知模板技能有可用模板目标类型，或通魔技能的 `DataB` 是已支持的值：`0 | 1 | 2 | 3`

施法距离规则：

- `DzGetUnitAbilityRange` 返回值大于 0 时使用 API 值。
- 返回值小于等于 0 时使用默认距离，默认 `1000`。

## 目标选择

第一版只做最高仇恨目标：

```ts
const target = getHighestThreat(boss, filter)?.targetRef;
```

过滤条件：

- 目标句柄有效。
- 目标未死亡。
- 目标与 Boss 距离不超过当前技能施法距离。

不做的内容：

- 不随机玩家。
- 不按最低血量、最远目标、玩家密度选点。
- 不做阶段技能权重。

## 随机选择

候选技能数量大于 0 时，随机取一个。

注意：

- 不使用 TS / Lua `Math.random`。
- 运行时随机走 JASS 随机函数或项目已有随机封装。
- 如果担心联机一致性，必须使用同步随机路径，不使用本地 UI 或 `GetLocalPlayer()` 分支计算候选。

## DzGetUnitAbilityTargs 的定位

`DzGetUnitAbilityTargs` 不用于判断点、单位、自身、无目标，这件事由 `DataB` 决定。

第一版可以暂时不解析 `targs`，只缓存用于调试输出。后续如果需要，可以用它做目标合法性辅助过滤，例如只允许敌方、地面、空中等。

## 与现有 AI 自动使用技能系统的关系

现有系统是“配置表注册技能”路线，但目前没有业务引用，且核心目标搜索仍是预览状态。

Boss 自动通魔 AI 是“自动扫描 + 模板识别 + 通魔 DataB 驱动”路线，适合当前地图重要 Boss 的简单自动施法需求。

建议实现方式：

- 放在 `06．AI自动使用技能` 目录内。
- 删除旧配置式 `registerAISkill/registerAISkills/registerAIUnit/unregisterAIUnit` API。
- 只保留并重写 `index.ts` 作为新系统入口。
- 技能系统总入口仍 require 这个目录的 `index` 并调用 `init()`，但 `init()` 初始化新 Boss 自动通魔 AI。

## 调试输出

调试统一使用：

```ts
debugLogForce("Boss自动通魔AI", ...)
```

建议输出场景：

- Boss 注册成功。
- 技能扫描结果：`abilityId/orderId/来源类型/目标类型/dataB/range/cost/cool/targs`。
- 找不到最高仇恨目标。
- 没有候选技能。
- 施法成功或失败。
- 遇到未知 `DataB`。
- 命中已知原生模板技能。

## TSTL 与实现注意事项

- `jass` / `japi` API 必须先绑定局部别名再调用。
- 局部别名类型必须带 `this: void`，避免生成 Lua 多出 `nil` 参数。
- 中心计时器回调必须使用模块级具名函数，不能用匿名闭包。
- 不使用 `Math.*`。
- 不修改 `fix-lua-for-pack.js`。
- 改 TS 后必须 `npm run build`。
- 若新增 helper、回调或 JAPI 调用，build 后检查生成 Lua 的 `self/nil` 和参数顺序。

## 第一版验收

测试场景：

- 注册一个拥有多个通魔技能的 Boss。
- 对 Boss 建立仇恨。
- 最高仇恨目标在 1000 码内时，Boss 会随机释放不在冷却且蓝耗足够的技能。
- `DataB = 1` 的技能对最高仇恨单位释放。
- `DataB = 2` 的技能对最高仇恨单位坐标释放。
- `DataB = 3` 的技能优先按单位目标释放。
- `DataB = 0` 的技能按无目标 / 自身技能释放。
- 已知原生模板技能不读取 DataB 决定命令形态，而是按模板目标类型释放。
- 未命中模板识别表的技能走通魔 DataB 处理。
- 技能冷却、蓝耗、距离不足时不会进入候选。

## 后续扩展

如果第一版不够用，再考虑增加少量可选 override：

```ts
注册Boss自动通魔AI(boss, {
  技能覆盖: {
    [abilityId]: {
      禁用?: boolean;
      目标类型?: "self" | "none" | "unit" | "point";
      固定距离?: number;
      权重?: number;
    }
  }
})
```

但第一版不需要这层配置，避免系统一开始就复杂化。
