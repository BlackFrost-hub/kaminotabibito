# Hero Boss ObjEditing 分类

本目录按 Boss 的剧情定位分类，与 TypeScript Boss 技能目录保持同一口径。

| 目录 | 内容 |
|------|------|
| `01-MainlineBoss/` | 章节主线必经 Boss |
| `02-ChallengeHiddenBoss/` | 可选挑战、隐藏 Boss 与特殊支线 Boss |
| `03-OtherworldBoss/` | 异界来源或异界挑战体系 Boss |

根入口 `HeroBoss.lua` 只加载三个分类入口。新增 Boss 时把对象文件放入对应分类，并登记到该分类的入口文件；不要重新把单个 Boss 直接堆回根入口。

Boss 的技能壳、机制单位文件应与 Boss 本体放在同一分类目录。分类按剧情定位判断，不按模型、强度或技能风格判断。
