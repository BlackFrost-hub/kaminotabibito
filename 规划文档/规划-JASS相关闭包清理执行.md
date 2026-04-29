# JASS 相关闭包清理执行规划

## 背景

当前项目已经完成一轮核心系统与部分业务系统的 JASS 回调闭包整改，但生产代码里仍残留两类问题：

1. 通过 `safeTimerStart / dzTimerStart / createDelayedCall / withTimer` 等路径，把匿名闭包挂到 JASS timer 链上。
2. 通过 `onTick10ms(() => ...)` 这类中心计时器订阅，把匿名闭包长期保存在 Lua 侧回调表中。

虽然第二类不一定“直接传给 JASS”，但按现规则口径：

- 任何会进入 JASS 引擎的回调链，必须使用长寿具名函数
- 不允许创建临时闭包再交给 timer / trigger / frame / unit-group 等引擎链路

因此本次整改目标是：

- 清理**生产代码**中的 JASS timer 相关匿名闭包
- 清理**生产代码**中的中心计时器订阅型匿名闭包
- 保持行为不变，不扩 scope，不顺手做 unrelated 重构

## 范围

### 明确排除

以下内容**不在本轮范围**：

- `TS/系统/12．测试系统/**`
- 已完成整改的直接 `TriggerAddAction(..., () => {})` 文件：
  - `TS/lib/扩展函数/Star扩展函数/Star扩展库/05．移动速度突破系统.ts`
  - `TS/lib/扩展函数/封装函数/04．硬件输入/04．键盘函数.ts`
  - `TS/lib/扩展函数/封装函数/05．泄露审计/10．聊天命令.ts`
  - `TS/系统/02．物品系统/07．装备提取.ts`
  - `TS/系统/03．技能系统/06．AI自动使用技能/01．核心功能.ts`
  - `TS/系统/07．地形系统/05．激活传送点.ts`

### 本轮纳入

#### A. JASS timer 相关匿名闭包

1. `TS/lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统.ts`
2. `TS/lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统.ts`
3. `TS/lib/扩展函数/封装函数/01．通用工具/02．计时器.ts`
4. `TS/lib/扩展函数/封装函数/02．音效系统/02．音效池.ts`
5. `TS/lib/扩展函数/封装函数/02．音效系统/04．MP3音效播放.ts`
6. `TS/lib/扩展函数/封装函数/07．镜头函数/02．震动计时器.ts`
7. `TS/系统/02．物品系统/03．物品加工.ts`
8. `TS/系统/02．物品系统/04．装备成长.ts`
9. `TS/系统/08．任务系统/02．任务管理器/04．QuestManager.ts`

#### B. 中心计时器订阅型匿名闭包

1. `TS/lib/扩展函数/封装函数/03．漂浮文字/01．回收机制.ts`
2. `TS/系统/00．核心系统/00．玩家系统/02．基础核心.ts`
3. `TS/系统/03．技能系统/07．技能吟唱条/02．渲染.ts`
4. `TS/系统/04．伤害系统/04．伤害显示/02．核心功能.ts`
5. `TS/系统/05．Buff系统/00．Buff系统.ts`
6. `TS/系统/06．经济系统/00．宝箱系统/03．宝箱核心.ts`

## 总体原则

### 1. 只改回调形态，不改业务语义

禁止：

- 顺手调整时序
- 顺手改数值
- 顺手改日志
- 顺手合并 unrelated helper

允许：

- 新增具名 trampoline
- 新增 `id -> callbackKey` / `playerId -> state` / `timerHandleId -> key` 映射
- 把匿名闭包搬成长寿具名函数

### 2. 命名函数必须长寿

具名函数要求：

- 顶层定义
- 生命周期等同整个地图
- 不依赖临时闭包捕获局部变量

如果原闭包依赖局部上下文，必须显式落盘到：

- `timerHandleId -> dataKey`
- `playerId -> state`
- `buffId -> runtime`
- 其他稳定索引表

再由具名函数反查并执行。

### 3. 不引入新的匿名回调替代旧匿名回调

错误示例：

```ts
safeTimerStart(t, 1.0, false, () => runById(id));
```

这仍然不合规。

正确方向：

```ts
timerDataByHid[hid(t)] = id;
safeTimerStart(t, 1.0, false, onSomeTimerExpire);
```

## 分阶段实施

## 阶段一：先收 JASS timer 相关匿名闭包

### 目标

清掉所有：

- `safeTimerStart(..., () => {})`
- `dzTimerStart(..., () => {})`
- `createDelayedCall(..., () => {})`
- `withTimer(..., () => {})`

其中如果底层最终仍进入 JASS timer，就必须使用具名函数。

### 推荐模式

#### 模式 A：单例 timer

适用于：

- 全局唯一 timer
- 不需要多个并发实例

做法：

- 顶层维护单一状态变量
- timer 回调改成一个具名函数

#### 模式 B：timer handle 映射

适用于：

- 每次创建独立 timer
- 需要并发多个实例

做法：

- 维护 `timerHandleId -> payload`
- 具名回调里 `GetExpiredTimer()` 取 handle，再反查 payload

示意：

```ts
const someDataByTimerHid: Record<number, SomePayload | undefined> = {};

function onSomeTimerExpire(this: void): void {
  const t = jass.GetExpiredTimer();
  if (!t) return;
  const hid = jass.GetHandleId(t) as number;
  const payload = someDataByTimerHid[hid];
  if (!payload) return;
  delete someDataByTimerHid[hid];
  // 原逻辑
}
```

### 阶段一文件建议顺序

优先从简单、局部、低耦合文件开始：

1. `TS/lib/扩展函数/封装函数/02．音效系统/04．MP3音效播放.ts`
2. `TS/lib/扩展函数/封装函数/07．镜头函数/02．震动计时器.ts`
3. `TS/lib/扩展函数/Star扩展函数/Star扩展库/03．硬直暂停系统.ts`
4. `TS/lib/扩展函数/封装函数/02．音效系统/02．音效池.ts`
5. `TS/系统/08．任务系统/02．任务管理器/04．QuestManager.ts`
6. `TS/系统/02．物品系统/03．物品加工.ts`
7. `TS/系统/02．物品系统/04．装备成长.ts`
8. `TS/lib/扩展函数/Star扩展函数/Star扩展库/04．快速Buff系统.ts`
9. `TS/lib/扩展函数/封装函数/01．通用工具/02．计时器.ts`

### 阶段一特别说明：`02．计时器.ts`

这个文件是底层 helper，改它时要格外保守。

要求：

- 不要先改 API 形状
- 不要破坏现有调用方
- 如果要改 `createDelayedCall` / `createRepeatingCall` 内部实现，优先保留现有导出接口

## 阶段二：收中心计时器订阅型匿名闭包

### 目标

清掉：

- `onTick10ms(() => {})`
- 其他中心计时器订阅型临时闭包

### 推荐模式

#### 模式 C：直接订阅具名函数

如果原闭包不依赖局部上下文：

- 直接改成具名函数最简单

#### 模式 D：具名函数 + 模块级状态

如果原闭包依赖模块状态：

- 把状态放到模块级
- 订阅顶层具名函数

### 阶段二文件建议顺序

1. `TS/lib/扩展函数/封装函数/03．漂浮文字/01．回收机制.ts`
2. `TS/系统/00．核心系统/00．玩家系统/02．基础核心.ts`
3. `TS/系统/03．技能系统/07．技能吟唱条/02．渲染.ts`
4. `TS/系统/04．伤害系统/04．伤害显示/02．核心功能.ts`
5. `TS/系统/05．Buff系统/00．Buff系统.ts`
6. `TS/系统/06．经济系统/00．宝箱系统/03．宝箱核心.ts`

## 禁止事项

本轮明确禁止：

1. 把匿名闭包换成另一层匿名闭包
2. 因为编码问题整文件重写中文重文件
3. 顺手修改测试系统
4. 顺手改 UI、Buff、DOT、任务逻辑
5. 把 `pcall(() => ...)`、排序 comparator、普通数组高阶函数一并纳入本轮

本轮只看：

- JASS timer 相关回调
- 中心计时器订阅相关回调

## Lua 验收要求

执行者每改完一批，必须：

1. `npm run build`
2. 检查对应 `src/**/*.lua`

### 阶段一 Lua 验收

要确认：

- 不再出现 `safeTimerStart(..., function() ... end)` 对应的临时闭包注册
- 不再出现 `TimerStart(..., function() ... end)` 对应的匿名 timer 回调
- 改成：
  - `safeTimerStart(..., onXxx)`
  - `jass.TimerStart(..., onXxx)`

### 阶段二 Lua 验收

要确认：

- 不再出现 `onTick10ms(function() ... end)` 这类临时回调订阅
- 改成具名函数订阅

## 最终验收标准

### 代码层

1. 本文档列出的生产文件中，不再存在：
   - `safeTimerStart(..., () => {})`
   - `dzTimerStart(..., () => {})`
   - `createDelayedCall(..., () => {})`
   - `withTimer(..., () => {})`
   - `onTick10ms(() => {})`

2. 所有新增回调函数都是顶层具名函数。

3. 需要上下文的地方，使用稳定映射显式保存状态，不依赖闭包捕获。

### Lua 层

1. 对应生成 Lua 中，不再出现本轮目标位置的匿名 `function() ... end` 注册到：
   - `TriggerAddAction`
   - `TimerStart`
   - `safeTimerStart` trampoline 输入
   - 中心计时器订阅入口

### 构建层

1. `npm run build` 通过。

### 功能回归

至少回归：

- 音效自动销毁
- 镜头震动停止
- 物品加工完成
- 装备成长分段推进
- Quest 时间限制
- Buff 周期推进
- 漂浮文字回收
- 吟唱条刷新
- 宝箱周期逻辑

## 执行者回填模板

执行完成后，请回填：

### 已完成

- 阶段一：
- 阶段二：

### 变更文件

- 

### Lua 核查

- 已核查文件：
- 发现问题：

### 构建结果

- `npm run build`：

### 功能回归

- 已回归：
- 未回归：

### 风险与遗留

- 
