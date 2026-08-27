# Form / Shield

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Form\Shield\EquipmentShieldFlash.mdx` | 多块明亮蜂巢盾片展开，结构干净，没有旗帜、刀剑或阵营装饰。 | 盾片展开、维持和回收。 | 通用装备护盾、蜂巢屏障原型。 | 雅儿贝德暗金版已派生为 `AlbedoDarkGoldBarrier.mdx`，不要再次复制改名。 | 16145 | `9370DFC5DC365629` |
| `Common\Effect\Form\Shield\AlbedoDarkGoldBarrier.mdx` | 暗金蜂巢盾片组成防御屏障，亮度克制，具有重甲守护感。 | `Birth` 展开、`Stand` 维持、`Death` 回收。 | 雅儿贝德共同护盾、生命锚点封锁。 | 破碎时叠加独立碎裂层；来源是 `EquipmentShieldFlash.mdx` 的暗金派生版。 | 16229 | `559ADF50666566BD` |
| `Common\Effect\Form\Shield\AinzUndeadSummonFatalShield.mdx` | 蓝白死亡能量构成的多层护盾，中心有清晰的致命保护语义，不遮挡死亡骑士主体。 | `Birth / Stand / Death`；致命伤害触发时绑定 `origin`，运行时播放 `Stand`，持续 `1` 秒后解绑并销毁。 | 安兹高阶亡灵召唤物的致命保护状态。 | 只承担视觉提示，实际致命伤害免疫由 TS 最终伤害修正器处理；触发时显示缩放 `2` 倍，不常驻。 | 80956 | `65181865829D7A60` |
| `Common\Effect\Form\Shield\BigYellowOrbShield.mdx` | 暖金透明球罩，读取简单、覆盖完整。 | 球形盾面维持。 | 雅儿贝德半球护盾填充层备选。 | 视觉较通用，缺少重甲和黑翼身份，不能单独承担技能。 | 5112 | `4C79371BC965980A` |
| `Common\Effect\Form\Shield\holyshield_state.mdx` | 四枚金色盾牌环绕，直接表达守护职责。 | 环绕状态维持；迁移版补齐安全 `Death`。 | 守护者之职责、至尊共护状态标记。 | 更适合状态标记而非完整阻挡盾面。 | 28940 | `143DEDB3E16EDB01` |
| `Common\Effect\Form\Shield\YellowOrbShield.mdx` | 暖金透明球罩，轮廓比大型版更克制。 | 球形盾面维持。 | 雅儿贝德半球护盾辅助层。 | 仍是通用盾面，需与暗金重甲结构叠加。 | 5112 | `20845C6CC19ADDCC` |
| `Common\Effect\Form\Shield\AlbedoGuardianShieldStatus.mdx` | 候选截图观察：暖金实心盾牌轮廓清楚、低遮挡，能够快速传达防御状态；但图标感很强，缺少黑翼、重甲和至尊守护语义。 | 迁移后序列：`Birth / Stand / Death`；完成 8 项结构修复。 | 雅儿贝德·守护者之职责 / 护盾状态提示；源候选 `JNTX (543).mdx`。 | 只保留为简洁状态提示，不替换 `holyshield_state.mdx` 与 `DivineBarrier.mdx`。 | 15381 | `AF41D07824936C09` |
| `Common\Effect\Form\Shield\AlbedoGuardianShieldBreakMark.mdx` | 候选截图观察：暖金断盾符号辨识度高，可作为职责节点或护盾状态提示；但图标化较强，缺少重甲和黑翼质感。 | 迁移后序列：`Birth / Stand / Death`；完成 8 项结构修复。 | 雅儿贝德·守护职责节点 / 护盾破碎提示；源候选 `JNTX (549).mdx`。 | 保留为低遮挡提示层，不替换 `holyshield_state.mdx` 与 `DivineBarrier.mdx`。 | 15353 | `ACC3BE395876D4A2` |
| `Common\Effect\Form\Shield\DivineBarrier.mdx` | 候选截图观察：四枚金色盾牌环与暗金屏障都直接表达守护职责，比通用元素球更准确；前者适合状态标记，后者适合实际阻挡层。 | 迁移后序列：`Birth / Stand / Death`；完成 1 项结构修复。 | 雅儿贝德·守护者之职责 / 至尊共护；源候选 `DivineBarrier.mdx`。 | 分别用于护卫状态与主动护盾；横扫主表现仍需另找，但不强制使用额外翅膀模型。 | 7496 | `91126BD1BB79979F` |
| `Common\Effect\Form\Shield\RicoteWindShieldDamageImpact.mdx` | 青白护盾能量的径向碎击闪光，中心爆发清楚，适合在目标脚下或身体位置表达护盾层数反击的伤害结算。 | `birth / death` 原动作，并补安全 `Stand`；点创建后播放一次性冲击，不依赖单位挂点。 | 里科特神风护体的粉碎清算叠加伤害层。 | 只叠加在原生 `MonsoonBoltTarget.mdl` 落点上，不替换原有占位；不应绑定 `origin`。 | 8762 | `55BB09BBC403BF79` |
| `Common\Effect\Form\Shield\MomijiWaterMirrorV5.mdx` | 蓝白半透明水镜具有完整镜面和镜缘，退场时裂成 9 个不规则五边形碎片。 | `Birth 0-300 / Stand 301-900 / Death 901-1200`；Death 后段碎片错向旋转并淡出。 | 朱雀院红叶 W 水镜·返刃镜面主体。 | 只承担镜面表现，不承担招架判定；技能结束、打断或死亡时主动清理。 | 17087 | `524657AC852188BD` |
| `Common\Effect\Form\Shield\TsubakiVFBarrier.mdx` | 白金半透明 VF 立面护壁，中心留空，能看清英雄动作。 | `Birth / Stand / Death`；按 VF 完整状态绑定英雄并跟随。 | 朱雀院椿被动 VF 完整主体。 | 不承担护盾数值；残缺时必须先清理再换 `TsubakiVFCracked.mdx`。 | 8976 | `427C357D9083CC5E` |
| `Common\Effect\Form\Shield\TsubakiVFCracked.mdx` | 白金护壁表面出现清楚裂纹，亮度低于完好版。 | `Birth / Stand / Death`；与 VF 残缺状态同生命周期。 | 朱雀院椿 VF 残缺主体。 | 与完整护壁互斥，不能同时挂载；资源恢复、死亡或场景清理时销毁。 | 11072 | `70A9B2E4AB1C4DFF` |
| `Common\Effect\Form\Shield\TsubakiParryFlash.mdx` | 小型白金半圆闪光迅速展开，反馈克制。 | `Birth / Stand / Death`；普通招架成功点短时播放。 | 朱雀院椿 W 普通招架反馈。 | 不承担招架判定；与完美招架模型共用一张同哈希贴图。 | 3024 | `433CC7BB7C891676` |
| `Common\Effect\Form\Shield\TsubakiPerfectParry.mdx` | 多层白金半圆脉冲和交叠亮线，强度明显高于普通招架。 | `Birth / Stand / Death`；只在完美窗口成功时播放。 | 朱雀院椿 W 完美招架反馈。 | 不与普通招架同时叠加；贴图复用 `TsubakiParryFlash.blp`，重复副本已删除。 | 15444 | `5F2BEF6F6E5A6C38` |
| `Common\Effect\Form\Shield\IrenaMirrorWard.mdx` | 立体蓝色镜框和透明镜面形成正面护符，退场时镜片碎裂外散。 | `Birth 0-450 / Stand 500-1800 / Death 1850-2450`；镜面朝向取 W 快照。 | 伊蕾娜 W 镜界护符主体。 | 只表现保护窗口；偏折判定、接触点和伤害处理由 TS 完成。 | 40814 | `55645285DBF8FDD4` |
| `Common\Effect\Form\Shield\IrenaMirrorWardBackup.mdx` | 蓝色水膜球罩带环形水纹和中心保护核。 | `Birth / Stand / Death`；球形模型无需 yaw。 | 伊蕾娜 W 镜界保护备份。 | 水属性观感较强，仅作整套替代，不与镜面主体叠加。 | 10579 | `5103D3D483BC9437` |
| `Common\Effect\Form\Shield\CeliaAnalysisBarrier.mdx` | 蓝紫能量带环绕成多层保护圈，中心保持通透。 | `Birth 1000-1800 / Stand 4000-6400 / Death 8000-9000`；绑定 W 状态。 | 塞莉亚 W 解析结界主体。 | 只承担视觉；吸收、节点生成和保护消耗由 TS 管理。 | 57327 | `24464D26DF161193` |
