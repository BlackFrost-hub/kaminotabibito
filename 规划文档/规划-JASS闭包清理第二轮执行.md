# JASS 闭包清理第二轮执行规划

## 背景

根据以下两份文档与当前源码审查结果：

- `规划文档/规划-JASS相关闭包清理执行.md`
- `规划文档/报告-JASS闭包清理执行结果.md`

第一轮整改已经完成了指定范围内的：

- `TriggerAddAction(..., () => {})`
- 一批 `safeTimerStart(..., () => {})`
- 一批 `onTick10ms(() => {})`

但当前生产代码中，仍存在未纳入上一轮范围的 JASS 相关闭包链。

这些闭包主要落在：

1. `safeTimerStart / withTimer / createDelayedCall` 路径
2. `onTick10ms` / 中心计时器订阅路径

本轮目标是继续把这些**生产代码**中的匿名闭包改成：

- 长寿具名函数
- 模块级状态
- 显式映射表

禁止继续把临时闭包传入 JASS timer 链或中心计时器链。

---

## 本轮范围

## 明确排除

以下内容不在本轮范围：

- `TS/系统/12．测试系统/**`
- 已在第一轮完成并通过 Lua 核查的文件
- `TS/lib/扩展函数/封装函数/01．通用工具/02．计时器.ts`
  说明：
  这是基础设施胶水层，本轮不动；先清业务调用方。

## 本轮纳入的生产文件

### A. 中心计时器订阅型残留

1. `TS/lib/扩展函数/Star扩展函数/Star扩展库/05．移动速度突破系统.ts`
   - `onTick10ms(() => { ... })`

### B. JASS timer / delayed-call / withTimer 残留

1. `TS/lib/扩展函数/Star扩展函数/Star扩展库/05．移动速度突破系统.ts`
   - `safeTimerStart(..., () => { ... })`
2. `TS/lib/扩展函数/封装函数/01．通用工具/03．特效.ts`
   - `withTimer(..., () => { ... })`
3. `TS/系统/02．物品系统/06．装备回复.ts`
   - `withTimer(..., () => { ... })`
4. `TS/系统/05．Buff系统/00．Buff系统.ts`
   - `onTick10ms(() => onBuffPoolCenterTimerTick())`
5. `TS/系统/05．Buff系统/01．控制抗性/04．系统初始化.ts`
   - `createDelayedCall(..., () => { ... })`
6. `TS/系统/07．地形系统/03．区域传送.ts`
   - `withTimer(..., () => { ... })`
7. `TS/系统/07．地形系统/05．激活传送点.ts`
   - `withTimer(..., () => { ... })`
8. `TS/系统/08．任务系统/00．配置表/04．NPC生成器.ts`
   - `createDelayedCall(..., () => { ... })`
9. `TS/系统/08．任务系统/09．主线配置驱动.ts`
   - `createDelayedCall(..., () => { ... })`

---

## 总体原则

## 1. 只改回调形态，不改业务逻辑

禁止：

- 顺手改时序
- 顺手改数值
- 顺手改配置
- 顺手改日志
- 顺手改 unrelated helper

允许：

- 新增顶层具名函数
- 新增模块级状态变量
- 新增 `id -> ctx` 映射表
- 把匿名闭包改成具名函数引用

## 2. 具名函数必须长寿

要求：

- 顶层定义
- 生命周期等同整个地图
- 不依赖临时闭包捕获局部变量

如果原匿名闭包依赖局部变量，必须改成：

- `timerHandleId -> ctx`
- `effectHandleId -> ctx`
- `playerId -> ctx`
- 其他稳定 key -> ctx

然后在具名函数中通过：

- `GetExpiredTimer()`
- 模块级状态
- 外部索引

反查上下文。

## 3. 不允许“具名函数外面再包一层浅箭头”

错误示例：

```ts
onTick10ms(() => onBuffPoolCenterTimerTick());
```

这仍然是匿名闭包。

正确做法：

```ts
onTick10ms(onBuffPoolCenterTimerTick);
```

如果做不到，必须先解决：

- `@noSelfInFile`
- `this` 签名
- 导入调用方式

而不是继续保留浅包装。

---

## 分文件执行建议

## 1. `05．移动速度突破系统.ts`

### 问题

同一文件仍残留两类闭包：

- `onTick10ms(() => { ... })`
- `safeTimerStart(..., () => { ... })`

### 建议

- 把中心计时器订阅部分改成具名函数，如：
  - `onMoveSpeedBreakTick`
- 把 timer 到期逻辑改成：
  - `timerHandleId -> entryUid / stateKey`
  - `onMoveSpeedBreakTimerExpire`

这是本轮优先级最高的文件。

---

## 2. `03．特效.ts`

### 问题

- `withTimer(duration, () => { ... })` 仍是匿名闭包

### 建议

按“timer handle → effect / cleanup ctx”方式改。

若 `withTimer` 不适合承接具名函数语义，则调用方改成显式：

- `CreateTimer`
- `safeTimerStart`
- 具名到期回调

但不要改 `02．计时器.ts` 本体。

---

## 3. `装备回复.ts`

### 问题

- `withTimer(0.5, () => { ... })`
- `withTimer(seg.waitSec, () => { ... })`

### 建议

这类多段逻辑通常依赖局部上下文，建议统一改成：

- `timerHandleId -> { unit, seg, state }`
- 顶层具名回调

禁止再嵌套 closure。

---

## 4. `00．Buff系统.ts`

### 问题

当前仍是：

```ts
onTick10ms(() => onBuffPoolCenterTimerTick());
```

这属于匿名浅包装，规则上仍不合格。

### 建议

直接收成：

```ts
onTick10ms(onBuffPoolCenterTimerTick);
```

如果当前 `@noSelfInFile` / `this` / 生成 Lua 存在阻碍，就先修函数签名，不接受保留包装层。

---

## 5. `控制抗性/04．系统初始化.ts`

### 问题

- `createDelayedCall(..., () => { ... })`

### 建议

如果只是一次性延迟初始化：

- 优先改成顶层具名函数
- 若有上下文，则把上下文落到模块级状态

---

## 6. `区域传送.ts`

### 问题

- `withTimer(..., () => { ... })`

### 建议

若该逻辑本质是一次延迟传送完成/清理：

- 改成 timer handle 映射 + 具名函数

---

## 7. `激活传送点.ts`

### 问题

- 多处 `withTimer(..., () => { ... })`

### 建议

这个文件前面刚做过 trigger trampoline 修复，本轮不要再大改结构。

仅做最小收口：

- debug snapshot timer → 具名函数
- init delay timer → 具名函数

---

## 8. `NPC生成器.ts`

### 问题

- `createDelayedCall(delaySec, () => { ... })`
- `createDelayedCall(0.01, () => { ... })`

### 建议

如果是“延后创建 NPC / 延后注册动作”：

- 改成 `delayedNpcSpawnCtxById`
- 顶层具名函数

---

## 9. `主线配置驱动.ts`

### 问题

- `createDelayedCall(e.delay, () => { ... })`

### 建议

这类通常依赖 action timeline 局部变量。

建议：

- 建立 `delayedStoryActionCtxById`
- 由具名函数读取并执行

不要继续让 timeline 直接 capture 局部上下文。

---

## 禁止事项

本轮明确禁止：

1. 修改测试系统
2. 修改 `02．计时器.ts` 作为第一步
3. 保留 `() => namedFn()` 这类浅包装
4. 把匿名闭包换成另一层匿名闭包
5. 顺手清 `pcall`、排序 comparator、普通数组高阶函数
6. 顺手调整 Buff/DOT/任务逻辑

---

## Lua 验收要求

执行者每改完一批，必须：

1. `npm run build`
2. 检查对应 `src/**/*.lua`

### 重点核查模式

不应再看到：

- `safeTimerStart(..., function() ... end)`
- `jass.TimerStart(..., function() ... end)`
- `withTimer(..., function() ... end)` 对应生成后的闭包链
- `onTick10ms(function() ... end)`

应变成：

- `safeTimerStart(..., onXxxExpire)`
- `jass.TimerStart(..., onXxxExpire)`
- `onTick10ms(nil, onXxxTick)` 或等价具名引用

---

## 最终验收标准

### 代码层

1. 本文档列出的生产文件中，不再存在：
   - `safeTimerStart(..., () => {})`
   - `createDelayedCall(..., () => {})`
   - `withTimer(..., () => {})`
   - `onTick10ms(() => {})`
   - `() => namedFn()` 这类浅箭头包装

2. 所有新增回调函数都是顶层具名函数。

3. 需要上下文的地方，使用稳定映射显式保存状态。

### Lua 层

1. 对应生成 Lua 中，不再出现本轮目标位置的匿名 `function() ... end` 注册到：
   - `TimerStart`
   - `safeTimerStart`
   - 中心计时器订阅入口

### 构建层

1. `npm run build` 通过。

### 功能回归

至少回归：

- 移动速度突破周期逻辑
- 特效自动销毁
- 装备回复延迟段
- Buff 池周期递减
- 区域传送
- 激活传送点初始化
- NPC 延迟生成
- 主线动作延迟执行

---

## 执行者回填模板

### 已完成

- 

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
