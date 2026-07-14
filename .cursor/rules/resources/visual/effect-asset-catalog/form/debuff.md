# Form / Debuff

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Form\Debuff\AinzHeartCountdown.mdx` | 中央为深红解剖心脏浅浮雕，外围十二枚红色倒计时刻度；整体像悬浮的死亡状态图标。 | YZ 竖直朝向；心脏独立收缩回弹，刻度逐秒熄灭；`Birth / Stand / Death`。 | 十二秒处决倒计时、心脏诅咒。 | 刻度承担读秒，不能被外圈同步心跳抖动；处决需另叠捏心模型。 | 22009 | `D012D5F60CB9927F` |
| `Common\Effect\Form\Debuff\AinzHeartGrasp.mdx` | 一只苍白骨感手掌伸出并捏住红色心脏，主体清楚、动作直接。 | 一次性伸手、抓握和清理；`Birth / Stand / Death`。 | 心脏倒计时归零处决。 | 不承担十二秒倒计时；应与 `AinzHeartCountdown.mdx` 分层播放。 | 43822 | `61C734541C093323` |
| `Common\Effect\Form\Debuff\AinzDeathClock.mdx` | 暗红死亡钟盘，单根指针，外围十二枚独立刻度；没有爱心或心脏图案。 | 竖直广告牌；每秒停驻后快速跳到下一刻度；`Birth / Stand / Death`。 | 十二秒死亡钟、逐秒滴答倒计时。 | 音效由技能逻辑逐秒播放；模型本身不嵌入十二个声音。 | 32546 | `F1DADF0C29068B4D` |
| `Common\Effect\Form\Debuff\AlbedoWingBind.mdx` | 成对黑色羽翼与黑白翼光向中央合拢，形成包围目标的翼铠外壳。 | 向中心收拢后维持，再淡出；`Birth / Stand / Death`。 | 黑翼拘束、翼铠封锁。 | 外壳中央辨识度不足，必须叠加暗金核心。 | 83355 | `DA5671E1CD1CC527` |
| `Common\Effect\Form\Debuff\AlbedoWingBindCore.mdx` | 暗金亮点、贴地圆环与上方收束符号组成清楚的拘束焦点。 | 低位核心循环维持；`Birth / Stand / Death`。 | 可选中的拘束核心、黑翼中心焦点。 | 只承担核心，不单独代替黑翼外壳。 | 19709 | `64C3B26EA3B9753B` |
| `Common\Effect\Form\Debuff\dds2136-01.mdx` | 灰白圆环具有死亡时钟底盘感，画面克制。 | 圆环状态表现。 | 安兹死亡倒计时底层备选。 | 截图不能证明十二分段和逐格动画，不能替代正式死亡钟。 | 3308 | `DC0471807A787D15` |
| `Common\Effect\Form\Debuff\SpiritGuardMoonBind.mdx` | 冷蓝弧线与魂点从外向内缓慢聚集，束缚方向明确。 | 原动画约三秒向内收拢；迁移版补齐安全 `Death`。 | 苍影灵卫月纹缚魂、冷蓝收束禁锢。 | 技能结算需加速到约 1.2 秒；不与镇魂印同点堆放。 | 9862 | `41383F0D0D2B16E0` |
| `Common\Effect\Form\Debuff\byakuganaura.mdx` | 候选截图观察：灰白圆盘外沿具有刻度感，比普通法阵更接近时钟；中心图案仍偏眼瞳，且无法确认刻度数量。 | 迁移后序列：`Stand / Death`；完成 2 项结构修复。 | 安兹·死亡倒计时；源候选 `byakuganaura.mdx`。 | 与 `dds2136-01.mdx` 比较十二段可读性。 | 6172 | `489DD5A16A1BD868` |
| `Common\Effect\Form\Debuff\EntanglingBonesTarget.mdx` | 候选截图观察：骨爪轮廓配少量红色粒子，能清楚指向被点名目标，补足“黑骨爪”的语义。 | 迁移后序列：`Birth / Death / Stand / Birth Medium / Death Medium / Stand Medium / Birth Large / Death Large / Stand Large`；完成 45 项结构修复。 | 安兹·心脏掌握的骨爪点名层；源候选 `EntanglingBonesTarget.mdx`。 | 缩小后挂在目标胸口附近；它不替代胸口暗红心印和倒计时层。 | 57243 | `EF59BA5C20A09AB8` |
| `Common\Effect\Form\Debuff\ShalltearBloodDropMark.mdx` | 候选截图观察：竖向暗红血滴的主体明确，缩小后比大面积血阵更适合作为第二段命中的短促血印。 | 迁移后序列：`Birth / Stand / Death`；完成 2 项结构修复。 | 夏提雅·普攻二段鲜血标记；源候选 `JNTX (272).mdx`。 | 仅挂在受击单位上方或胸口附近，缩放要小，持续短，不遮挡血条；不作为地面血池。 | 17616 | `FF31CE5EA269D2D0` |
| `Common\Effect\Form\Debuff\AinzTimeStopClockFace.mdx` | 候选截图观察：圆形符文刻度和清晰指针能直接传达时间冻结，比普通圆阵更准确；当前冷蓝色偏亮，不能单独承担全场停时。 | 迁移后序列：`Stand / Death / Stand Alternate`；完成 1 项结构修复。 | 安兹·时间停止钟面内层；源候选 `JNTX (434).mdx`。 | 与场景褪色、静止碎片和短时冻结表现组合；实机检查能否压低蓝色亮度。 | 3328 | `022F30BE93131BA3` |
| `Common\Effect\Form\Debuff\AlbedoGoldenRestraintCore.mdx` | 候选截图观察：金色环形牢笼可作为拘束核心或护盾骨架，但没有黑翼语义，单独使用会像通用奥术音波。 | 迁移后序列：`Birth / Stand / Death`；完成 3 项结构修复。 | 雅儿贝德·黑翼拘束 / 联动护盾；源候选 `Sound.mdx`。 | 仅考虑与黑翼、暗金护盾组合。 | 6634 | `84851684759A1822` |
| `Common\Effect\Form\Debuff\AinzTimeStopGearFragmentsA.mdx` | 候选截图观察：暖金机械齿轮与星点碎光围绕中心浮动，为冷蓝钟面补充明确的时间机械语义。 | 迁移后序列：`Birth / Stand / Death`；完成 4 项结构修复。 | 安兹·时间停止齿轮碎片 A；源候选 `JNTX (375).mdx`。 | 只作钟面周围少量辅助碎片，不可大量铺屏或替代全场褪色。 | 21061 | `FE79437D8C59BDD6` |
| `Common\Effect\Form\Debuff\AinzTimeStopGearFragmentsB.mdx` | 候选截图观察：与 A 型共用暖金齿轮贴图体系，但模型结构和动画数据不同，可作为另一组机械碎片层。 | 迁移后序列：`Birth / Stand / Death`；完成 4 项结构修复。 | 安兹·时间停止齿轮碎片 B；源候选 `JNTX (376).mdx`。 | A/B 为不同模型，不按相同贴图去重；实机二选一或少量错位组合。 | 31981 | `FD63B494D9A39E1C` |
