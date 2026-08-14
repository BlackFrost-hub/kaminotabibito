# 工具规则索引

本目录只放工程工具与操作流程规则，不放资源生产规则。

## 分类

| 目录 | 内容 |
|------|------|
| [`build/`](build/) | TypeScript 构建、`.build/war3map.lua`、Warcraft VSCode 打包/运行命令 |
| [`patch/`](patch/) | 中文文件、TSTL、Lua/FDF 的编码安全和小补丁规则 |
| [`runtime/`](runtime/) | Run Map 进入游戏后无 Lua 功能、Lua 启动链和临时诊断图排查 |

普通代码接入默认只运行必要构建验证，不手动打包地图；用户通过 Warcraft VSCode `Run Map` 完成正常 compile + pack。只有用户明确要求或正在诊断打包问题时，才进入 `build/` 的手动流程。

用户反馈“进入游戏后完全没有 Lua 功能”时，读取 [Run Map 无 Lua 功能诊断](runtime/run-map-no-lua-diagnosis.mdc)。不要只检查生成图是否包含 `war3map.lua`；必须继续验证 Lua 入口和 `main.lua` 初始化是否完整返回。

## 资源规则在哪里

音效、配音、MIX 语音包、模型、贴图、特效资源规则统一在：

```text
.cursor/rules/resources/
```
