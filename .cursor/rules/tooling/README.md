# 工具规则索引

本目录只放工程工具与操作流程规则，不放资源生产规则。

## 分类

| 目录 | 内容 |
|------|------|
| [`build/`](build/) | TypeScript 构建、`.build/war3map.lua`、Warcraft VSCode 打包/运行命令 |
| [`patch/`](patch/) | 中文文件、TSTL、Lua/FDF 的编码安全和小补丁规则 |

普通代码接入默认只运行必要构建验证，不手动打包地图；用户通过 Warcraft VSCode `Run Map` 完成正常 compile + pack。只有用户明确要求或正在诊断打包问题时，才进入 `build/` 的手动流程。

## 资源规则在哪里

音效、配音、MIX 语音包、模型、贴图、特效资源规则统一在：

```text
.cursor/rules/resources/
```
