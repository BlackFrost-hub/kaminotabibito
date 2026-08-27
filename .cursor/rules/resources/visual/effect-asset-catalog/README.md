# 特效资产分类目录

本目录是 `effect-asset-catalog.md` 的详细条目区，目录结构与 `imports\Common\Effect` 对齐。`Common\Decoration` 动态装饰物不在本目录统计，统一登记到上级的 [`decoration-asset-catalog.md`](../decoration-asset-catalog.md)。

## 分类入口

| 资源分类 | 文字目录 | 说明 |
| --- | --- | --- |
| `Form` | [`form/README.md`](form/README.md) | 按视觉形态分类：直线、护盾、爆炸、减益、升降、幻象等。 |
| `Element` | [`element/README.md`](element/README.md) | 按主元素分类：暗、火、冰、光、雷、水、风等。 |
| `Projectile` | [`projectile/README.md`](projectile/README.md) | 飞行弹道、箭、枪、魔法弹等。 |
| `Lightning` | [`lightning/README.md`](lightning/README.md) | `Splats` 闪电定义与其私有贴图资源。 |
| 去重与维护 | [`maintenance.md`](maintenance.md) | 完全重复模型、重复贴图和新增条目规范。 |

## 文件组织规则

1. 每个详细条目只写入一个主分类文件；跨用途用“适用场景”和关键词检索，不复制条目。
2. `Form` 新增子类时，在 `form/` 下创建同名小写英文 Markdown，并同步更新 `form/README.md`。
3. `Element` 新增子类时，在 `element/` 下创建同名小写英文 Markdown，并同步更新 `element/README.md`。
4. 文件名与导入目录保持稳定映射；历史目录 `xuli`、`zuobiao` 继续保留兼容名称，并在索引中标注中文语义。
5. 未完成外观确认的候选不进入详细资产表，只留在对应 Boss 候选筛选记录。
