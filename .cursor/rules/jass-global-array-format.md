---
description: JASS 全局数组在 TS 中读写统一用 (jass as any).udg_XXX[index]，同帧 JASS 刚写需 0.00s 延后读
---

# JASS 全局数组变量：TS/Lua 统一格式

## 与 JASS 共用的数组：必须用 `(jass as any).udg_XXX[index]`

凡需与 JASS 读写同一份数据的**数组**（如 `udg_TempReal`、`udg_TempUnit`、`udg_TempInteger` 等），在 TS 里统一用：

- **读**：`(jass as any).udg_XXX != null ? (jass as any).udg_XXX[index] : undefined`，或先 `const jr = (jass as any).udg_TempReal` 再 `jr[index]`（仅作 table 引用，不存函数）
- **写**：`(jass as any).udg_XXX[index] = value`，或通过上面同一引用写 `jr[index] = value`

**禁止**用 `g.udg_TempReal[index]`、`gu.udg_TempReal[index]` 等 `jass.globals` 的写法做与 JASS 互通的数组下标访问，否则可能读到/写到另一块内存，引擎与 Lua 不同步。

## 单值全局（非数组）

非数组的单值全局（如 `udg_TempHp`、`udg_TempScore`）继续用 `g.udg_XXX` 无妨，按项目约定即可。

## 同帧内 JASS 刚写的值

若在「执行 JASS 触发队列」的**同一帧**内去读 JASS 刚写的 `udg_XXX[index]`，Lua 侧可能尚未同步，读到的仍是旧值。此时应：

- 用 **0.00 秒计时器** 延后读：在回调里再读 `(jass as any).udg_XXX[index]`，读后立即清空该下标（若约定由 TS 负责清空）。
- 或由 JASS 在触发末尾清空该下标，避免残留。

## 参考

- 装备移速、单位狂暴：`(jass as any).udg_TempReal[1]`、`(jass as any).udg_TempUnit[1]`
- 伤害事件显示伤害：`(jass as any).udg_TempReal[10]` 读/写/清空，且必须 0.00s 计时器延后读；`[1]` 写最终伤害
- `udg_TempUnit` 下标约定见 `temp-unit-array.md`
