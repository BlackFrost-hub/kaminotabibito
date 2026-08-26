# Warcraft 3 通用特效文字库

> 正式资源根目录：`imports\Common\Effect`
>
> 游戏内路径统一从 `Common\Effect\...` 开始，不带 `imports\` 前缀。
>
> 详细条目按导入目录拆分在 [`effect-asset-catalog/`](effect-asset-catalog/README.md)，本文件只保留总入口和通用规则。

## 用途

本目录记录项目内已经确认外观和用途的特效模型，解决以下问题：

- 不知道项目里是否已经有相同或相近的特效，重复迁入同一个模型。
- 同一个模型换名后被当成新资源，再次复制模型和贴图。
- 只凭文件名无法判断外观，反复打开大量模型预览。
- Boss 私有资源完成后没有进入通用检索目录，其他技能再次制作同类资源。
- 外部候选贴图与项目已有贴图完全相同，却再次迁入一份。

这里只记录已经实际导入并确认外观和用途的正式资源。未确认外观的模型不得凭文件名补写描述；乱码、纯编号、代号或哈希式导出名的来源登记，统一放在 `特效模型命名与去重备忘录.md`，不能用本目录代替预迁移登记。

## 分类入口

| 资源分类 | 详细目录 | 对应导入路径 |
| --- | --- | --- |
| 形态特效 | [`effect-asset-catalog/form/README.md`](effect-asset-catalog/form/README.md) | `imports\Common\Effect\Form` |
| 元素特效 | [`effect-asset-catalog/element/README.md`](effect-asset-catalog/element/README.md) | `imports\Common\Effect\Element` |
| 弹道特效 | [`effect-asset-catalog/projectile/README.md`](effect-asset-catalog/projectile/README.md) | `imports\Common\Effect\Projectile` |
| 闪电定义与贴图 | [`effect-asset-catalog/lightning/README.md`](effect-asset-catalog/lightning/README.md) | `imports\Splats` + `imports\Common\Effect\Lightning` |
| 去重与维护 | [`effect-asset-catalog/maintenance.md`](effect-asset-catalog/maintenance.md) | 跨分类维护规则 |

新增详细条目时必须写入对应分类文件；禁止再把条目表追加到本入口文件。

## 当前覆盖

截至 2026-07-29，本轮已记录候选迁移并按 `.mdx` 实际文件重新统计：

| 一级分类 | 模型数量 |
| --- | ---: |
| `Element` | 86 |
| `Form` | 170 |
| `Projectile` | 8 |
| 合计 | 263 |

本表只统计 `.mdx`，不把 366 张 `.blp` 贴图计作模型。其余未确认资源在实际预览或使用时逐步补入，不凭文件名一次性猜测外观。

## 使用方法

### 新增或迁入特效之前

1. 先搜索本入口和 `effect-asset-catalog/`，例如“暗金、屏障、向内回流、血月、镜缘、消散”。
2. 在 `imports\Common\Effect` 的对应分类中查同类模型。
3. 对外部候选计算完整 SHA-256，与项目内模型比较。
4. SHA-256 完全相同：不得再次导入，直接复用已有游戏内路径。
5. 文件不同但外观和用途相同：优先复用或运行时改色，不额外增加资源。
6. 确实没有可用资源时，才迁入或新制，并在用户确认后补入对应分类文件。

### 指纹说明

- 表中 `SHA-256` 只记录前 16 位，便于人工快速比对。
- 真正判断完全重复时必须比较完整 SHA-256。
- 模型重新生成或改造后，要同步更新指纹、字节数和视觉说明。
- 相同模型因为贴图路径改写、序列修复或颜色固化而产生不同指纹时，应在“限制／叠加关系”中记录派生关系。

## 快速检索标签

- 颜色：`暗金`、`骨白`、`黑紫`、`深血红`、`苍白金`、`冷青`
- 形态：`箭雨`、`直线`、`镜框`、`球壳`、`半球屏障`、`丝带`、`血月`
- 运动：`坠落`、`回流`、`向内收束`、`展开`、`破碎`、`消散`
- 层级：`主体`、`辅助层`、`外壳`、`核心`、`破碎层`
- 朝向：`竖直广告牌`、`空中正面`、`贴地`、`三维实体`

详细新增模板和重复资源规则见 [`effect-asset-catalog/maintenance.md`](effect-asset-catalog/maintenance.md)。
