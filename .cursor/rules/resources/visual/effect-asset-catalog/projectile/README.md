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
