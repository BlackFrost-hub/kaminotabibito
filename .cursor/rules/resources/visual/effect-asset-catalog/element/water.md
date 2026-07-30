# Element / Water

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Element\Water\KaselaTentacleLashEmerge.mdx` | 蓝白水系魔法柱，带环形光晕、粒子和碎石，适合表现从地面爆发出现。 | `Stand`：帧 `1000-4000`，约 3 秒。 | 卡瑟拉“触手鞭笞”三条触手在中心位置同时出现的瞬时效果。 | 仅作为出现层；不替代预警圈或持续区域。模型私有贴图位于同分类 `Texture`。 | 32157 | `A9FDA21E601C4CC1` |
| `Common\Effect\Element\Water\KaselaAbyssalVortexEnergyBurst.mdx` | 蓝白能量爆闪，中心高亮并伴随环状星芒，适合为深渊潜入或回归补充魔力释放节点。 | `Stand`：帧 `1000-3000`，约 2 秒；`Death`：帧 `4000-5000`。 | 卡瑟拉潜入/回归水涡流的能量叠加层。 | 与 `WaterTornado.mdx` 和水柱层同点短时叠加，当前技能缩放 `2.0`。 | 4328 | `71736CDDFC724552` |
| `Common\Effect\Element\Water\KaselaAbyssalWaterEmerge.mdx` | 低位水面涟漪包围中央上涌蓝白水柱，适合表现深渊生物破水而出。 | `Birth`：帧 `0-2333`，约 2.333 秒。 | 卡瑟拉潜入/回归水涡流叠加层，以及深渊幼鱿、巨型触手的出现效果。 | 私有辉光贴图位于同分类 `Texture`；潜入/回归缩放 `2.0`，幼鱿 `1.0`，巨型触手 `1.5`。 | 14376 | `66B22B60B6029733` |
