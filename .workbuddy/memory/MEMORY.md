# 项目长期备忘（syzl 魔兽地图 TSTL）

## TSTL require `as {...}` 类型断言的三大盲区（运行时才炸，TS 零报错）

1. **解构字段名写错**：`const { X } = require(...) as { X: ... }` —— 断言里的字段名写错（尤其是旧代码用英文名导出的模块）编译器不报错，运行时 X 为 nil 调用才崩。新增解构导入前必须 grep 目标模块确认 `export function/const <名字>` 真实存在。
2. **class 实例方法标 `this: void`**：手写内联返回类型 `{ 停止: (this: void) => void }` 会让 TSTL 编译成点调用不传 self，而 class 方法是 `function(self)` → "attempt to index a nil value (local 'self')"。凡返回类实例/带方法对象，必须 `import type` 导入模块真实接口（方法签名不带 this 注解 → 冒号调用正确带 self），类型导入会被完全擦除、无运行时开销。案例：食人魔雷霆震怒 → 方向抵抗牵引控制器（2026-09-08 修复）。
3. **无 `@noSelfInFile` 定义文件的导出函数带 self**：定义侧文件头没有 `/** @noSelfInFile */` 且导出函数无显式 this → 生成 Lua 是三参 `function exports.f(self, a, b)`。调用方断言若标 `this: void` → 点调用只传 2 参、末参变 nil（案例：openNpcDialog 祖地对话崩溃，`UI函数.lua:54 data nil`）；断言**不标 this** → TSTL 自动补 self 位（点调用变冒号 `obj:f(a,b)`，解构成本地再调用则补 nil 首参 `f(nil, a, b)`，均安全）。修复惯例：**改调用方断言**去掉 this: void，不改定义侧（会破坏现有正常冒号调用方）。判断口诀：断言的 this 标注必须匹配定义文件真实编译产物——定义文件有 @noSelfInFile → 标 this: void；没有 → 不标。

## 其他

- **扩展单位状态位必须走 japi 变体**：操作 `ConvertUnitState(0x12/0x15/0x20/0x23/0x25/0x51...)` 等扩展状态，读写都要用 `jass.japi` 的 `Get/SetUnitState`；`jass.common` 原生变体对扩展状态**静默失败**（读恒 0、写丢弃、不报错），只有标准状态（生命/魔法）可用原生。怀疑状态没生效时加"写入后回读"日志验证。
- 中文标识符在生成 Lua 中转义为 UTF-16 hex（如 `施加移速提升Buff` → `_____65BD...`），grep 生成 Lua 要按 hex 或转义别名搜。
- `SetUnitPathing(u, false/true)` 关闭/恢复单位碰撞是项目既有惯例（Saber W、铃仙 R、咲夜 RD），直接恢复不做重叠补偿。
- 移速 >522 突破只走 `施加移速提升Buff` / 装备移速 两个封装（内部自动接 SOS 突破系统）；直接 SetUnitMoveSpeed/AIms 被引擎钳制 522。
- 英雄 Buff 图标标准 80×80；AI 生成图标避免画具体动漫人物（形象不可控），用纯意象。
- 局部构建：`npm run build:files -- "<file>"`；用户自己开地图测试，绝不擅自打包。
