# Form / Aura

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Form\Aura\BlightwalkerAura.mdx` | 八枚深红刃形符文环绕黑色核心，血月轮廓清楚。 | 环形持续表现；迁移版补齐安全 `Death`。 | 血月轮舞法阵、血族环形状态。 | 中心可能遮挡单位；来源 `BlightwalkerAura.mdx`，仍需实机确认尺寸。 | 2548 | `71C14F5B37DB59A8` |
| `Common\Effect\Form\Aura\long.MDX` | 露出暗金弧形骨架，具有守护环和联动护盾的组合层潜力。 | 环绕式弧线表现；迁移版补齐安全 `Death`。 | 雅儿贝德联动护盾、暗金守护环辅助层。 | 不能单独承担完整盾面，朝向和遮挡待实机确认。 | 6212 | `23137B73BD7589D9` |
| `Common\Effect\Form\Aura\AronkosGraveSoulField.mdx` | 候选截图观察：`348.mdx` 是低矮的冷蓝魂纹范围，能清楚圈出墓碑安魂区域；`368.mdx` 则以短暂向上的蓝白光柱和碎光表现灵魂离开。二者都克制、无爆炸，符合完成后安静归魂的语义。 | 迁移后序列：`Birth / Stand / Death`；完成 3 项结构修复。 | 亚伦柯斯·墓碑安魂范围 / 完成；源候选 `348.mdx`。 | `348.mdx` 持续显示并与真实安魂范围一致；完成时关闭它，短促播放 `368.mdx`，不与英灵陨星的高亮光柱同时叠放。 | 8055 | `4D08255F3E188405` |
| `Common\Effect\Form\Aura\ShalltearBloodMirrorField.mdx` | 候选截图观察：前者有深红领域氛围但遮挡偏重；后者有花瓣语义但颜色明显偏紫。二者都只能作辅助层，不能单独定稿。 | 迁移后序列：`Birth / Stand / Death`；完成 4 项结构修复。 | 夏提雅·血镜领域 / 玫瑰碎片辅助层；源候选 `t_bloodex-special-2.mdx`。 | 花瓣若不能改成深红或银红则淘汰。 | 11450 | `9694CD3751A3EEB0` |
| `Common\Effect\Form\Aura\wisp.mdx` | 候选截图观察：小型冷蓝苍白魂火带少量星点，亮度集中、体量克制，适合贴在铠甲缝隙或武器附近长期存在。 | 迁移后序列：`Stand / Birth / Death / Walk / Attack / Portrait`；完成 27 项结构修复。 | 亚伦柯斯·常驻英魂底色 / 魂火；源候选 `wisp.mdx`。 | 作为常驻魂火主候选；数量必须少，不能覆盖剑术动作。 | 15116 | `5DBC95140C1E6E5F` |
| `Common\Effect\Form\Aura\AinzLifeAnchorHolyAura.mdx` | 候选截图观察：白金和淡金层级正确，能补充生命锚的启动、环绕与地面符文，但单独使用都缺少实体锚点。 | 迁移后序列：`Stand / Death`；完成 2 项结构修复。 | 安兹·生命锚启动 / 高阶施法层；源候选 `HolyAura.MDX`。 | 作为 `PowerStone.mdx` 的辅助层候选。 | 5045 | `E6F100B5A12645A2` |
| `Common\Effect\Form\Aura\Yellow Ball2.mdx` | 候选截图观察：都有暗金环形骨架潜力，但前者像元素球，后者只露出弧形边缘，尚不能承担完整护盾。 | 迁移后序列：`Birth / Stand / Death`；保留源动画结构。 | 雅儿贝德·联动护盾 / 暗金守护环；源候选 `Yellow Ball2.mdx`。 | 只作为组合层候选，朝向留待接入实测。 | 10259 | `71B35D07AC07B3F8` |
| `Common\Effect\Form\Aura\AinzLifeShelterStatus.mdx` | 白金星芒与淡金环形符文组成小型生命锚保护标记，轮廓集中、色彩与安兹的黑红法术区分明显。 | 环形星标持续维持；改造后含 `Birth / Stand / Death`。 | 安兹“生命庇护”的玩家附着状态；源候选 `MapTest\file_001181\file_001181.mdx`。 | 运行时挂 `overhead` 并缩放到 `0.28`，只作低遮挡状态标记，不替代场景中的实体生命锚。 | 10239 | `931A8EFB8BFAC9B0` |
| `Common\Effect\Form\Aura\EquipmentMartialSoulKeyAura.mdx` | 两道金白粒子半月弧在单位两侧相对环绕，中心留空，像一枚持续旋转的暗金武魂钥印。 | `Birth / Stand / Death`；双弧围绕自身循环旋转，销毁时收束消失。 | 双钥归一棱镜的武魂钥常驻提示，也适合金色能量钥印或双环蓄势状态。 | 默认绑定单位 `origin`；双弧辨识依赖实机镜头，不适合作为地面范围边界。 | 7066 | `25982ADC32EC675A` |
| `Common\Effect\Form\Aura\EquipmentSpiritKeyAura.mdx` | 翠绿新月光带绕过明亮星核，伴随细碎绿光粒子，呈现生命与灵识汇聚的环身印记。 | `Birth / Stand / Death`；新月轨迹持续绕身，消失时具有完整退场序列。 | 双钥归一棱镜的灵识钥常驻提示，也适合生命赐福、自然灵识或绿色月牙护持状态。 | 默认绑定单位 `origin`；亮度集中在星核，和其他绿色治疗特效叠加时需注意过亮。 | 13373 | `0D28656BD236A540` |
