---
description: 播放音效用 00_核心/音效函数.ts，测试用 测试/测试事件2；加金币等封装写在 00_核心/封装函数.ts
---

# 音效与封装函数约定

## 音效

- **需要播放音效时**：使用 `TS/系统/00_核心/音效函数.ts` 提供的 API。
  - 3D/坐标/单位/点：`Sound3DII_CooPlay`、`Sound3DII_UnitPlay`、`Sound3DII_LocPlay`
  - 仅指定玩家听到（如 UI 音效）：`Sound3DII_Mp3Play(path, whichPlayer)`
- **测试用入口**：`TS/系统/测试/测试事件2.ts`（如聊天 222 触发加金币+收金币音效）。

## 漂浮文字

- **需要创建漂浮文字时**：使用 `TS/系统/00_核心/漂浮文字函数.ts` 提供的 API。
  - 单位：`CreateFloatTextOnUnit(unit, text, options?)`
  - 坐标：`CreateFloatTextAtPoint(x, y, text, options?)`

## 封装函数

- **加金币、改资源等通用 JASS 封装**：写在 `TS/系统/00_核心/封装函数.ts`。
  - **金币（推荐）**：`AddGoldWithFeedback({ delta, player? | unit? })`
    - 传 `player`：仅该玩家播放收金币音效，不出漂浮字
    - 传 `unit`：单位头顶出金色漂浮字（±金币），并在单位附近 1500 范围播放收金币音效
  - 资源通用：`AdjustPlayerStateBJ(delta, whichPlayer, whichPlayerState)`

## 引用方式

- 音效：`import { Sound3DII_Mp3Play, initSound3DII } from "系统.00_核心.音效函数"`
- 漂浮文字：`import { CreateFloatTextOnUnit, CreateFloatTextAtPoint } from "系统.00_核心.漂浮文字函数"`
- 封装：`import { AdjustPlayerStateBJ, AddGoldWithFeedback } from "系统.00_核心.封装函数"`
