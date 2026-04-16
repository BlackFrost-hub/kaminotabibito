# 调试输出规则

**调试输出时使用 `print` 而非 `DisplayTimedTextToPlayer`**：

- `print` 在游戏屏幕中央显示，不会重复累积
- `DisplayTimedTextToPlayer` 每次调用都会创建新文本，容易刷屏
- 优先使用 `print` 进行调试输出

## 同一条调试出现两次

在部分环境（WE 测试、双通道日志、或 `print` 与外部捕获并存）下，**同一条**调试内容可能连续出现两行，**属正常现象**。不要仅凭「成对出现」就推断 `onDamageEvent` 等逻辑一定执行了两次；需要时用序号、计数器或单一入口埋点区分。
