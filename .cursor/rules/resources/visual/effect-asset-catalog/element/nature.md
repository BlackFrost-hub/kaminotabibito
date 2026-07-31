# Element / Nature

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\\Effect\\Element\\Nature\\RottenRootImpale.mdx` | 中心镂空的荧绿色腐朽根须环，外沿伸出尖锐根刺并伴随暗色裂纹，适合表现地面根须穿刺与腐败爆发。 | `Birth`：根须从地面刺出；`Stand`：短暂维持；`Death`：收束消散。点特效无固定水平朝向。 | 古木之蚀莫尔特斯“腐朽根须穿刺”的结算特效。 | 同时依赖分类目录 `Texture` 下的两张私有贴图；原生 `Textures\\...` 贴图保持游戏路径。 | 160128 | `55A0F4D5D788FC3A` |
| `Common\\Effect\\Element\\Nature\\MoltesCorruptionTick.mdx` | 低矮的深绿色腐败烟云从中心翻涌扩散，边缘柔和，适合作为周期伤害与腐败波动的短促反馈。 | `Birth / Stand / Death`；点特效无固定水平朝向。 | 莫尔特斯腐败孢子云每次伤害 Tick，以及腐败种子成长为幼树后的每次波动 Tick。 | 源模型 `207.mdx`；仅引用 Warcraft 原生贴图 `Textures\\Clouds8x8.blp`，无需迁入私有贴图。 | 1415 | `F3E13C8E3F9592E` |
