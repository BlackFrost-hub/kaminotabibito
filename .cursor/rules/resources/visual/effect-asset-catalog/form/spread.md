# Form / Spread

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Form\Spread\AlbedoBlackWingSweepPressure.mdx` | 灰黑弧形气压横向展开，形成宽扇翼压外沿。 | 横向拉宽并向外扫开；迁移版补齐安全 `Stand / Death`。 | 雅儿贝德黑翼横扫主气压。 | 需跟随本体翅膀动作，不能单独代替暗金重击结算。 | 3244 | `ABA60320F39EC46F` |
| `Common\Effect\Form\Spread\AlbedoShadowWingSweep.mdx` | 大型暗影翼刃回旋轮廓，带蓝紫阴影层。 | 翼形向外扫开；迁移时修正三个粒子时间中点并补 `Death`。 | 黑翼横扫、至尊拦截弱备选。 | 体量和贴图较重，颜色仍需实机压暗；不替换正式黑翼主体。 | 217452 | `EADC10E907CABEEA` |
| `Common\Effect\Form\Spread\AlbedoWhiteVioletWingSweep.mdx` | 白紫翼影快速展开，角色专用感强但亮度偏高。 | 翼影向外扩张；迁移版补齐安全 `Death`。 | 黑翼横扫、拦截辅助备选。 | 必须压低亮度和持续时间，不能作为暗金主视觉。 | 4211 | `A9643FD807B6C889` |
| `Common\Effect\Form\Spread\AlbedoWingFeather.mdx` | 单枚灰白羽片轮廓清楚，可补横扫方向。 | 少量羽片沿横扫方向飞散；迁移版补齐 `Stand / Death`。 | 雅儿贝德黑翼横扫羽屑。 | 只作少量辅助粒子，不承担扇形翼压。 | 3656 | `F601687B92967984` |
| `Common\Effect\Form\Spread\AronkosAwakeningSoulWave.mdx` | 低矮灰白魂雾沿圆环向外扩散，庄严克制。 | 贴地向外扩散；迁移时补发射率轨道及安全 `Stand / Death`。 | 亚伦柯斯开战苏醒、低强度军魂脉冲。 | 不播放火焰、血浆或高亮爆炸；范围待实机校准。 | 23696 | `F0914CD760948192` |
| `Common\Effect\Form\Spread\BlueSoulFlashSpread.mdx` | 蓝白高亮核心瞬间闪烁，外圈放射光束与水平镜头光向四周扩散。 | 单次 `death` 序列，在约一秒内由中心迅速放大并淡出；源候选 `file_001339.mdx`。 | 苍影校魂法典的灵识校准命中，也可用于冷蓝灵魂校准或净化闪光。 | 运行时高度使用 `75`，否则中心光层容易穿地；亮度集中，不要在同点连续高频叠放。 | 2333 | `151B048E2336060C` |
| `Common\Effect\Form\Spread\qianbenying8.mdx` | 粉紫花瓣从中心短促爆开，花瓣语义明确。 | 向外散开。 | 夏提雅蔷薇、花瓣爆发辅助层。 | 中心偏亮且颜色偏粉紫，仅作短促备选；有深红花瓣时优先替换。 | 2800 | `4BF6630141EDB23F` |
| `Common\Effect\Form\Spread\CrimsonWake.mdx` | 候选截图观察：红色帷幕有血潮感，但体积高、遮挡重，不适合频繁战斗提示。 | 迁移后序列：`Birth / Stand / Death`；完成 2 项结构修复。 | 夏提雅·血气回收 / 阶段过渡；源候选 `CrimsonWake.mdx`。 | 只看能否缩成短时阶段特效。 | 4579 | `F78173ABCACA21C6` |
| `Common\Effect\Form\Spread\ShalltearRosePetalFragments.mdx` | 候选截图观察：前者有深红领域氛围但遮挡偏重；后者有花瓣语义但颜色明显偏紫。二者都只能作辅助层，不能单独定稿。 | 迁移后序列：`Stand / Death`；保留源动画结构。 | 夏提雅·血镜领域 / 玫瑰碎片辅助层；源候选 `senbonzakurapart.mdx`。 | 花瓣若不能改成深红或银红则淘汰。 | 2708 | `E1E2A7D2D9A62737` |
| `Common\Effect\Form\Spread\ShalltearBloodPoolSpread.mdx` | 候选截图观察：低矮深红液态波纹贴地向外扩散，具有血池铺开的质感。 | 迁移后序列：`Stand / Death`；保留源动画结构。 | 夏提雅·真祖血宴血池冲击辅助；源候选 `JNTX (436).mdx`。 | 边缘较糊且没有血晶、蔷薇结构，只作低层铺底，不替代血印与血月法阵。 | 2756 | `91F7A2AA1D91D752` |
| `Common\Effect\Form\Spread\az_shanxian02.mdx` | 深红黑色能量幕从中心旋卷扩散，中央有白色闪点、暗金小型涡心，并伴随碎片与星点飞散。 | 单次 `Birth` 序列，红黑外沿快速向外展开；保留源模型名。 | 英灵战乙女蔷薇镜的唯一触发特效，也适合血族闪现、镜像开启或红黑空间扩散。 | 视觉范围较大且黑红遮挡较强，使用 0.8 秒短生命周期；wp191 不再叠加旧蔷薇镜缘或血色冲击。 | 17792 | `FB0B73A242543FEB` |
