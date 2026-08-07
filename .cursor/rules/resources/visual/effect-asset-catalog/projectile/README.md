# Projectile 弹道分类

对应资源根目录：`imports\Common\Effect\Projectile`。

当前尚未把已有弹道逐个写入视觉说明。迁入新弹道前必须先检查现有模型的文件名、SHA-256、贴图依赖和实际外观，避免只因颜色不同就复制完整模型。

条目表：

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Projectile\ShalltearBloodMoonCrescent.mdx` | 候选截图观察：红黑月牙轮廓简洁，可作为短促斩痕或扇区边缘；造型偏日式剑气，不能直接当成滴管长枪主体。 | 迁移后序列：`Stand / Death`；保留源动画结构。 | 夏提雅·血枪横扫 / 血月斩痕；源候选 `!blackgetsuga!.mdx`。 | 接入时检查速度与高度。 | 8319 | `5D92DAD8F232FE8B` |
| `Common\Effect\Projectile\Bloody Fang.mdx` | 候选截图观察：白红双刃和血色尾迹有攻击性，但实体刀片感过强、轨迹偏宽，只适合少量特殊攻击。 | 迁移后序列：`Birth / Stand / Death`；保留源动画结构。 | 夏提雅·血枪飞行体 / 血刃；源候选 `Bloody Fang.mdx`。 | 不作为常规细长枪迹。 | 5046 | `B9E45E0BC19ECE43` |
| `Common\Effect\Projectile\Red Quick.mdx` | 候选截图观察：红白细长高速轨迹方向明确，厚度远小于普通光炮，适合长枪直刺和高速拖尾。 | 迁移后序列：`Birth / Birth - 2 / Birth - 3 / Stand / Death`；完成 3 项结构修复。 | 夏提雅·滴管长枪拖尾 / 直线反刺；源候选 `Red Quick.mdx`。 | 接入时压低白色亮度，并避免整屏染红。 | 9108 | `78F0D70BFC7BD058` |
| `Common\Effect\Projectile\GhostlyBoneSpearPurple.mdx` | 用户指定的紫色幽魂骨矛，骨质主体与紫色灵光用于增强暗系弹体轮廓。 | `Birth / Stand / Death`；朝模型正前方飞行。 | 菲尼克斯尔骸骨弹幕的可见叠加层。 | 与原生 `SerpentWardMissile.mdl` 叠加，不单独替换原骨羽；只引用游戏内置贴图。 | 10519 | `F1082E4DE0A03619` |
| `Common\Effect\Projectile\TrollChiefExpandingShockwave.mdx` | 用户截图确认：翠绿色扇形风波连续向前推出，前端明亮、尾部收束，方向辨识清晰。 | `Stand`；模型正前方应与弹幕朝向一致。 | 树魔首领扩散冲击波的径向飞行层、消耗反击的正面冲击波。 | 用于移动弹幕，不能替代 Boss 施法点的爆发特效；依赖 Projectile 共享 Texture 贴图。 | 8219 | `BC954A50C76C0E21` |
| `Common\Effect\Projectile\AronkosTombstoneEchoSlash.mdx` | 高饱和红色月牙斩光，前缘清晰并带细长红蓝拖尾，能够表现墓碑残影沿预警线突进。 | `Birth / Stand / Death`；模型正前方随直线弹幕移动。 | 亚伦柯斯旧誓墓碑每 `5.2秒` 发射的残影斩击。 | 不代替方向直线预警；运行时以纯特效弹幕移动并按路径碰撞结算，复用已校验的 KnifeLight 私有贴图。 | 4818 | `E4CC810C342DF3BE` |
| `Common\Effect\Projectile\ShalltearLanceTrail.mdx` | 细长红白枪芒从黑红烟雾中向前刺出，多层尖锐光线强化高速穿刺方向。 | 原序列 `Stand / Spell One / Death / Spell Two`，迁移补齐 `Birth`；运行时按技能方向旋转。 | 夏提雅·滴管穿心本体与英灵复刻冲锋残影；源 `MapTest\file_001380\file_001380.mdx`。 | 每 `0.02` 秒创建一次、单实例存活 `0.3` 秒；高频叠加时必须限制生命周期，9 张私有贴图迁入 Projectile 共享目录，无原生贴图改写。 | 23321 | `64147021D2E6059C` |
| `Common\Effect\Projectile\ShalltearBloodMoonFinalVolley.mdx` | 紫白细长枪光，带蓝紫边缘和短促尾迹，适合作为血月终舞扇区结算时的一次性刺击补层。 | 仅保留源模型 `Birth`；结算点创建后播放 0 号动作，按当前扇区方向旋转。 | 夏提雅·血月终舞每个扇区的图 3 一次性表现。 | 不承担弹幕移动、命中或伤害；复用原生 `Textures\\...` 路径及项目已有共享贴图，4 张 `AZ_*` 贴图保留在 Projectile 共享 `Texture`。 | 33032 | `E6C673347613F215` |
| `Common\Effect\Projectile\BalzarothLavaShieldCounterProjectile.mdx` | 火红能量球与亮焰拖尾组成的反击弹体，轮廓集中，适合从护盾位置回射近战攻击者。 | 原序列 `Death / Stand`；运行时以单位载体沿锁定目标的二阶贝塞尔 XYZ 轨迹移动。 | 巴尔扎罗斯熔岩护盾的近战反弹弹道。 | 可被弹幕阻挡机制抵挡；到达攻击者后才结算反伤。6 张贴图使用游戏内置路径，1 张私有贴图迁入 Projectile 共享 `Texture`。 | 5425 | `949DC043B57828E3` |
| `Common\Effect\Projectile\SealGuardDarkEchoProjectile.mdx` | 用户从候选图确认的紫色能量球，球体轮廓集中，带紫红电弧与短尾迹。 | 原序列 `Birth / Stand / Death`；作为追踪弹体随载体朝目标移动。 | 封印守卫战精英“黑暗残响”的暗影索敌飞行弹体。 | 初始缩放建议 `0.45~0.6`；14 张贴图全部经本机 Warcraft MPQ 核验为原生路径，无私有贴图迁入。 | 11767 | `88C494891583CA5F` |
