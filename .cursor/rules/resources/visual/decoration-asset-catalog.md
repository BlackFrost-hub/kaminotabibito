# 动态装饰物资源目录

> 正式资源根目录：`imports\Common\Decoration`。游戏内路径统一从 `Common\Decoration\...` 开始，不带 `imports\` 前缀。

本目录记录由技能、剧情或场景运行时创建的非交互装饰物。它们与 `Common\Effect` 的特效模型分开管理，不计入特效文字库的模型统计；但正式采纳同样必须经过路径、贴图、完整 SHA-256、生命周期和资源用途登记。

## Flower

| 正式路径 | 外观与动画 | 已接入用途 | 生命周期与限制 | 文件规格 |
| --- | --- | --- | --- | --- |
| `Common\Decoration\Flower\FrierenFlowerCluster.mdx` | 低矮贴地的花草簇；仅有循环 `Stand`，区间 `100-500 ms`。相邻交错摆放后构成连续花海，而非单个爆发特效。 | 芙莉莲 D“创造花田的魔法”主体视觉；由动态装饰物 `D0B5` 以交错网格创建。 | 只承担视觉，不参与伤害、区域、视野、阻挡或寻路；模型无 `Death` 序列与 `Origin` 挂点，必须由 D 实例在替换、自然结束、打断、死亡时显式 `DzDoodadRemove`。实机确认贴地高度、缩放、透明与遮挡后才可视为验收完成。 | MDX `108571 B`，SHA-256 `A5F51EE39FA326C`；私有贴图 `Common\Decoration\Flower\Texture\FrierenFlowerCluster.blp`，`357447 B`，SHA-256 `30AE61F59C080818`。 |

## 迁移与去重

- 原始模型：`2251.mdx`，SHA-256 `E29258FD1AE0BB8A19897F88E00E0516FC122F8EAD00D523B7F8D522D44948BD`，迁移时仅重写私有贴图路径，因此正式 MDX 指纹不同。
- 原始私有贴图 `byg_plant_grass002.blp` 与正式贴图完整 SHA-256 一致：`30AE61F59C08081854B40CF8018F14737290AABBDFFD2C4726EF5A402A89C66E`。
- 迁移脚本：`scripts\migrate-frieren-flower-doodad.js`；脚本会先遍历 `imports` 比较完整 SHA-256，发现同内容位于其他正式路径时拒绝重复迁入。
- 物编定义：`objediting\Doodad\FrierenFlower.lua`，Rawcode `D0B5`，基类 `ZWcl`；运行时仍通过 `DzDoodadSetModel` 使用上表路径，使 `芙莉莲表现配置.特效参数.D花海.模型路径` 是有效配置而非注释。

## 摆盘基线

- 芙莉莲 D 的默认摆盘由 `芙莉莲表现配置.特效参数.D花海` 驱动：`90 x 90` 交错网格、半径内缩 `80`、最多 `25` 簇、基准缩放 `0.24`、缩放扰动 `0.08`、旋转步进 `17` 度、Z 高度 `0`。
- 参数是静态基线，不代表已进图验证。模型的约 `416 x 626 x 299` 原始包围尺寸与缩放组合需要在 War3 镜头中复核，必要时只调整上述配置，不复制第二份模型。
