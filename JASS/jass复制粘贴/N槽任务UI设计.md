# N 槽任务 UI 设计说明

这份文档已与项目规则合并，**规则正文以**
[`\.cursor/rules/dzapi/n-slot-ui-symmetric-execution.mdc`](</c:/Users/Administrator/Desktop/syzl/.cursor/rules/dzapi/n-slot-ui-symmetric-execution.mdc>)
**为准**。

## 合并原因

- 之前这份文档与 `n-slot-ui-symmetric-execution.mdc` 长期并行维护，语义重复
- 两边都在描述 DzAPI 联机 UI、N 槽、`GetLocalPlayer()` 分层、`sync=true/false` 与任务 UI 实践
- 后续继续双写，容易再次出现“规划文档”和“规则文件”不一致

## 现在的单一事实来源

请直接阅读：

- [n-slot-ui-symmetric-execution.mdc](</c:/Users/Administrator/Desktop/syzl/.cursor/rules/dzapi/n-slot-ui-symmetric-execution.mdc>)
- [lua-gc-desync-heuristics.mdc](</c:/Users/Administrator/Desktop/syzl/.cursor/rules/dzapi/lua-gc-desync-heuristics.mdc>)

分工如下：

- `n-slot-ui-symmetric-execution.mdc`：联机 UI 对称执行、N 槽、`sync=true/false`、键盘/滚轮/拖拽、任务 UI 参考实现
- `lua-gc-desync-heuristics.mdc`：UI 回调、闭包、`pcall`、GC 和 Dz/JASS 交互的高风险约束

## 本文档保留的意义

- 作为旧路径兼容入口，避免历史链接失效
- 明确“任务 UI / N 槽 / 联机 UI 安全规范”的唯一规则来源已经迁移到 `.cursor/rules/dzapi/`

## 迁移结论

一句话记住：

> **全端同时做同样的事，只有像素在最后一刻分叉。**

落地时再补一句：

> **同步修数据，异步管显隐；高频导航慎用 `sync=true`。**
