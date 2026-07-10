# 视觉资源规则索引

本目录集中存放模型、贴图、特效资源的路径、导入和命名规则。

## 文件

| 文件 | 内容 |
|------|------|
| [`effect-resource-folder-layout.mdc`](effect-resource-folder-layout.mdc) | 特效资源目录布局、路径约定、导入组织 |
| [`model-texture-asset-rules.mdc`](model-texture-asset-rules.mdc) | 模型、贴图、导入路径、资源踩坑经验 |

## 使用原则

1. 改模型、贴图、特效路径前，先确认 `imports/` 中的真实路径。
2. 代码配置里的路径必须和导入资源路径完全一致。
3. 不要把音频规则放到这里；音频统一进入 `resources/audio/`。
