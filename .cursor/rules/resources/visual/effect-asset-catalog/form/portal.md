# Form / Portal

| 模型与游戏内路径 | 文字外观 | 动画与方向 | 适用场景 | 限制／叠加关系 | 字节数 | SHA-256 |
| --- | --- | --- | --- | --- | ---: | --- |
| `Common\Effect\Form\Portal\FeliceSiegeBluePortal.mdx` | 蓝色闪烁的竖向传送门，带星芒、符文和电光层。 | `Birth / Stand / Death`；竖直门体。 | 菲利斯开始攻城时的城门出场传送门。 | 两张私有贴图位于本分类共享 `Texture`；菲利斯死亡后销毁。 | 79599 | `FEAABA422685FBE2` |
| `Common\Effect\Form\Portal\RicketSecretRoomShift.mdx` | 蓝白色短促空间传送闪光，带星芒与环形能量层。 | 仅 `Birth`；一次性效果。 | 里科特从王宫异变现场进入密室时使用。 | 仅引用魔兽原生 `grad2d`、`Star8c` 贴图；创建后按一次性特效清理。 | 7675 | `522718161B44BC60` |
| `Common\Effect\Form\Portal\RicketVoidEscape.mdx` | 紫色单次离场光效，含寒霜亮层、闪光与白色粒子层。 | 仅 `death`；一次性效果。 | 里科特在王宫密室战后撤离时使用。 | 四张私有贴图已迁入本分类共享 `Texture`；创建后按一次性特效清理。 | 5202 | `206FE73375FF3E9B` |
| `Common\Effect\Form\Portal\PalaceSecretRoomArrival.mdx` | 蓝色双环传送抵达法阵，带符文、星芒与传送圆环。 | 仅 `Birth`；一次性效果。 | 玩家队伍抵达王宫密室时使用。 | 复用 `resource\textures\Blue_Star2.blp`；传送圆贴图位于本分类共享 `Texture`，并与皇家血脉门共用。 | 9938 | `5AFCCBD5C6724D86` |
| `Common\Effect\Form\Portal\RoyalBloodlineGate.mdx` | 金色皇家传送施法门，带符文与持续能量环。 | 仅 `Stand`；持续效果。 | 里凡特以王室血脉开启密室门时使用。 | 复用 `resource\textures\Blue_Star2.blp` 与本分类的传送圆贴图；使用结束后销毁。 | 10074 | `8C960B9E5BE76570` |
