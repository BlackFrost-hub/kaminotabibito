# 首领奖励 UI 交接文档

更新时间：2026-06-12

本文用于在新窗口继续处理 `BossReward` 首领奖励选择 UI。当前窗口已经很卡，新窗口接手时请先读本文，再按项目规则继续。

## 先读规则

新窗口动手前必须按项目要求读规则：

1. `.cursor/rules/README.md`
2. `.cursor/rules/GLOBAL_AGENT_PROMPT.mdc`
3. `.cursor/rules/tooling/encoding-and-patch-safety.mdc`
4. UI/DzAPI 相关继续读：
   - `.cursor/rules/dzapi/n-slot-ui-symmetric-execution.mdc`
   - `.cursor/rules/dzapi/ui-frame-types.mdc`

注意事项：

- 中文重文件小补丁优先，用 `apply_patch`，不要整文件重写。
- TS 改动后跑 `npm run build`。
- 不要为了 TSTL 改 `scripts/fix-lua-for-pack.js`。
- 除非检查 TSTL self/nil 错位，否则不要主动看生成 Lua。
- `imports` 目录被 `.gitignore` 忽略，UI 贴图资源改动不会在 `git status` 里显示。

## 目标

制作并打磨一个通用 Boss 掉落选择 UI，用于 Boss 死亡后让玩家从 3-7 个奖励中选择若干件。目前先用瑟兰迪尔 5 件装备做测试。

当前测试命令：

- `brtest`：打开首领奖励选择测试 UI。
- `brreset`：重置测试领取状态。

测试发放对象：

- 大法师 `gg_unit_Hamg_0002`。

## 关键文件

主测试逻辑：

- `TS/系统/12．测试系统/05．首领奖励选择测试.ts`

面板壳：

- `TS/系统/02．物品系统/18．首领奖励选择/05．奖励选择界面.ts`

配置/发放/领取状态：

- `TS/系统/02．物品系统/18．首领奖励选择/01．奖励配置表.ts`
- `TS/系统/02．物品系统/18．首领奖励选择/02．领取状态.ts`
- `TS/系统/02．物品系统/18．首领奖励选择/03．奖励发放.ts`

UI 资源目录：

- `imports/UI/BossReward/`

当前约定：

- `imports\UI\BossReward` 是这个 UI 的所有资源目录。
- 属性图标、特效图标、选择边框、勾选标记、面板图都统一放这里。
- 不要再散到别的 UI 目录。

## 当前 BossReward 资源

目录：`imports/UI/BossReward`

主要文件：

- `boss_reward_panel_v2.tga`：主面板底图。
- `boss_reward_panel_v2.png`：主面板 PNG 预览/源图。
- `boss_reward_detail_overlay.tga`：透明装饰层，包含属性/特效小图标、分隔线等。
- `boss_reward_detail_overlay.png`：透明装饰层 PNG 预览/源图。
- `reward_selected_border.tga`：选中装备后的边框。
- `reward_selected_border.png`：选中边框 PNG 预览/源图。
- `reward_check_badge.tga`：选中装备后的右下角勾选标记。
- `reward_check_badge.png`：勾选标记 PNG 预览/源图。

注意：

- `imports` 被忽略，改资源后 `git status` 看不到。
- 最近几轮资源主要通过 PowerShell + `System.Drawing` 生成 PNG，再写入 32bit TGA。
- 如果继续生成 TGA，务必确认 Warcraft/Dz 可以加载该 TGA；目前这条路径已有成功加载经验。

## 当前测试 UI 状态

主界面已经能打开，装备图标、详情、按钮、选择逻辑都能运行。

当前布局大致如下：

- 顶部 5 个装备槽已经摆放。
- 右侧详情区有属性/特效标题、文本和透明装饰层。
- 左侧详情区显示当前装备图标、名字、分类、评分、描述。
- 底部有“确认领取”和“关闭”按钮。
- 选择后显示选中边框和右下角勾选标记。

已修过的问题：

- 图标原来太小，装备图标已转成 100x100 BLP。
- 右侧属性/特效曾经错位，后续调到详情区左侧附近。
- 曾经有线压住“装备评分”，已从 overlay 中移除。
- 关闭按钮点击区域太小，已把透明点击帧放大。
- `确认领取` 也扩大了点击帧。
- 勾选标记曾经不可见，后来改成挂在装备图标子帧右下角。

## 最近一次代码状态

文件：`TS/系统/12．测试系统/05．首领奖励选择测试.ts`

关键常量和帧：

- `选中边框贴图 = "UI\\BossReward\\reward_selected_border.tga"`
- `勾选标记贴图 = "UI\\BossReward\\reward_check_badge.tga"`
- `详情装饰贴图 = "UI\\BossReward\\boss_reward_detail_overlay.tga"`
- 颜色目前偏浅白/金色：
  - `颜色标题 = "|cffffe6a6"`
  - `颜色正文 = "|cfffff4df"`
  - `颜色小标题 = "|cffffcc5c"`
  - `颜色按钮 = "|cffffffff"`

选中相关：

- 选中边框目前是 `BACKDROP`，父帧是面板父帧。
- 勾选标记目前是 `BACKDROP`，优先父帧为对应图标：
  - `parent: 图标 !== 0 ? 图标 : 父帧`
  - 如果有图标，位置为相对图标中心：`0.020, -0.020`
  - 尺寸约 `0.024 x 0.024`
  - priority 约 `220`

按钮点击区：

- “确认领取”按钮点击帧从小文字区扩大到了约 `0.170 x 0.038`。
- “关闭”按钮点击帧扩大到了约 `0.178 x 0.040`。
- 文字帧单独覆盖，避免按钮原生文字位置不准。

最近已跑：

```powershell
npm run build
```

构建通过。

## 当前用户不满意的点

这是新窗口最重要的接手内容。

用户明确表示：

1. 属性图标不满意。
   - 最近一版曾把属性画成盾，用户指出“这是属性吗，看起来像防御”。
   - 后续改成“中心菱形 + 三颗属性点”，但仍需要新窗口继续审美确认。
   - 用户希望接近参考图中的属性图标：暗色小方章，里面像金色徽记，不是防御盾。

2. 特效图标也不满意。
   - 希望接近参考图中的蓝色星形小方章。
   - 不是简单线条图标，要有暗底、蓝白星辉、边框质感。

3. 选择装备后的边框和勾选标记不满意。
   - 用户希望像参考图：深金色、沉稳、雅观。
   - 当前之前几版过亮、像玩具、或者只是“画了个框”。
   - 应该低亮度深金，贴合装备槽暗金边框，而不是刺眼亮黄。

4. 选择态参考图重点：
   - 边框是深金色，贴着装备图标外框。
   - 勾选标记在右下角，是暗底小方章 + 金色勾。
   - 勾选标记大小适中，不要太大，也不要细到看不到。

5. UI 总体气质：
   - 八方旅人 1/2 的史诗感。
   - 玩家剧情帝国历史厚重。
   - 敌人史诗感。
   - 羊皮卷和帝国金属装饰可以保留，但不能粗糙、割裂、玩具感。

## 参考图审美要点

用户多次发的参考图中，右侧详情 UI 的属性/特效区域特点：

- 黑/深灰金属底。
- 小方形图标，尺寸不大。
- 属性图标类似暗金徽章/头像/属性章，不是盾牌。
- 特效图标是蓝底白蓝星辉。
- 标题“属性”“特效”为金色。
- 正文为浅灰/白。
- 分隔线为深灰线，略带金属质感，不要太浅。

选择态参考图特点：

- 装备槽位选中后出现深金边框。
- 右下角有深金小方块，内含金色勾。
- 不是高亮黄色，不是纯线框，不要廉价角花。

## 建议下一步

建议新窗口不要继续在当前资源上盲调。最好按下面顺序做：

1. 先打开当前三张 PNG 看效果：
   - `imports/UI/BossReward/boss_reward_detail_overlay.png`
   - `imports/UI/BossReward/reward_selected_border.png`
   - `imports/UI/BossReward/reward_check_badge.png`

2. 对比用户参考图，先只重画资源，不改 TS 布局。

3. 属性图标建议：
   - 不要盾牌轮廓。
   - 用“属性徽章”概念：中心小星/菱形，周围三颗小宝石或三向符号，表达力量/敏捷/智力/全属性。
   - 暗底，金色细边，内部低饱和金，不要亮黄。

4. 特效图标建议：
   - 蓝黑底。
   - 白蓝星辉/雪花/奥术星，参考图里的符号感。
   - 细节要比当前更像 UI 图标，不要简单几条线。

5. 选中边框建议：
   - 不要复杂角花。
   - 用深金双线或内外双层 bevel。
   - 与装备槽原本边框贴合，不要超出太多。
   - 可以考虑把 TS 中边框尺寸从 `槽位图标尺寸 + 0.012` 微调到 `+0.008` 或 `+0.010`，避免太大。

6. 勾选标记建议：
   - 深色底，深金边。
   - 金色勾，略粗，但不要荧光。
   - 位置仍在右下角；如果偏外，改 TS 的 `0.020, -0.020`。

7. 每次改后：
   - 生成 PNG + TGA。
   - 跑 `npm run build`。
   - 让用户进图 `brtest` 看。

## 已知坑

- 终端显示中文可能乱码，但文件本身不一定坏，不要因为终端乱码整文件重写。
- `imports` 不进 git，资源改动要靠文件时间/打开图片确认。
- FDF 不是当前主要路径，主 UI 现在主要走 TS 创建 fallback 面板贴图。
- 不要使用 `Layer "ARTWORK"` 这类容易导致 Warcraft 1.27e 崩溃的 FDF 写法。
- `BACKDROP` 不接收点击，点击区用透明 `GLUETEXTBUTTON`。
- `DzFrameSetPriority` 才是当前帧层级控制重点。

## 相关装备

当前测试 UI 展示瑟兰迪尔 5 件装备：

1. 执法者徽记
2. 月光锁链护腕
3. 审判之锋长剑
4. 精灵执法披风
5. 瑟兰迪尔的决心

当前图标路径：

- `Equipment\Icon\Item\enforcer_badge.blp`
- `Equipment\Icon\Item\moonlight_chain_bracer.blp`
- `Equipment\Icon\MainWeapon\Sword\judgement_edge_longsword.blp`
- `Equipment\Icon\Clothes\elven_enforcer_cloak.blp`
- `Equipment\Icon\Soul\thranduil_resolve.blp`

## 当前工作树提醒

最近相关文件有改动：

- `TS/系统/12．测试系统/05．首领奖励选择测试.ts`
- `src/系统/12．测试系统/05．首领奖励选择测试.lua`（由 build 同步生成）
- `imports/UI/BossReward/*`（被 git ignore，不在 status 显示）

新窗口不要随便 revert 用户/已有改动。

## 推荐给新窗口的第一句话

可以直接对新窗口说：

> 先读 `首领奖励UI交接.md`，继续优化 `imports\UI\BossReward` 的属性/特效小图标、选中边框和勾选标记。不要大改 TS 布局，先重画资源，跑 `npm run build`，让我进图 `brtest` 看效果。
