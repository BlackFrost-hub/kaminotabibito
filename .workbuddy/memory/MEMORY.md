# 项目长期备忘（syzl 魔兽地图 TSTL）

## TSTL require `as {...}` 类型断言的三大盲区（运行时才炸，TS 零报错）

1. **解构字段名写错**：`const { X } = require(...) as { X: ... }` —— 断言里的字段名写错（尤其是旧代码用英文名导出的模块）编译器不报错，运行时 X 为 nil 调用才崩。新增解构导入前必须 grep 目标模块确认 `export function/const <名字>` 真实存在。
2. **class 实例方法标 `this: void`**：手写内联返回类型 `{ 停止: (this: void) => void }` 会让 TSTL 编译成点调用不传 self，而 class 方法是 `function(self)` → "attempt to index a nil value (local 'self')"。凡返回类实例/带方法对象，必须 `import type` 导入模块真实接口（方法签名不带 this 注解 → 冒号调用正确带 self），类型导入会被完全擦除、无运行时开销。案例：食人魔雷霆震怒 → 方向抵抗牵引控制器（2026-09-08 修复）。
3. **无 `@noSelfInFile` 定义文件的导出函数带 self**：定义侧文件头没有 `/** @noSelfInFile */` 且导出函数无显式 this → 生成 Lua 是三参 `function exports.f(self, a, b)`。调用方断言若标 `this: void` → 点调用只传 2 参、末参变 nil（案例：openNpcDialog 祖地对话崩溃，`UI函数.lua:54 data nil`）；断言**不标 this** → TSTL 自动补 self 位（点调用变冒号 `obj:f(a,b)`，解构成本地再调用则补 nil 首参 `f(nil, a, b)`，均安全）。修复惯例：**改调用方断言**去掉 this: void，不改定义侧（会破坏现有正常冒号调用方）。判断口诀：断言的 this 标注必须匹配定义文件真实编译产物——定义文件有 @noSelfInFile → 标 this: void；没有 → 不标。

## 其他

- **聊天命令机制是好的，不要"修"它（2026-09-10 用户明确纠正）**：`12．聊天命令事件中心` 用 catch-all 注册（`TriggerRegisterPlayerChatEvent(trig, Player(i), "", false)`）+ 动作里 `GetEventPlayerChatString()` 取完整聊天串、按字符串查 Map 派发——这是完全正确可用的写法，全项目 140 处命令注册正常工作。**曾经（含本助手）误判为 bug**：以为派发依赖 `GetEventPlayerChatStringMatched()` 且只匹配到空字符串；实际派发**根本不使用**该 API，所以"必须按 exactMatchOnly=true 注册命令字符串"的前提不成立。另注：catch-all 只在发言玩家那次事件触发一次，不是"×16 玩家遍历"，无性能问题。教训：判断事件派发类 bug 前，先确认动作函数实际调用了哪个 `GetEvent...` API，再下结论。
- **`按名字反查任意单位ID` 的颜色码担忧已证伪（2026-09-10）**：曾怀疑配置里 `Boss单位名` 带 `|cffff0000（BossLV25）|r` 颜色码会让反查返回 undefined、导致整条配置被 `初始化配置缓存` 静默 `continue` 跳过。**实测证伪**：蜘蛛女皇（`nsbm_蜘蛛女皇`，Boss单位名带色码）的死亡日志正常打出"触发流水"，而该日志只在配置成功进入 `已解析配置表` 后才会输出（触发单位ID 与 Boss单位ID 任一为空都会被 continue 跳过）→ 反查对颜色码工作正常。排查"配置没生效"时不要优先怀疑这里。
- **加诊断日志必须先确认它真被调用（2026-09-10 教训）**：给 `01．死亡触发Boss.ts` 加概率掷骰日志时，`概率判定带日志` 函数写好了但接线漏了（`满足概率触发条件` 里仍保留原始 `return GetRandomInt(1,100) <= chance`），结果进图日志缺"概率判定"行，一度被误读为"chance<=0 配置没加载"。**新增日志后先 grep 自己的函数名确认调用点存在**，再看日志下结论。
- **`01．死亡触发Boss.ts` 有有意保留的未提交改动，禁止 git checkout**：`创建Boss并广播` 里 CreateUnit 的 owner 是 `中立被动玩家`（`Player(jass.PLAYER_NEUTRAL_PASSIVE)`），而 HEAD 版本是 `GetOwningPlayer(dyingUnit)`（继承击杀者归属）。这是修"触发后应立即中立被动"的正式改动，尚未提交。改这个文件时手改、不要整体还原。
- **扩展单位状态位必须走 japi 变体**：操作 `ConvertUnitState(0x12/0x15/0x20/0x23/0x25/0x51...)` 等扩展状态，读写都要用 `jass.japi` 的 `Get/SetUnitState`；`jass.common` 原生变体对扩展状态**静默失败**（读恒 0、写丢弃、不报错），只有标准状态（生命/魔法）可用原生。怀疑状态没生效时加"写入后回读"日志验证。
- 中文标识符在生成 Lua 中转义为 UTF-16 hex（如 `施加移速提升Buff` → `_____65BD...`），grep 生成 Lua 要按 hex 或转义别名搜。
- `SetUnitPathing(u, false/true)` 关闭/恢复单位碰撞是项目既有惯例（Saber W、铃仙 R、咲夜 RD），直接恢复不做重叠补偿。
- 移速 >522 突破只走 `施加移速提升Buff` / 装备移速 两个封装（内部自动接 SOS 突破系统）；直接 SetUnitMoveSpeed/AIms 被引擎钳制 522。
- 英雄 Buff 图标标准 80×80；AI 生成图标避免画具体动漫人物（形象不可控），用纯意象。
- 局部构建：`npm run build:files -- "<file>"`；用户自己开地图测试，绝不擅自打包。
