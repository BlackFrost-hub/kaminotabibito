# OpenCode 多模型配置说明

本项目使用 OpenCode 的项目级配置和 agent 文件，搭建一个简单的三模型协作结构。

## 文件位置

项目级配置：

```text
opencode.json
```

项目级 agent：

```text
.opencode/agent/smart.md
.opencode/agent/cheap.md
.opencode/agent/pro.md
```

全局 OpenCode 配置：

```text
C:\Users\Administrator\.config\opencode\opencode.jsonc
```

## 当前结构

| Agent | 模型 | 模式 | 职责 |
| --- | --- | --- | --- |
| `smart` | `1111/gpt-5.5` | `primary` | 最强主控、策划、调度、最终拍板和验收 |
| `cheap` | `opencode/mimo-v2.5-free` | `subagent` | 最便宜子模型，负责简单搜索、重复检查、轻量验证 |
| `pro` | `xiaomi-token-plan-cn/mimo-v2.5-pro` | `subagent` | 进阶子模型，负责深入调查、复杂错误分析、中等以下代码落地、非平凡 diff 初审 |

## 默认入口

`opencode.json`：

```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "1111/gpt-5.5",
  "small_model": "opencode/mimo-v2.5-free",
  "default_agent": "smart"
}
```

含义：

- 默认主控是 `smart`。
- 默认主模型是 `1111/gpt-5.5`。
- OpenCode 的小模型任务使用 `opencode/mimo-v2.5-free`。

## 分工原则

```text
用户
 ↓
smart / gpt-5.5
 负责理解需求、规划步骤、调度子模型、最终判断和验收
 ↓
cheap / mimo-v2.5-free
 负责简单搜索、查引用、跑轻量验证、总结，不改文件
 ↓
pro / mimo-v2.5-pro
 负责深入调查、复杂 review、错误分析、方案比较、中等以下代码落地
```

## 谁真正改代码

当前代码落地分两层：

| 场景 | 代码落地者 |
| --- | --- |
| 简单 / 中等以下风险任务 | `pro` 执行，`smart` 指挥和验收 |
| 高风险、架构性、跨系统、TSTL/JASS/DzAPI 敏感任务 | `smart` 亲自执行或逐步审查 |
| 搜索、验证、总结 | `cheap` 执行，不改文件 |

`cheap` 默认不允许编辑文件：

```yaml
permission:
  edit: deny
  bash: ask
```

`pro` 允许在明确派发时编辑文件：

```yaml
permission:
  edit: ask
  bash: ask
```

这样做是为了安全：

- 便宜模型负责调查和验证。
- 进阶模型负责中等以下代码落地、复杂分析和初审。
- 最强主控负责最终判断、任务分流和验收。

## gpt-5.5 看图能力

`1111/gpt-5.5` 是自定义 provider 下的模型。为了让 OpenCode 允许发送图片，需要在全局配置里显式声明图片能力。

全局配置位置：

```text
C:\Users\Administrator\.config\opencode\opencode.jsonc
```

其中 `1111.models.gpt-5.5` 应包含：

```json
"gpt-5.5": {
  "name": "gpt-5.5",
  "attachment": true,
  "modalities": {
    "input": ["text", "image"],
    "output": ["text"]
  }
}
```

否则 OpenCode 可能会在发送图片前报：

```text
this model does not support image input
```

## 思考强度

`smart` agent 默认配置了高思考强度：

```yaml
options:
  reasoningEffort: high
```

如果底层网关不支持这个字段，可能会忽略或报参数错误。若报错，删除或改成网关支持的字段即可。

## 使用方式

默认启动 OpenCode 后使用 `smart`。

典型指令：

```text
让 cheap 子模型查一下这个函数在哪里被引用，不要改文件。
```

```text
让 pro 子模型 review 当前 diff，重点找规则违规和潜在 bug，不要改文件。
```

```text
你作为 smart 主控，综合 cheap/pro 的结果，做最小正确修改并运行 npm run build。
```

## 修改配置后

修改以下文件后，需要退出并重启 OpenCode 才会生效：

- `opencode.json`
- `.opencode/agent/*.md`
- `C:\Users\Administrator\.config\opencode\opencode.jsonc`
