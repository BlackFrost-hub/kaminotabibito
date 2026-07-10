# DzAPI 规则索引

DzAPI 相关改动先判断它是“联机执行路径”“帧与 FDF 细节”“回调生命周期”还是“单位状态边界”。不要只因文件名含 UI 就跳过同步与回调规则。

| 场景 | 先读 |
|------|------|
| 联机 UI、N 槽、Timer、sync 回调、GetLocalPlayer 分层 | [n-slot-ui-symmetric-execution.mdc](n-slot-ui-symmetric-execution.mdc) |
| JASS 或 Dz 回调、闭包、pcall、GC、异步与同步边界 | [lua-gc-desync-heuristics.mdc](lua-gc-desync-heuristics.mdc) |
| Frame 类型、FDF、TOC、滚动条、Frame 创建或客户端崩溃 | [ui-frame-types.mdc](ui-frame-types.mdc) |
| SetUnitState、最大生命、最大魔法或 JAPI UnitState | [unit-state-jass-japi-boundary.mdc](unit-state-jass-japi-boundary.mdc) |

## 联机 UI 的最小阅读组合

涉及联机 UI 时，至少同时读取“对称执行”与“GC / 回调安全”两份规则；FDF 或 Frame 类型问题再补读对应细则。

| 改动 | 组合 |
|------|------|
| 只改 Frame 类型、锚点、FDF 或事件 ID | `ui-frame-types.mdc`；若进入回调，再补回调安全规则 |
| 改点击、滚轮、键盘、Timer 或 GetLocalPlayer | 对称执行 + 回调安全 |
| 改同步游戏状态 | 先确认同步上下文，再按对称执行规则审查全端次数与分支 |
| 改最大生命/魔法等 UnitState | `unit-state-jass-japi-boundary.mdc` |
