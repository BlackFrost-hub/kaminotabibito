# DzAPI 联机 UI 安全规范与 N 槽架构说明

> 适用项目：TSTL → Lua 魔兽地图  
> 目标读者：UI 开发程序员  
> 本文档基于社区多年掉线排查经验，配合本项目的任务 UI 已有实践，
> 说明"为什么这么写不会掉线、怎么写才不会掉线"。
> **与项目规则文件的关系**：
> - 本文档是 `n-slot-ui-symmetric-execution.mdc` 和 `lua-gc-async.mdc` 的落地执行手册
> - 具体代码细节（Frame 类型、对齐、滚动数值）见 `ui-frame-types.mdc`
> - 本文档是"为什么这么写"，规则文件是"必须怎么写"，两者配合使用

---

## 一、一句话记住所有规则

> **全端同时做同样的事，只有像素在最后一刻分叉。**

所有可能影响全局状态的操作（创建、删除、修改文字/贴图、读写全局表），
必须在每一个玩家的电脑上以相同的次数和顺序执行。
唯一允许不同的事情，是某一个帧对某一个玩家显示还是隐藏（以及音效、聊天消息）。

---

## 二、核心概念：同步 vs 异步

| 概念 | 含义 | 典型操作 |
|------|------|---------|
| **同步** | 所有玩家执行完全相同的代码路径 | 创建帧、设置文本、设置贴图、读写全局变量、启动计时器 |
| **异步（本地）** | 只在某些玩家电脑上执行的代码 | `DzFrameShow`/`Hide`、`StartSound`（指定玩家）、`DisplayTextToPlayer` |

**关键区分**：
- `DzFrameSetText` → **同步**，修改帧的内容，不在本地路径里执行
- `DzFrameSetTexture` → **同步**，同上
- `DzFrameShow` / `DzFrameHide` → **异步**，可以进本地路径

---

## 三、为什么一在本地路径里写内容就容易掉线？

魔兽的联机模型要求所有玩家对"游戏世界"的推演完全一致。
当你在 `if GetLocalPlayer() == ...` 里修改了帧的文字或贴图：

1. 只有那个玩家的电脑上帧的内容被改变了。
2. 如果这个帧后来被任何全局逻辑引用（比如 sync 回调、计时器遍历、刷新循环），
   不同玩家看到的内容不同，执行路径就会分叉。
3. 分叉的瞬间 → **desync（掉线）**。

社区口诀：
> **本地玩家睁大眼，除了显示不要浪**

---

## 四、⚠️ 关键前提：只有 N 槽设计下，"纯显示/隐藏"才成立

**这条必须写在最前面——它是所有后续规则能够生效的前提条件。**

N 槽模型 = 每个玩家的电脑上都创建 N 套完整的 UI 壳。

- N = 最大玩家数（比如 4 人图，N = 4）
- 玩家 1 的电脑上：创建了槽位 0、槽位 1、槽位 2、槽位 3，共 4 套壳
- 玩家 2 的电脑上：也创建了槽位 0、槽位 1、槽位 2、槽位 3，也是 4 套壳
- 玩家 3、玩家 4 同理
- 所以整个游戏里一共被创建了 N × N = 16 套帧壳（4 个玩家 × 每人 4 套），不是只有 4 套

每套壳里装什么？所有客户端上，槽位 i 的内容完全一样——都装着玩家 i 的数据。

区别只在于显隐：

- 玩家 1 的电脑上：槽位 1 显示，槽位 0、2、3 隐藏
- 玩家 2 的电脑上：槽位 2 显示，槽位 0、1、3 隐藏
- 以此类推

如果一个 UI 面板只有一套壳，却需要为多个玩家服务（比如每个人都打开同一个任务面板），
那么当玩家 1 打开时，文本要改成玩家 1 的内容；玩家 2 打开时，又要改成玩家 2 的内容。
单套壳下，`setText` 必然要进入 `GetLocalPlayer()` 分支才能做到"互不干扰"，
**而这正是社区规则严禁做的事情**。

**只有 N 槽模型**（每个客户端预先创建 N 套完整的帧壳），
才能让"所有客户端同步写内容 + 最后本地门控显隐"这个安全范式成立。
因为每个槽位的内容是固定的——槽位 0 永远放玩家 0 的数据，槽位 1 永远放玩家 1 的数据——
不需要在任何本地路径里切换文本或贴图，不同玩家的操作不会互相覆盖帧内容。

**因此：**

> **凡是多个玩家可能同时操作或查看的 UI 面板，必须使用 N 槽设计。**  
> **只有 N 槽设计下，`DzFrameShow`/`Hide` 才能安全地放进 `GetLocalPlayer()` 分支。**  
> **单套壳 UI 想靠纯显隐安全地服务多玩家，在联机环境里做不到。**

---

## 五、N 槽 UI 模型：唯一能让"纯显隐"成立的方案

### 5.1 问题

如果整个 UI 只有一套壳（比如一个任务面板），却要为多个玩家服务，
那么当玩家 1 打开面板时，文本必须改成玩家 1 的数据，
玩家 2 打开时又要改成玩家 2 的数据。
单套壳里，setText 必然要进本地路径才能不互相干扰，而这正是违规操作。

### 5.2 解决方案：N 槽模型

- N = 最大玩家数（例如 4）
- 每个客户端创建 N 套完整帧壳（帧名带后缀如 `_s0`、`_s1`、`_s2`、`_s3`）
- 槽位 i 永远服务 `Player(i)`

示意图：

|  | 玩家 1 的电脑 | 玩家 2 的电脑 | 玩家 3 的电脑 | 玩家 4 的电脑 |
|--|-------------|-------------|-------------|-------------|
| 槽位 0（玩家 0 数据） | 创建了，隐藏 | 创建了，隐藏 | 创建了，隐藏 | 创建了，显示 |
| 槽位 1（玩家 1 数据） | 创建了，显示 | 创建了，隐藏 | 创建了，隐藏 | 创建了，隐藏 |
| 槽位 2（玩家 2 数据） | 创建了，隐藏 | 创建了，显示 | 创建了，隐藏 | 创建了，隐藏 |
| 槽位 3（玩家 3 数据） | 创建了，隐藏 | 创建了，隐藏 | 创建了，显示 | 创建了，隐藏 |

关键：所有槽位都在所有电脑上创建了，且所有电脑上槽位 i 的内容（文本、贴图）完全一致。唯一不同的是谁显示、谁隐藏。

数据流：

1. 所有客户端读取玩家 i 的任务数据（全局任务管理器已同步好的数据）
2. 所有客户端把槽位 i 的帧文字、贴图、布局全部更新为玩家 i 的内容
3. 所有客户端根据"本地玩家是谁"来决定：
   - 自己是槽位 i 的主人 → `DzFrameShow`
   - 自己不是 → `DzFrameHide`

结果：

- 每个客户端电脑上，所有槽位的内容完全相同
- 只有显隐不同
- `setText`/`setTexture` 全部在同步路径，符合规则
- 任何人操作 UI，不会造成其他人的执行路径分叉

### 5.3 方案对比

| 方案 | 每端帧数量 | setText 位置 | 显隐控制 | 联机安全性 | 能否服务多玩家 |
|------|-----------|-------------|---------|-----------|--------------|
| 单套壳 | 1 套 | 必须进本地路径 | 无处安放 | ❌ 极易掉线 | 不能安全地服务 |
| N 槽 | N 套 | 全端同步 | 本地门控 | ✅ 安全 | ✅ 安全地服务 |

核心结论：只有 N 槽设计下，`DzFrameShow`/`Hide` 单独放在 `GetLocalPlayer()` 分支里才是安全的。单套壳想做同样的事，必然违规。

性能说明：N 槽模型用额外的帧创建开销（每端多建几套壳）换取执行路径的绝对统一。这些隐藏的帧不渲染、不吃 GPU，仅占用少量内存，是联机安全与开发维护成本之间的最优平衡。社区千万级火图验证可行。

---

## 六、代码范例（标准写法）

### 6.1 刷新 N 槽 UI 的标准流程

```typescript
function rebuildUIForAllSlots(allPlayerData: PlayerData[]): void {
  for (let slot = 0; slot < MAX_PLAYERS; slot++) {
    const frame = slotFrames[slot];
    const data = allPlayerData[slot];

    // ① 同步设置内容——所有客户端都执行
    DzFrameSetText(frame.titleText, data.title);
    DzFrameSetText(frame.descText, data.description);
    DzFrameSetTexture(frame.icon, data.iconPath);
    DzFrameSetPoint(frame.root, FRAME_ANCHOR_TOPLEFT, frame.parent, FRAME_ANCHOR_TOPLEFT, slotX[slot], slotY[slot]);

    // ② 异步显隐——只有对应玩家看到自己的面板
    if (GetLocalPlayer() === Player(slot)) {
      DzFrameShow(frame.root);
    } else {
      DzFrameHide(frame.root);
    }
  }
}
```

### 6.2 错误写法（严禁）

```typescript
// ❌ 绝对禁止：在本地路径里设置内容
if (GetLocalPlayer() === Player(0)) {
  DzFrameSetText(frame, "只有玩家0能看到");  // 其他玩家帧的内容不一致
  DzFrameShow(frame);
}
```

### 6.3 pcall 安全用法

```typescript
// ✅ 正确：具名函数引用，不每次创建匿名闭包
function safeCreateFrame(): void {
  // 实际的帧创建逻辑
}

const ok = pcall(safeCreateFrame);
// 不要用 pcall(function() ... end) 或 pcall(() => ...)
// 每次创建匿名函数会产生临时对象，增加 GC 压力
// GC 时机在不同客户端可能不同，是隐蔽的异步源
```

### 6.4 回调铁律

所有进入 JASS/Dz 系统的回调（帧点击、滚轮、键盘、计时器、ForGroup）：

- 必须使用模块顶层具名函数
- 禁止传匿名箭头 `() => ...` 或匿名 `function() ...`
- 动态参数通过全局表或字符串 key 传递，不通过闭包捕获

```typescript
// ✅ 正确
function onMyFrameClick(): void {
  // 处理点击
}
frame.setScript(FRAME_EVENT_MOUSE_UP, onMyFrameClick);

// ❌ 错误
frame.setScript(FRAME_EVENT_MOUSE_UP, () => {
  // 匿名闭包，高频下危险
});
```

---

## 七、自检清单

每次写 UI 代码时，问自己：

- 创建帧的代码是否在所有客户端都执行了？（不在 `GetLocalPlayer` 内）
- 设置文本/贴图的代码是否在所有客户端都执行了？
- 只有 `DzFrameShow`/`Hide` 和音效放在 `GetLocalPlayer` 分支里？
- 传给 `DzFrameSetScriptByCode` / `TimerStart` 的是不是具名函数？
- pcall 里是不是具名函数引用，而不是匿名体？
- 有没有在任何本地分支里写全局变量或表？
- sync=true 回调内，全局状态修改是否在 `GetLocalPlayer()` 判断**外**？纯 UI 操作是否在判断**内**？
- 这个面板是否需要被多个玩家操作或查看？→ 是的话，**必须用 N 槽设计**
- 只有 N 槽设计下，显隐才能安全放进本地路径——不是 N 槽就不要这么做

---
## 滚轮 / 拖拽的高频 UI 事件：sync 规则（待验证）

### 结论（待联机实测）
在 N 槽架构下，滚轮（`EVENT_MOUSE_WHEEL`）和滑块拖拽（`EVENT_MOUSE_MOVE` + 按下态）**可以使用 `sync=false`**，且优于 `sync=true`。

### 为什么不能用 `sync=true`
拖拽 1 秒 ≈ 60+ 条同步命令，滚轮快速滚动同理。高频同步命令会灌爆 War3 的锁步网络队列 → **全员掉线**。

### 为什么 `sync=false` 在 N 槽下安全
1. **写入的变量是槽位私有的**（如 `currentPage`、`expandedQuestId`），挂在槽位级 `ctx` 下，不污染全局状态。
2. **读取路径被 `GetLocalPlayer()` 隔离**：这些变量只在当前槽位的显隐/翻页逻辑中被读取。
3. **其他客户端的该槽位是隐藏的**：状态不一致的槽位在其他客户端不可见，差异不会产生逻辑影响。

### 前提（必须全部满足）
- [x] 项目使用 N 槽架构
- [x] 写入的变量只挂在槽位私有的 `ctx` / 管理器中
- [x] 这些变量**绝不**参与跨槽位逻辑或全房同步计算
- [x] 读取这些变量的路径有 `GetLocalPlayer()` 保护

### 若改为 `sync=true` 的风险
- 拖拽/快速滚动时网络命令密度过高
- 不同客户端因网络波动执行次数可能不同 → 执行路径分叉 → desync

## 八、与现有任务 UI 的对齐

项目 `TS/系统/08．任务系统/04．任务UI拆分/` 以及 `12．任务UI管理器.ts` 已实践：

- 帧创建和注册全端对称执行
- `setText` / `setVisible` 全端同步
- 回调走命名函数 + 管理器单列分发
- **热键和帧点击统一用 `sync=true` 注册**（`registerKeyUpSync` / `setFrameClickEvent(..., true)`）
- **sync=true 回调内分层**：全局状态（`currentCategory` / `currentPage` / `isVisible` / `expandedQuestId`）在所有客户端同步修改，纯 UI 操作（`DzFrameShow` / 音效）仅在 `GetLocalPlayer() === triggerPlayer` 时执行
- pcall 体统一用具名函数引用

### ⚠️ 重要：sync=true 键盘事件的频率限制

`registerKeyUpSync` 走 `DzTriggerRegisterKeyEvent(..., sync=true)`，每次松键产生一条网络同步命令。
非主机玩家高频连按（如快速切换 1/2/3 Tab）可能灌爆同步队列导致掉线。

当前任务 UI 之所以安全，是因为：
- 切 Tab 后 `currentCategory` 已变更，重复按同一键时 `switchCategoryState` 直接 return（幂等）
- J 键 toggle 也自带幂等
- 实测中玩家不会以 >10次/秒 的频率疯狂切 Tab

如果未来有高频热键需求，改用帧点击代理（sync=true 帧回调的触发成本远低于键盘 sync 命令）。

### sync=true 回调内分层模式

键盘和帧点击的 sync=true 回调中，必须按以下模式分层：

```typescript
// ✅ 正确：sync=true 回调内的分层模式
function handleCategoryHotkey(player: any, category: QuestType): void {
  // ① 全局状态修改——所有客户端同步执行（不受 GetLocalPlayer 限制）
  switchCategoryState(category);  // currentCategory / currentPage / expandedQuestId

  // ② 纯 UI 操作——只在按键者本地执行
  if (player === GetLocalPlayer()) {
    switchCategoryUI(category);   // DzFrameShow / 滚动条 / 音效
  }
}
```

```typescript
// ❌ 错误：全局状态修改在本地判断内
function handleCategoryHotkey(player: any, category: QuestType): void {
  if (player !== GetLocalPlayer()) return;  // 其他客户端跳过
  switchCategoryState(category);  // ← 只有按键者修改了 currentCategory → desync
  switchCategoryUI(category);
}
```

后续新增 UI 功能，请参考现有实现，并遵循本文档规则。

> **同步修数据，异步管显隐。**  
> **N 槽壳全建，闭包不进 Dz。**  
> **sync=true 全房触发，状态同步显隐本地。
