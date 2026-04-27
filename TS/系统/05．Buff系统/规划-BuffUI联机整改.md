# BuffUI 联机整改施工文档

## 1. 文档用途

本文件不是讨论稿，而是给后续执行者直接落地用的施工文档。

适用对象：

- 接手实现的开发者
- 执行修改的 AI
- 最后做验收和 review 的人

使用方式：

1. 先完整阅读本文件。
2. 按本文的阶段顺序实施，不要跳步混改。
3. 每完成一个阶段，回填本文末尾的“执行回填区”。
4. 实现完成后，再交给主审做代码审查和联机安全验收。

---

## 2. 当前结论

### 2.1 BuffUI 目前的结构定位

`BuffUI` 不是字面意义上的“每玩家一套 N 槽壳”，更接近：

- 每客户端一套对称创建的 BuffUI 壳
- 周期刷新统一启动
- 最后在本地分支做显示

这种结构不是天然错误，但前提是：

- 本地分支必须非常瘦
- 本地分支不能做重逻辑
- 本地分支不能做对象生命周期操作
- 本地分支不能写共享状态

当前 `BuffUI` 没有收敛到这个程度。

### 2.2 当前已知问题

当前 `TS/系统/05．Buff系统/02．BuffUI.ts` 里，至少有以下问题：

1. 本地刷新链里做 `CreateGroup / GroupEnumUnitsSelected / DestroyGroup`
2. 本地刷新链里构造数组、排序、拼 tooltip 字符串
3. 本地刷新链里做 `DzFrameSetText / DzFrameSetTexture`
4. 本地 debug 路径里写模块级状态
5. 当前 0.1s 周期链仍然是“本地逻辑过厚”的结构

这些问题里，最需要优先收的是前 3 条。

---

## 3. 整改目标

整改后的 `BuffUI` 必须满足以下目标。

### 3.1 生命周期目标

- UI 帧创建：全端对称执行
- hover 注册：全端对称执行
- timer 创建与启动：全端对称执行
- 不在本地异步路径里创建/销毁 group、timer、trigger

### 3.2 数据目标

- Buff 行数据在统一路径里生成
- 本地分支不再 `push / sort / 拼字符串 / 写模块缓存`
- 本地分支不再写共享 `Map / table / debug key`

### 3.3 显示目标

本地分支允许保留的动作尽量压缩为：

- `showFrame / hideFrame`
- `DzFrameSetText`
- `DzFrameSetTexture`

前提是：

- 要写入的文本已经在前置阶段准备好
- 要写入的贴图路径已经在前置阶段准备好
- 本地分支只负责把结果渲染到 frame 上

### 3.4 handle 目标

- `sync=false` / 本地异步路径里拿到的 handle 不得跨帧持有
- 如果某个 handle 只是为了当前帧注册或当前帧调用，使用后立即断开引用
- 不把本地路径里的 handle 挂到模块级缓存上长期保存

---

## 4. 必须保持不变的外部行为

施工时必须保证以下行为不变，除非文档明确允许调整。

1. Buff 图标显示位置、数量上限、排列方向不变
2. tooltip 的基本信息语义不变
3. 剩余时间显示规则不变
4. hover 显示 / 离开隐藏的交互不变
5. 现有 Buff 表配置字段语义不变
6. 现有 Buff runtime 取值接口不变，除非另起兼容层

如果实现者想顺手“优化体验”或“统一格式”，一律延后，不并入本次整改。

---

## 5. 明确禁止事项

以下事项本次一律禁止：

1. 禁止顺手重写整个 Buff 系统
2. 禁止顺手改 Buff 表结构
3. 禁止把本次整改和 unrelated 格式化、命名重排、注释清洗混在一起
4. 禁止为了省事把更多逻辑继续塞进本地 `GetLocalPlayer()` 分支
5. 禁止把本次整改扩大成“所有 UI 系统统一重构”
6. 禁止引入新的全局 monkey patch
7. 禁止新增“本地 table 缓存 + 周期刷新”这种同类风险结构

---

## 6. 风险分级

### P0：必须本次完成

1. 本地路径里的 `CreateGroup / DestroyGroup`
2. 本地路径里的数组构造和排序
3. 本地路径里的 tooltip 字符串拼接
4. 本地路径里的模块级状态写入
5. 周期刷新主链拆成“前置计算 + 本地渲染”

### P1：建议本次完成

1. hover 回调分发进一步规范化
2. tooltip / remainText / iconPath 统一 view model 化
3. debug 路径从本地写状态改成只本地输出

### P2：可以后续再做

1. 更通用的 UI view model 基础设施
2. `BuffUI` 与其他 UI 系统共享抽象
3. 更进一步的中心计时器整合

---

## 7. 推荐最终结构

推荐拆成两层：

### 第一层：统一计算层

职责：

- 决定当前要显示哪些 buff
- 生成固定长度的槽位快照
- 为每个槽位准备：
  - `visible`
  - `iconPath`
  - `remainText`
  - `tooltipText`

这一层要求：

- 不操作 frame
- 不创建/销毁 handle
- 输出纯数据

### 第二层：本地渲染层

职责：

- 读取上一层已经生成好的 view model
- 只做本地显示与内容回写

这一层允许：

- `showFrame / hideFrame`
- `DzFrameSetText`
- `DzFrameSetTexture`

这一层不允许：

- 选单位扫描
- group 生命周期操作
- tooltip 字符串生成
- 排序
- 写共享状态

---

## 8. 推荐数据结构

建议新增：

```ts
interface BuffSlotViewModel {
  visible: boolean;
  iconPath: string;
  remainText: string;
  tooltipText: string;
}

interface BuffBarViewModel {
  slots: BuffSlotViewModel[];
}
```

约束：

- `slots.length` 固定为 `MAX_SLOTS`
- 不显示的槽位也要给空模型
- 所有客户端按同一顺序生成

这样本地渲染只需要：

```ts
renderBuffBarLocal(viewModel);
```

---

## 9. 选中单位来源整改

### 当前问题

当前刷新链通过本地扫描“当前选中单位”来决定显示对象，这导致：

- 本地路径里要创建 group
- 本地路径里要遍历选中集
- 本地路径里逻辑过厚

### 推荐方案

优先采用方案 A。

#### 方案 A：显示固定对象

如果 BuffUI 实际目标是“显示本玩家主英雄的 Buff”，则直接从英雄桥接层取主英雄，不再扫描本地选中组。

优点：

- 最稳定
- 最容易联机安全
- 最容易收敛逻辑

#### 方案 B：保留“显示当前选中单位 Buff”

如果功能目标不能改，必须保留当前选中逻辑，则要把它严格拆层：

1. 统一获取当前观察目标
2. 基于目标生成标准化 `BuffBarViewModel`
3. 本地层只 render

即使保留方案 B，也不允许再在本地渲染链里直接 `CreateGroup / DestroyGroup`。

如果方案 B 做不到这一点，则本次整改视为未完成。

---

## 10. tooltip / 文本 / 图标整改要求

建议抽出纯函数：

- `buildBuffRemainText(...)`
- `buildBuffTooltipText(...)`
- `resolveBuffIconPath(...)`

约束：

- 输入只用纯值
- 输出只用纯字符串
- 不读 frame 当前文本
- 不读本地缓存表
- 不访问本地 debug 状态

本地渲染层只做：

```ts
setText(slot.remainText, vm.remainText);
setText(slot.tipText, vm.tooltipText);
setTexture(slot.root, vm.iconPath);
```

---

## 11. hover / tooltip 行为要求

hover 行为可以保留，但必须满足：

1. 回调是具名分发，不在注册处现造匿名业务闭包
2. hover 内只做 show/hide
3. hover 内不现算 tooltip
4. hover 内不写模块级状态

允许的理想形态：

- `onSlotEnter(slotIndex)`
- `onSlotLeave(slotIndex)`

只做：

- `showFrame(tipBox)`
- `showFrame(tipText)`
- `hideFrame(...)`

---

## 12. timer 整改要求

### 当前问题

当前 timer 是“全端启动，本地重逻辑刷新”，这不够干净。

### 目标结构

保留一条全端对称启动的 refresh timer，但拆成两段：

#### 第一段：统一计算

```ts
const viewModel = buildBuffBarViewModel(...);
```

#### 第二段：本地渲染

```ts
if (isLocalPlayerTarget) {
  renderBuffBarLocal(viewModel);
} else {
  hideBuffBarLocal();
}
```

要求：

- 第一段不碰 frame
- 第二段不做重逻辑

---

## 13. 建议实施顺序

必须按这个顺序做。

### 第 1 步：抽 view model

目标：

- 把 `visible / iconPath / remainText / tooltipText` 的生成从本地渲染里抽出来

交付标准：

- 能在不改 UI 创建逻辑的前提下，产出固定长度 `BuffBarViewModel`

### 第 2 步：收本地 render

目标：

- 让本地路径只消费 `BuffBarViewModel`

交付标准：

- 本地路径里不再 `sort / push / 拼 tooltip`

### 第 3 步：清 group 生命周期

目标：

- 清掉本地路径里的 `CreateGroup / DestroyGroup`

交付标准：

- 本地刷新链不再做 handle 生命周期操作

### 第 4 步：收 hover / debug

目标：

- hover 只保留 show/hide
- debug 不再写模块级状态

### 第 5 步：回归与验收

目标：

- build 通过
- 实机表现不退化
- 联机安全规则不再违例

---

## 14. 代码层验收标准

实现完成后，至少要满足这些静态条件：

1. `BuffUI.ts` 的本地分支里不再出现：
   - `CreateGroup`
   - `DestroyGroup`
   - `new Array`
   - `push`
   - `sort`
   - tooltip 字符串拼接主逻辑

2. 本地渲染链只保留：
   - `show/hide`
   - `setText`
   - `setTexture`

3. 0.1s refresh timer 的回调能明显看出“计算层 / 渲染层”分离

4. 没有新增本地路径里的共享状态写入

5. 没有新增 `sync=false` 路径下的跨帧 handle 持有

---

## 15. 联机安全验收标准

主审验收时重点看这些问题：

1. 本地路径里是否还在创建/销毁 handle
2. 本地路径里是否还在构造 table / string 作为主业务逻辑
3. 本地路径里是否还在写模块级状态
4. 是否把本地路径里的结果又喂回了后续共享链
5. 是否新增了新的循环依赖、匿名回调风险、TSTL 产物异常

如果任意一条成立，本次整改不能判完成。

---

## 16. 实机测试建议

实现者至少应自测以下场景：

1. 进入地图后 BuffUI 正常初始化
2. 单位有 0、1、多个 Buff 时显示正常
3. tooltip hover 行为正常
4. Buff 剩余时间正常变化
5. Buff 消失时图标与 tooltip 正常清空
6. 多人联机时，不同玩家本地观察目标变化不会立刻出异常

如果没有做其中某项测试，必须在回填区明确写“未测”。

---

## 17. 交付要求

执行者提交时必须一起给出：

1. 改了哪些文件
2. 哪些目标完成了
3. 哪些目标没完成
4. 有没有改动外部行为
5. build 是否通过
6. 哪些场景实测了
7. 哪些场景没测

不允许只说“已完成，请测试”。

---

## 18. 主审验收口径

主审不是只看 build 过没过，而是重点审：

1. 结构是否真的从“本地重逻辑”收成“统一计算 + 本地 render”
2. 本地路径是否真的瘦下来
3. 是否仍然残留联机安全规则违例
4. 是否引入新的循环依赖、具名回调退化、编码污染或 TSTL 产物异常

主审如果发现实现者只是“把原逻辑换个函数名包起来”，不算整改完成。

---

## 19. 执行回填区

下面这部分给实现者完成后填写。

### 19.1 本次执行概述

- 执行人：Claude Code
- 执行时间：2026-04-28
- 修改文件：
  - `TS/系统/00．核心系统/01．事件中心/05．玩家选中单位事件中心.ts`（新增）
  - `TS/系统/00．核心系统/01．事件中心/index.ts`（修改）
  - `TS/系统/05．Buff系统/04．BuffUIViewModel.ts`（新增）
  - `TS/系统/05．Buff系统/02．BuffUI.ts`（重构）

### 19.2 已完成项

- [x] 新增玩家选中单位事件中心（05．玩家选中单位事件中心.ts）
- [x] 选中事件通过 TriggerRegisterPlayerSelectionEventBJ 监听 selected/deselected
- [x] 维护每个玩家的选中单位集合（Record<number, Set<any>>）
- [x] 提供 getSoleSelectedUnitForPlayer（单选返回 unit，多选/空选返回 null）
- [x] 更新事件中心 index.ts 导出
- [x] 新增 ViewModel 层（04．BuffUIViewModel.ts）
- [x] buildBuffBarViewModel 纯函数，全端计算，不碰 frame
- [x] 重构 02．BuffUI.ts：syncBuffBar 拆分为全端计算 + 本地渲染
- [x] 删除本地 CreateGroup/GroupEnumUnitsSelected/DestroyGroup
- [x] 删除本地数组 push/sort/tooltip 拼接
- [x] 删除 BUFF_UI_DEBUG / lastBuffUiDbgKey
- [x] 删除 getFrameText / countSelectedForPlayer / getSoleSelectedUnitForPlayer / collectBuffRows / formatDotTooltip
- [x] Hover 只保留 show/hide
- [x] onPlayerHeroRegistered 中初始化事件中心

### 19.3 未完成项

- [ ] 无（整改范围已全部完成）

### 19.4 风险与说明

- 事件中心通过全局 EVENT_PLAYER_UNIT_SELECTED / EVENT_PLAYER_UNIT_DESELECTED 监听，确保所有客户端同步触发
- 选中单位集合用 Set<any> 存 unit handle，注意 Lua 端 Set 行为
- 原代码中的 getFrameText（读取帧文本比较以跳过重复 set）已移除，renderBuffBarLocal 每次刷新直接设值
- 选中事件中心已防御初始化（getSoleSelectedUnitForPlayer 内 if (!_initialized) 自动 init）

### 19.5 build 结果

- `npm run build`：通过（仅 TSTL 真假值警告，无错误）

### 19.6 实机测试结果

- 已测：
- 未测：全部（需实机验证）

---

## 20. 结论

这份文档的目标不是“给出一些建议”，而是把 `BuffUI` 整改变成一项可以外包执行、可以代码审查、可以联机验收的具体任务。

执行者按这份文档实现后，主审只需要做两件事：

1. 对照本文逐条审查
2. 抓剩余联机安全问题

如果实现者偏离本文的阶段顺序、目标边界或禁止事项，主审应直接打回，不做模糊验收。
