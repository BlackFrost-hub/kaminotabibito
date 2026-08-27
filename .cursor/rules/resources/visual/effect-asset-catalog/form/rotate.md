# Form / Rotate

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Form\Rotate\ShalltearBloodMoonHorizontalSlash.mdx` | 深红水平环斩，刀光体系统一、方向清楚。 | 水平绕身切割；迁移版补齐安全 `Death`。 | 夏提雅血月轮舞水平环斩。 | 不能代替直线反刺或地面范围预警。 | 8092 | `855946F1D6776EFF` |
| `Common\Effect\Form\Rotate\ShalltearBloodMoonDiagonalSlash.mdx` | 深红斜向环斩，与水平环斩形成同体系变体。 | 斜向绕身切割；迁移版补齐安全 `Death`。 | 夏提雅血月轮舞斜斩变化。 | 与水平版错峰使用，避免同帧过亮。 | 14292 | `6DEAA7E7D67FA8C6` |
| `Common\Effect\Form\Rotate\youmu_w_eff1.mdx` | 蓝黑回旋剑势包裹中心黑雾，带亡冥魂力感。 | 围绕剑刃或施法者回旋。 | 亚伦柯斯亡冥英斩蓄势、命中辅助。 | 形状偏圆，只作蓄势层，不代替路径预警。 | 16788 | `DD1422D88A9BAFFD` |
| `Common\Effect\Form\Rotate\AinzBlackGoldPortalVortex.mdx` | 候选截图观察：深黑中心配金色旋涡和尘粒，颜色体系正确；但缺少门框与法阵结构，完整度不及当前三层组合。 | 迁移后序列：`Birth / Stand / Death`；保留源动画结构。 | 安兹·黑金传送门旋涡辅助；源候选 `JNTX (50).mdx`。 | 只保留为开门或收门瞬间的地面旋涡，不替换 `JNTX (91).mdx` + `yang_tx1.mdx` + `blackhole.mdx`。 | 12978 | `DF29D652903D02A3` |
| `Common\Effect\Form\Rotate\AinzBlackGoldPortalCore.mdx` | 候选截图观察：多层淡金旋环围绕深黑中心，黑金关系清楚、旋转稳定，语义比普通紫色传送门更接近至尊门扉。 | 迁移后序列：`Birth / Stand / Death`；完成 2 项结构修复。 | 安兹·黑金传送门地面核心；源候选 `yang_tx1.mdx`。 | 与 `blackhole.mdx` 的暗色空间层组合，后续再补竖向门框。 | 2778 | `D96966D6473F5E03` |
| `Common\Effect\Form\Rotate\AbyssCyclone.mdx` | 蓝白寒光旋风，中心能量密集，外沿带高速环流。 | 原模型持续旋转表现；适合作为移动旋风弹幕。 | 教派剑士深渊旋风路径特效；源模型 `sem_xuan_feng_8.mdx`。 | 现按技能配置缩放 `1.6` 使用；私有贴图位于同分类 `Texture` 目录。 | 21555 | `DA7755D07612AF2C` |
| `Common\Effect\Form\Rotate\ClaudeQSlashCut.mdx` | 白蓝高亮的中心能量团，外围由多道弧形剑光交错环绕，爆发感强且轮廓集中。 | 源模型保留 `Birth`，迁移补充安全 `Stand / Death`；按每次切割的随机方向短时点放。 | 克劳德 Q 二段剑气切割的叠加命中特效。 | 只作 Q2 乱斩的表现叠加，不承担伤害或碰撞；5 张 `Textures\...` 为魔兽原生贴图，4 张 `AZ_*` 私有贴图迁入同分类 `Texture`。 | 5627 | `BFA239CA47CE810D` |
| `Common\Effect\Form\Rotate\MomijiVigorOrbit1.mdx` | 朱红短刃竖直环绕中心，单枚刀刃清楚可读，不形成大圆环。 | `Birth / Stand / Death`；`Stand` 持续绕 Z 轴旋转，刀刃骨骼独立广告牌朝向镜头。 | 朱雀院红叶被动 1 层刀势提示。 | 与 `MomijiVigorOrbit2/3` 为 1/2/3 层互斥模型，按当前刀势层数只创建一个；使用共享私有贴图 `MomijiVigorOrbitBlade.blp`（SHA-256 `D56B7E900891D55B`），低亮度绑定红叶身边，不遮挡单位。 | 2412 | `F80677DD9814FF05` |
| `Common\Effect\Form\Rotate\MomijiVigorOrbit2.mdx` | 两枚朱红短刃以相对位置竖直环绕中心，方向分离，层数辨识明确。 | `Birth / Stand / Death`；`Stand` 持续绕 Z 轴旋转，刀刃骨骼独立广告牌朝向镜头。 | 朱雀院红叶被动 2 层刀势提示。 | 与 `MomijiVigorOrbit1/3` 为互斥层数模型，不能同时叠加；使用共享私有贴图 `MomijiVigorOrbitBlade.blp`（SHA-256 `D56B7E900891D55B`），低亮度绑定红叶身边。 | 3024 | `098CFE4FF189419A` |
| `Common\Effect\Form\Rotate\MomijiVigorOrbit3.mdx` | 三枚朱红短刃围绕中心形成紧凑环绕提示，仍保留单位本体可见空间。 | `Birth / Stand / Death`；`Stand` 持续绕 Z 轴旋转，刀刃骨骼独立广告牌朝向镜头。 | 朱雀院红叶被动 3 层刀势提示。 | 与 `MomijiVigorOrbit1/2` 为互斥层数模型，不能同时叠加；使用共享私有贴图 `MomijiVigorOrbitBlade.blp`（SHA-256 `D56B7E900891D55B`），低亮度绑定红叶身边。 | 3636 | `DEEF4DC63A412B2C` |
| `Common\Effect\Form\Rotate\TsubakiIchiGuard.mdx` | 银白单刀光沿人物周围缓慢环绕，姿态克制。 | `Birth / Stand / Death`；绑定椿并随一刀守势持续。 | 朱雀院椿 D 一刀守势提示。 | 与二刀攻势互斥，切换、死亡和场景清理时先销毁旧姿态。 | 4672 | `712FA0E3DE39D706` |
| `Common\Effect\Form\Rotate\TsubakiNitoAssault.mdx` | 红蓝两道刀光在人物周围交错环绕，攻势辨识明确。 | `Birth / Stand / Death`；绑定椿并随二刀状态持续。 | 朱雀院椿 D 二刀攻势提示。 | 与一刀守势互斥；只使用红/蓝两张正式贴图，不迁入旧单贴图版本。 | 5036 | `E372AC226B35B71E` |
| `Common\Effect\Form\Rotate\IrenaFlightWindBackup.mdx` | 蓝白水风旋流围绕中心高速旋转，体量较大。 | `Birth / Stand / Death`；跟随飞行状态。 | 伊蕾娜 E 飞行风压整套备份。 | 水龙卷语义较强，只在主轨迹组合不合适时整套替换，不与主组合满亮叠加。 | 20482 | `42BF966A4E4EBD10` |
