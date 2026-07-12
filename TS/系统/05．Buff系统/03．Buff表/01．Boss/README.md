# Boss Buff 分类

Boss 专属 Buff 与 Boss 技能目录使用同一套剧情分类：

- `01．主线Boss`
- `02．挑战与隐藏Boss`
- `03．异界Boss`

新增或迁移 Boss 时，先确认其技能目录分类，再把专属 Buff 放入同名分类，并在分类 `index.ts` 聚合。根 `index.ts` 只合并三个分类表，避免继续恢复成扁平的 Boss Buff 文件列表。
