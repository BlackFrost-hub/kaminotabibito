# 智能体指南

本仓库将项目特定的工程规则存放在 `.cursor/rules/` 目录中。

适用于 Codex 及其他非 Cursor 智能体：

1. 首先阅读 `.cursor/rules/README.md`。
2. 将 `.cursor/rules/` 视为领域约定、引擎陷阱和工具约束的规则来源。
3. 在编辑代码之前，阅读与你所修改区域相关的规则文件。
4. 当多个规则适用时，优先使用针对你所修改子系统的更具体规则。

当前规则领域包括：

- `war3-tstl/`：TSTL、Lua、JASS、回调和随机数陷阱。
- `dzapi/`：DzAPI UI 框架使用、同步行为和 FDF/UI 陷阱。
- `equipment/`：装备相关数据和触发器约定。
- `stes-ydlocal/`：STES 和 YDLocal 使用约束。
- `tooling/`：调试输出、声音和封装约定。

如果你添加了新的项目规则，请在 `.cursor/rules/README.md` 中注册，以便每个智能体都能快速发现它们。

补充约定（适用于 Codex）：

1. 仅当实际修改了文件且该编码任务完成后，自动执行 `npm run build`，并在回复中说明构建结果。
