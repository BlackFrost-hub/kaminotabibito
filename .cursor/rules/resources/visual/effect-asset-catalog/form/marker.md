# Form / Marker

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Form\Marker\PeasantGrave1.mdx` | 尖顶哥特式暗灰墓碑，具有古墓与守誓遗物的实体感。 | 静态低矮摆放；迁移版补齐安全 `Death`。 | 亚伦柯斯誓约墓碑、未安魂状态标记。 | 不是粒子特效；应叠少量冷蓝魂雾，避免尺寸过大遮挡单位。 | 25296 | `918B1ECDEA64D112` |
| `Common\Effect\Form\Marker\PowerStone.mdx` | 候选截图观察：骨白透明晶柱包裹淡金核心，既像生命容器又与安兹黑红死亡法术形成明确对比，比单独地面法阵更有“锚点”实体感。 | 迁移后序列：`Stand / Death / Birth`；完成 9 项结构修复。 | 安兹·生命锚实体；源候选 `PowerStone.mdx`。 | 与 `fate.mdx` 或 `RingOfBright.mdx` 组合为地面纹层。 | 5643 | `536715AEBA77B4D9` |
| `Common\Effect\Form\Marker\shatteredhandbanner.mdx` | 候选截图观察：白底红纹的军团旗帜轮廓清楚，可作为骑士军魂出现时远景的誓约残旗；纹章与配色较具体，不能作为常驻主视觉。 | 迁移后序列：`Stand / Portrait / Birth / Death / Decay`；完成 2 项结构修复。 | 亚伦柯斯·不灭军魂 / P3 强化的残旗；源候选 `shatteredhandbanner.mdx`。 | 依赖同目录的 `OrcClansRoar.blp`；其余贴图为 Warcraft 自带路径。只在 P3 转阶段或军魂短暂显现时低透明度使用。 | 16041 | `11146FBA063D9BFD` |
| `Common\Effect\Form\Marker\SentryTotem.mdx` | 木质部族图腾主体，绿光、符文与烟雾粒子叠出持续的生命汲取危险区氛围。 | `Birth / Stand / Death`；`Stand` 循环。 | 树魔首领生命陷阱的可攻击机制实体。 | 依赖同目录 `Texture` 的 `Totem1`、绿色冲击环与烟雾贴图；不是一次性受击特效。 | 75930 | `D12CC247A06C987C` |
| `Common\Effect\Form\Marker\FireTotem.mdx` | 木质部族图腾主体，红色辉光与短促火焰丝带更容易辨识为爆炸陷阱。 | `Birth / Stand / Death`；`Stand` 循环。 | 树魔首领爆炸陷阱的可攻击机制实体。 | 与生命图腾共用 `Totem1` 贴图，额外依赖红色丝带贴图；爆炸结算仍须叠加独立爆炸特效。 | 31812 | `FDF638F9A61E2AEE` |
| `Common\Effect\Form\Marker\MomijiWeakPointBlade3D.mdx` | 四段断开的朱红斩痕残留，带浅三维厚度与斜面角度；中心留小断口，避免读成粗大十字武器。 | `Birth / Stand / Death`；非 Billboarded；`Stand` 绕斜面法线旋转；`Birth` 渐显，`Death` 渐隐。 | 朱雀院红叶被动破绽标记，贴在敌方躯干附近持续显示。 | 低亮度状态标记，不是地面特效，不承担伤害或范围判定；破绽斩瞬间仍需独立命中特效。私有贴图：`Common\Effect\Form\Marker\Texture\MomijiWeakPointBlade3D.blp`。 | 3532 | `0FEE8B20EC5E0EB1` |
| `Common\Effect\Form\Marker\SealAnchorCrystalTower.mdx` | 蓝色队伍色能量水晶塔，轮廓清楚，适合作为封印守卫战三座可修复锚点的实体标记。 | `Birth / mCPortrait / mCStand / mCDeath / mCDecay`；运行时常驻 `mCStand`。 | 第三章节点 49 三座封印修复锚点。 | 仅引用 Warcraft 原生贴图；由 TS 在锚点坐标创建，清理时销毁；修复状态不额外叠加动画。 | 22776 | `3BC7EA3144EDAE03` |
