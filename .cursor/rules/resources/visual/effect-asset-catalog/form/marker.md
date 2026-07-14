# Form / Marker

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Form\Marker\PeasantGrave1.mdx` | 尖顶哥特式暗灰墓碑，具有古墓与守誓遗物的实体感。 | 静态低矮摆放；迁移版补齐安全 `Death`。 | 亚伦柯斯誓约墓碑、未安魂状态标记。 | 不是粒子特效；应叠少量冷蓝魂雾，避免尺寸过大遮挡单位。 | 25296 | `918B1ECDEA64D112` |
| `Common\Effect\Form\Marker\PowerStone.mdx` | 候选截图观察：骨白透明晶柱包裹淡金核心，既像生命容器又与安兹黑红死亡法术形成明确对比，比单独地面法阵更有“锚点”实体感。 | 迁移后序列：`Stand / Death / Birth`；完成 9 项结构修复。 | 安兹·生命锚实体；源候选 `PowerStone.mdx`。 | 与 `fate.mdx` 或 `RingOfBright.mdx` 组合为地面纹层。 | 5643 | `536715AEBA77B4D9` |
| `Common\Effect\Form\Marker\shatteredhandbanner.mdx` | 候选截图观察：白底红纹的军团旗帜轮廓清楚，可作为骑士军魂出现时远景的誓约残旗；纹章与配色较具体，不能作为常驻主视觉。 | 迁移后序列：`Stand / Portrait / Birth / Death / Decay`；完成 2 项结构修复。 | 亚伦柯斯·不灭军魂 / P3 强化的残旗；源候选 `shatteredhandbanner.mdx`。 | 依赖同目录的 `OrcClansRoar.blp`；其余贴图为 Warcraft 自带路径。只在 P3 转阶段或军魂短暂显现时低透明度使用。 | 16041 | `11146FBA063D9BFD` |
