# Element / Ice

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Element\Ice\sem_shen_du_dong_jie.mdx` | 厚重蓝白冰层包裹目标，冻结轮廓清楚。 | `Birth / Stand / Death`；绑定目标位置播放冻结、维持和解除。 | 爱蜜莉雅被动冻结状态主版本。 | 只承担冻结表现，控制、伤害和解除由技能实例管理。 | 39969 | `FC80E4DF3C0C755D` |
| `Common\Effect\Element\Ice\FrozenMana.mdx` | 冷蓝冰霜与魔力粒子环绕目标，主体较轻。 | `Stand / Birth / Death`；随目标位置维持。 | 爱蜜莉雅被动冻结状态备份。 | 与 `sem_shen_du_dong_jie.mdx` 二选一，不重复叠加。 | 8717 | `BCFC3B0ED01D1866` |
| `Common\Effect\Element\Ice\file00000153.mdx` | 蓝白冰晶簇与碎冰粒子集中爆开，落点读取明确。 | `Stand / Death`；在真实命中点或节点位置创建。 | 爱蜜莉雅 Q 命中冰晶层主版本。 | 不作为 Q 飞行弹道，也不承担节点和伤害判定。 | 65340 | `D53C926AB0562C96` |
| `Common\Effect\Element\Ice\file_000948.mdx` | 透明冰晶球壳向外展开并破碎，冰片层次较密。 | `birth / death`；点状创建。 | 爱蜜莉雅 Q 命中冰晶层备份。 | 亮度和体量待实机校准；与主版本二选一。 | 37081 | `C51A4CE780F6565A` |
| `Common\Effect\Element\Ice\iceflower.mdx` | 白蓝冰晶从地面形成花簇，中心主体清楚。 | `Stand`；地面创建，朝向取技能目标方向。 | 爱蜜莉雅 W 冰花主体主版本。 | 没有独立 Birth/Death；结束、打断或死亡时由技能实例主动销毁。 | 31392 | `382A9D9B183C44EE` |
| `Common\Effect\Element\Ice\2.mdx` | 雪花、冰雾和环绕流线由地面向外绽放。 | `Birth`，约 `1.5s`；地面一次性播放。 | 爱蜜莉雅 W 冰花主体备份。 | 只作展开过程，不代替真实区域和减速。 | 20838 | `21B08A8FE4DDC3C0` |
| `Common\Effect\Element\Ice\file_000916.mdx` | 蓝白圆环、冰雪粒子与旋流形成可读的寒气边界。 | `Birth`，约 `1s`；在区域中心短促播放。 | 爱蜜莉雅 W 寒气边界主版本。 | 不循环重建，不把视觉边缘当作实际范围。 | 8300 | `1B069BF96FFE7009` |
| `Common\Effect\Element\Ice\sem_leng_xuan_wo.mdx` | 蓝白旋转寒气环伴随冰晶星点，轮廓轻薄。 | `Birth`，约 `2s`；地面中心创建。 | 爱蜜莉雅 W 寒气边界备份。 | 只作短时边界辅助，不单独冒充冰花或永冻领域。 | 3928 | `BAD0FABC5E907A37` |
| `Common\Effect\Element\Ice\BY_Wood_Effect_Kula_3_BingGuan.mdx` | 完整透明冰晶球壳包围单位，护身语义直接。 | `birth / death`；附着英雄位置。 | 爱蜜莉雅 E 冰晶护身主版本。 | 只承担护罩视觉；E 结束、破盾、打断和死亡时统一清理。 | 62480 | `CF1AE66073E280EF` |
| `Common\Effect\Element\Ice\sem_bing_jia_shu_2.mdx` | 蓝白冰甲与环形冰晶围绕单位维持。 | `Stand`；随英雄位置保持。 | 爱蜜莉雅 E 冰晶护身备份。 | 与主护罩二选一；不代替吸收数值和破盾判定。 | 20611 | `68988871B9257C37` |
| `Common\Effect\Element\Ice\EmiliaEIcePathTile.mdx` | 方形半透明冰面裂隙单元，边缘带冰霜纹理。 | `Birth / Death`；按位移轨迹方向设置 yaw。 | 爱蜜莉雅 E 位移冰面路径。 | 长路径由多个方形单元按间距叠加，不能拉伸单个模型冒充长拖尾。 | 5795 | `F570810442B6C6AA` |
| `Common\Effect\Element\Ice\EmiliaEIceExplosion.mdx` | 蓝白冰能量与碎冰从中心瞬时爆发。 | `Birth`，约 `1.5s`；在真实落点单次创建。 | 爱蜜莉雅 E 落点冰爆。 | 不承担持续路径、护盾或伤害判定。 | 188540 | `53E8018C88530717` |
| `Common\Effect\Element\Ice\EmiliaEShatterCrack.mdx` | 中心向外分叉的冰面裂纹，读取短促清楚。 | `Birth / Stand / Death`；贴地播放。 | 爱蜜莉雅 E 破盾与结算裂开层。 | 只作破盾/结算视觉，不承担破盾检测。 | 1680 | `2520A843217104B7` |
| `Common\Effect\Element\Ice\EmiliaIceCrystalNode.mdx` | 固定成形的简洁冰晶主体，无周围光点和粒子发射器。 | `Birth / Stand / Death`；固定在世界坐标。 | 爱蜜莉雅 Q/W/E 通用冰晶节点。 | 不是单位壳；数量、读取和生命周期全部由技能实例维护。 | 2272 | `3734B8D77C5EE9CD` |
| `Common\Effect\Element\Ice\sem_shuang_dong_xin_xing.mdx` | 多阶段冰环与霜冻核心铺开，形成大型永冻领域。 | `stand - 1 / stand - 2 / stand - 3 / death`；地面中心播放。 | 爱蜜莉雅 R 永冻领域主版本。 | 视觉半径不参与伤害和冻结范围判定。 | 140448 | `6903C0473B22DE80` |
| `Common\Effect\Element\Ice\JNTX (316).mdx` | 蓝色地面核心、上升冰能量与粒子环构成中心冰柱。 | `Stand`；领域中心维持。 | 爱蜜莉雅 R 永冻领域备份/中心收束层。 | 不把光柱高度或覆盖面积当作真实范围。 | 83306 | `C582A13FCCDD4D81` |
| `Common\Effect\Element\Ice\Shiva'sWrath.mdx` | 蓝白垂直冰能量、底部冲击和大幅冰爆同时收束。 | `Birth`，约 `1.367s`；结算点一次性播放。 | 爱蜜莉雅 R 最终冰爆主版本。 | 不代替持续领域和冰晶读取；使用项目现有修正版，不覆盖。 | 9845 | `80876E7102E50FFE` |
| `Common\Effect\Element\Ice\sem_bing_xi_mo_fa.mdx` | 冰霜颗粒和雪花由中心向外爆开。 | `Stand`，约 `1.333s`；结算点单次播放。 | 爱蜜莉雅 R 最终冰爆备份。 | 与主版本二选一，不作为常驻领域。 | 6222 | `241FE38DB022DCB0` |
| `Common\Effect\Element\Ice\BY_Wood_Effect_Ord_DanGe_Wav_Kuosan_1_3_0.5s.mdx` | 冷蓝环形波纹从中心向四周快速扩散。 | `death`，约 `0.5s`；360 度一次性播放。 | 爱蜜莉雅 D 帕克显现扩散主版本。 | 不循环创建，不把视觉半径当作伤害范围。 | 17734 | `9E3DD9CDF12416B9` |
| `Common\Effect\Element\Ice\BY_Wood_Effect_Ord_DanGe_Wav_Kuosan_1_3_1s.mdx` | 与主版本同形态的冷蓝环形扩散，持续更长。 | `death`，约 `1s`；360 度一次性播放。 | 爱蜜莉雅 D 帕克显现扩散备份。 | 与 `0.5s` 版本二选一，不能重复叠放。 | 17734 | `742C6E40A40B7C48` |
| `Common\Effect\Element\Ice\icespirits.mdx` | 蓝白冰灵粒子与弧形能量围绕中心流动。 | `Stand / Death`；跟随英雄或契约冰核。 | 爱蜜莉雅 D 帕克环绕主版本。 | 不代替帕克实体和强化次数；D 结束、打断和死亡时清理。 | 7342 | `5F059B157DDEF25F` |
| `Common\Effect\Element\Ice\FrostHands.mdx` | 冰霜灵体般的双侧能量环绕目标，轮廓较轻。 | `Birth / Stand / Death`；随英雄位置维持。 | 爱蜜莉雅 D 帕克环绕备份。 | 与主版本二选一，不脱离 D 实例常驻。 | 5613 | `97269C8C49C4F0F8` |
