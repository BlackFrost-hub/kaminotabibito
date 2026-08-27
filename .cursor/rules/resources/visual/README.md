# 视觉资源规则索引

本目录集中存放模型、贴图、特效资源的路径、导入和命名规则。

## 文件

| 文件 | 内容 |
|------|------|
| [`effect-resource-folder-layout.mdc`](effect-resource-folder-layout.mdc) | 特效资源目录布局、路径约定、导入组织 |
| [`model-texture-asset-rules.mdc`](model-texture-asset-rules.mdc) | 模型、贴图、导入路径、资源踩坑经验 |
| [`effect-model-production-rules.mdc`](effect-model-production-rules.mdc) | 特效模型选型、2D/3D、动画、贴图、缓存、迁移、性能与验收规则 |
| [`war3-model-batch-previewer-workflow.mdc`](war3-model-batch-previewer-workflow.mdc) | 魔兽模型批量预览器 v4.1.5 的模型地图、实时刷新、动作检查和自主迭代流程 |
| [`effect-asset-catalog.md`](effect-asset-catalog.md) | 通用特效文字目录总入口、检索方法和基线统计 |
| [`effect-asset-catalog/`](effect-asset-catalog/README.md) | 与 `imports\Common\Effect` 对齐的分类条目、视觉描述和重复资源记录 |
| [`decoration-asset-catalog.md`](decoration-asset-catalog.md) | 与 `imports\Common\Decoration` 对齐的动态装饰物条目、摆放和生命周期记录 |

## 使用原则

1. 改模型、贴图、特效路径前，先确认 `imports/` 中的真实路径。
2. 新增或迁入特效前，先搜索 `effect-asset-catalog.md` 和 `effect-asset-catalog/`；新增或迁入动态装饰物前，先搜索 `decoration-asset-catalog.md`，再检查文件 SHA-256，避免重复导入。
3. 代码配置里的路径必须和导入资源路径完全一致。
4. 不要把音频规则放到这里；音频统一进入 `resources/audio/`。
5. 制作或修改 MDX 后，默认从批量主界面点击目标模型卡片进入单模型实时预览；只有少量模型横向比较或地面场景检查时才打开“模型地图”。
6. 特效一旦正式采纳，必须在同一任务中补入 `effect-asset-catalog/` 的唯一分类条目并附完整文字描述；动态装饰物正式采纳时必须补入 `decoration-asset-catalog.md`，并附模型、贴图、摆放与生命周期描述；未登记不能视为资源流程完成。
