# 调试输出规则

**调试输出时使用 `print` 而非 `DisplayTimedTextToPlayer`**：

- `print` 在游戏屏幕中央显示，不会重复累积
- `DisplayTimedTextToPlayer` 每次调用都会创建新文本，容易刷屏
- 优先使用 `print` 进行调试输出
