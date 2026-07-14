# Form / Shield

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Form\Shield\EquipmentShieldFlash.mdx` | 多块明亮蜂巢盾片展开，结构干净，没有旗帜、刀剑或阵营装饰。 | 盾片展开、维持和回收。 | 通用装备护盾、蜂巢屏障原型。 | 雅儿贝德暗金版已派生为 `AlbedoDarkGoldBarrier.mdx`，不要再次复制改名。 | 16145 | `9370DFC5DC365629` |
| `Common\Effect\Form\Shield\AlbedoDarkGoldBarrier.mdx` | 暗金蜂巢盾片组成防御屏障，亮度克制，具有重甲守护感。 | `Birth` 展开、`Stand` 维持、`Death` 回收。 | 雅儿贝德共同护盾、生命锚点封锁。 | 破碎时叠加独立碎裂层；来源是 `EquipmentShieldFlash.mdx` 的暗金派生版。 | 16229 | `559ADF50666566BD` |
| `Common\Effect\Form\Shield\BigYellowOrbShield.mdx` | 暖金透明球罩，读取简单、覆盖完整。 | 球形盾面维持。 | 雅儿贝德半球护盾填充层备选。 | 视觉较通用，缺少重甲和黑翼身份，不能单独承担技能。 | 5112 | `4C79371BC965980A` |
| `Common\Effect\Form\Shield\holyshield_state.mdx` | 四枚金色盾牌环绕，直接表达守护职责。 | 环绕状态维持；迁移版补齐安全 `Death`。 | 守护者之职责、至尊共护状态标记。 | 更适合状态标记而非完整阻挡盾面。 | 28940 | `143DEDB3E16EDB01` |
| `Common\Effect\Form\Shield\YellowOrbShield.mdx` | 暖金透明球罩，轮廓比大型版更克制。 | 球形盾面维持。 | 雅儿贝德半球护盾辅助层。 | 仍是通用盾面，需与暗金重甲结构叠加。 | 5112 | `20845C6CC19ADDCC` |
| `Common\Effect\Form\Shield\AlbedoGuardianShieldStatus.mdx` | 候选截图观察：暖金实心盾牌轮廓清楚、低遮挡，能够快速传达防御状态；但图标感很强，缺少黑翼、重甲和至尊守护语义。 | 迁移后序列：`Birth / Stand / Death`；完成 8 项结构修复。 | 雅儿贝德·守护者之职责 / 护盾状态提示；源候选 `JNTX (543).mdx`。 | 只保留为简洁状态提示，不替换 `holyshield_state.mdx` 与 `DivineBarrier.mdx`。 | 15381 | `AF41D07824936C09` |
| `Common\Effect\Form\Shield\AlbedoGuardianShieldBreakMark.mdx` | 候选截图观察：暖金断盾符号辨识度高，可作为职责节点或护盾状态提示；但图标化较强，缺少重甲和黑翼质感。 | 迁移后序列：`Birth / Stand / Death`；完成 8 项结构修复。 | 雅儿贝德·守护职责节点 / 护盾破碎提示；源候选 `JNTX (549).mdx`。 | 保留为低遮挡提示层，不替换 `holyshield_state.mdx` 与 `DivineBarrier.mdx`。 | 15353 | `ACC3BE395876D4A2` |
| `Common\Effect\Form\Shield\DivineBarrier.mdx` | 候选截图观察：四枚金色盾牌环与暗金屏障都直接表达守护职责，比通用元素球更准确；前者适合状态标记，后者适合实际阻挡层。 | 迁移后序列：`Birth / Stand / Death`；完成 1 项结构修复。 | 雅儿贝德·守护者之职责 / 至尊共护；源候选 `DivineBarrier.mdx`。 | 分别用于护卫状态与主动护盾；横扫主表现仍需另找，但不强制使用额外翅膀模型。 | 7496 | `91126BD1BB79979F` |
