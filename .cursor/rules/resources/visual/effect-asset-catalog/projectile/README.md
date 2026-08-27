# Projectile 弹道分类

对应资源根目录：`imports\Common\Effect\Projectile`。

本页逐步收录已经确认用途的弹道。迁入新弹道前必须先检查现有模型的文件名、SHA-256、贴图依赖和实际外观，避免只因颜色不同就复制完整模型。

条目表：

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Projectile\tt (61).mdx` | 蓝紫细长箭状魔法弹，前端亮核明确，周围有少量水纹、星点和白色细尾迹。 | 循环 `Stand 100-900`，另有 `Birth 1000-1400 / Death 2000-2500`；沿普通攻击弹道正前方飞行。 | 伊蕾娜独立普通攻击弹道。 | 保持小尺寸和低遮挡，不复用为 Q 追迹魔弹或 R 回廊追加弹；飞行、命中和销毁由普通攻击弹道系统负责。 | 11063 | `6B64AF15B656A3A5` |
| `Common\\Effect\\Projectile\\File00002142.mdx` | 紫粉高亮的长束状投射物，前端有强光星芒与粒子拖尾，适合作为高空落向目标的箭状弹体。 | `Stand / Death`；运行时沿贝塞尔轨迹从高处落向目标。 | 鹿目圆 Q 圆环射击的三发投射物。 | 源模型内部引用 7 张 `war3mapImported\\ZK_*.blp` 私有贴图；7 张配套贴图已导入 `imports\\war3mapImported\\`，模型内部引用保持不变。 | 9814 | `47B826B876C25387` |
| `Common\Effect\Projectile\ShalltearBloodMoonCrescent.mdx` | 候选截图观察：红黑月牙轮廓简洁，可作为短促斩痕或扇区边缘；造型偏日式剑气，不能直接当成滴管长枪主体。 | 迁移后序列：`Stand / Death`；保留源动画结构。 | 夏提雅·血枪横扫 / 血月斩痕；源候选 `!blackgetsuga!.mdx`。 | 接入时检查速度与高度。 | 8319 | `5D92DAD8F232FE8B` |
| `Common\Effect\Projectile\Bloody Fang.mdx` | 候选截图观察：白红双刃和血色尾迹有攻击性，但实体刀片感过强、轨迹偏宽，只适合少量特殊攻击。 | 迁移后序列：`Birth / Stand / Death`；保留源动画结构。 | 夏提雅·血枪飞行体 / 血刃；源候选 `Bloody Fang.mdx`。 | 不作为常规细长枪迹。 | 5046 | `B9E45E0BC19ECE43` |
| `Common\Effect\Projectile\Red Quick.mdx` | 候选截图观察：红白细长高速轨迹方向明确，厚度远小于普通光炮，适合长枪直刺和高速拖尾。 | 迁移后序列：`Birth / Birth - 2 / Birth - 3 / Stand / Death`；完成 3 项结构修复。 | 夏提雅·滴管长枪拖尾 / 直线反刺；源候选 `Red Quick.mdx`。 | 接入时压低白色亮度，并避免整屏染红。 | 9108 | `78F0D70BFC7BD058` |
| `Common\Effect\Projectile\GhostlyBoneSpearPurple.mdx` | 用户指定的紫色幽魂骨矛，骨质主体与紫色灵光用于增强暗系弹体轮廓。 | `Birth / Stand / Death`；朝模型正前方飞行。 | 菲尼克斯尔骸骨弹幕的可见叠加层。 | 与原生 `SerpentWardMissile.mdl` 叠加，不单独替换原骨羽；只引用游戏内置贴图。 | 10519 | `F1082E4DE0A03619` |
| `Common\Effect\Projectile\TrollChiefExpandingShockwave.mdx` | 用户截图确认：翠绿色扇形风波连续向前推出，前端明亮、尾部收束，方向辨识清晰。 | `Stand`；模型正前方应与弹幕朝向一致。 | 树魔首领扩散冲击波的径向飞行层、消耗反击的正面冲击波。 | 用于移动弹幕，不能替代 Boss 施法点的爆发特效；依赖 Projectile 共享 Texture 贴图。 | 8219 | `FBBBECEF1B0028BF` |
| `Common\Effect\Projectile\AronkosTombstoneEchoSlash.mdx` | 高饱和红色月牙斩光，前缘清晰并带细长红蓝拖尾，能够表现墓碑残影沿预警线突进。 | `Birth / Stand / Death`；模型正前方随直线弹幕移动。 | 亚伦柯斯旧誓墓碑每 `5.2秒` 发射的残影斩击。 | 不代替方向直线预警；运行时以纯特效弹幕移动并按路径碰撞结算，复用已校验的 KnifeLight 私有贴图。 | 4818 | `E4CC810C342DF3BE` |
| `Common\Effect\Projectile\ShalltearLanceTrail.mdx` | 细长红白枪芒从黑红烟雾中向前刺出，多层尖锐光线强化高速穿刺方向。 | 原序列 `Stand / Spell One / Death / Spell Two`，迁移补齐 `Birth`；运行时按技能方向旋转。 | 夏提雅·滴管穿心本体与英灵复刻冲锋残影；源 `MapTest\file_001380\file_001380.mdx`。 | 每 `0.02` 秒创建一次、单实例存活 `0.3` 秒；高频叠加时必须限制生命周期，9 张私有贴图迁入 Projectile 共享目录，无原生贴图改写。 | 23321 | `64147021D2E6059C` |
| `Common\Effect\Projectile\ShalltearBloodMoonFinalVolley.mdx` | 紫白细长枪光，带蓝紫边缘和短促尾迹，适合作为血月终舞扇区结算时的一次性刺击补层。 | 仅保留源模型 `Birth`；结算点创建后播放 0 号动作，按当前扇区方向旋转。 | 夏提雅·血月终舞每个扇区的图 3 一次性表现。 | 不承担弹幕移动、命中或伤害；复用原生 `Textures\\...` 路径及项目已有共享贴图，4 张 `AZ_*` 贴图保留在 Projectile 共享 `Texture`。 | 33032 | `E6C673347613F215` |
| `Common\Effect\Projectile\BalzarothLavaShieldCounterProjectile.mdx` | 火红能量球与亮焰拖尾组成的反击弹体，轮廓集中，适合从护盾位置回射近战攻击者。 | 原序列 `Death / Stand`；运行时以单位载体沿锁定目标的二阶贝塞尔 XYZ 轨迹移动。 | 巴尔扎罗斯熔岩护盾的近战反弹弹道。 | 可被弹幕阻挡机制抵挡；到达攻击者后才结算反伤。6 张贴图使用游戏内置路径，1 张私有贴图迁入 Projectile 共享 `Texture`。 | 5425 | `949DC043B57828E3` |
| `Common\Effect\Projectile\SealGuardDarkEchoProjectile.mdx` | 用户从候选图确认的紫色能量球，球体轮廓集中，带紫红电弧与短尾迹。 | 原序列 `Birth / Stand / Death`；作为追踪弹体随载体朝目标移动。 | 封印守卫战精英“黑暗残响”的暗影索敌飞行弹体。 | 初始缩放建议 `0.45~0.6`；14 张贴图全部经本机 Warcraft MPQ 核验为原生路径，无私有贴图迁入。 | 11767 | `88C494891583CA5F` |
| `Common\Effect\Projectile\sem_han_bing_jian_jian_shi.mdx` | 细长冰蓝箭体带清楚的前向尖锋和寒气尾迹。 | `Stand`；沿模型正前方飞行。 | 爱蜜莉雅 Q 冰之矢发射主版本。 | 只作飞行主体，不代替命中冰爆和冰晶节点。 | 12088 | `9508421190663CD7` |
| `Common\Effect\Projectile\[TX] (1421).mdx` | 冰蓝高亮箭状弹体带短促粒子拖尾，方向辨识明确。 | `Birth / Stand / Death`；随弹道方向旋转。 | 爱蜜莉雅 Q 冰之矢发射备份。 | 与主版本二选一；原始代号已在去重备忘录登记。 | 21353 | `2A29A07C794534FF` |
| `Common\Effect\Projectile\freezingsplinter.mdx` | 单片冰晶尖刃带白蓝雪花和细短拖尾。 | `Birth / Stand / Death`；从真实发射点沿扇形方向飞行。 | 爱蜜莉雅 W 二段冰片主版本。 | 可重复实例化为扇形弹幕，但不作为 W 地面区域或普攻弹道。 | 17573 | `36AEA09E8550B228` |
| `Common\Effect\Projectile\file_001099.mdx` | 冰晶、雪花和白蓝拖尾组成的小型方向性弹体。 | `Birth / Stand / Death`；沿模型正前方飞行。 | 爱蜜莉雅 W 二段冰片备份。 | 与主版本二选一；原始代号已在去重备忘录登记。 | 17565 | `D0C66D6653EA5063` |
| `Common\Effect\Projectile\file00000543.mdx` | 小型蓝白冰弹，亮核紧凑并带短尾迹，适合高频连续发射。 | `Stand / Death`；沿攻击弹道方向飞行。 | 爱蜜莉雅普通攻击弹道主版本。 | 不能替代 Q/R 的大型技能弹体；私有贴图已重映射到 Projectile 共享目录。 | 8057 | `5DD4DBF235EE02F2` |
| `Common\Effect\Projectile\0351.mdx` | 小型细长冰蓝弹体，轮廓轻、遮挡低。 | `Stand / Death`；沿模型正前方飞行。 | 爱蜜莉雅普通攻击弹道备份。 | 与主版本二选一，实机按英雄远程攻击轴校准尺寸。 | 4345 | `5AFAE2C9C0A9559A` |
| `Common\Effect\Projectile\eff_firefly.mdx` | 金色小型羽光/飞萤状弹体，亮点密集并带细长尾迹，适合高速刀势派生弹道。 | `Birth 2166-2416 / Stand 2500-3500 / Death 4000-4250`；`Stand` 可循环，沿弹道方向飞行。 | 朱雀院红叶技能派生刀光主版本。 | 红叶是近战英雄，不能写入普通攻击弹道字段；不得替代 R 级终式斩光。9 张私有贴图已迁入。 | 314758 | `8D5DD2D1CB4A2DB3` |
| `Common\Effect\Projectile\MomijiAttackBlade.mdx` | 小型金色刀刃/光片弹体，序列间轮廓和亮度变化明显，方向轴清晰。 | `Stand 0-1000 / Spell One 2000-2999 / Death 3000-6000 / Spell Two 7000-8000`；运行时需显式选择序列并校准朝向。 | 朱雀院红叶技能派生刀光备份。 | 与 `eff_firefly.mdx` 二选一；红叶近战普通攻击不使用弹道，源代号 `file00000672.mdx`。 | 20653 | `D652771E0DBDB3E2` |
| `Common\Effect\Projectile\IrenaTrackingBolt.mdx` | 紫蓝星芒核心外带多层细风痕和短尾迹，飞行方向清楚。 | `Birth 100-1100 / Stand 2100-4100 / Death 4200-5200`；从真实发射点沿 Q 弹道移动。 | 伊蕾娜 Q 旅风追迹魔弹。 | 只负责弹体表现；追踪、穿透、目标失效和伤害由 TS 处理，源代号 `file_001264.mdx`。 | 8802 | `997969A7C1B6AC25` |
| `Common\Effect\Projectile\IrenaCorridorArcBolt.mdx` | 小型蓝紫六棱晶矢带双层收窄尾迹和断续旋转符环。 | `Birth 0-200 / Stand 300-1000 / Death 1100-1400`；从回廊八个节点按实际目标方向发射。 | 伊蕾娜 R 万法回廊追加魔弹。 | 节点位置、移动、伤害和销毁全由 R 实例控制；模型不内置弹道逻辑。 | 9649 | `F270EA93ED5FE6EA` |
| `Common\Effect\Projectile\CeliaPrismBolt.mdx` | 蓝色晶体核心外包淡蓝辉光和短尾迹，实体棱晶轮廓清楚。 | `Birth / Stand / Death`；沿弹道正前方飞行。 | 塞莉亚 Q 棱晶魔弹与缩小后的普通攻击弹道。 | 普攻使用时必须压低尺寸和亮度；折射、穿透和节点逻辑由 TS 处理，源代号 `328.mdx`。 | 8305 | `959798FCCD3FC8A0` |
| `Common\Effect\Projectile\FrierenZoltraak.mdx` | 白色短促空气炮具有压缩亮核和细长尾迹，前向轮廓明确。 | `stand 333-667 / death 1000-2000`；沿 Q 快照方向移动。 | 芙莉莲 Q Zoltraak 弹体。 | 体宽必须实机确认并缩放，不能按模型宽度扩大真实命中；命中/超程时收尾。 | 19260 | `495C48086F509E21` |
| `Common\Effect\Projectile\FrierenAttackBolt.mdx` | 白紫压缩弹体带细长方向轮廓、少量暗紫颗粒和短尾迹。 | 非循环 `Stand 3000-3333 / Death 10-1000`；沿普通攻击弹道飞行。 | 芙莉莲独立普通攻击弹道。 | 不复用为 Q/R 主炮；短 Stand 与真实飞行时长需进图校准，私有贴图已重映射。 | 11628 | `8525D1A316F54834` |
