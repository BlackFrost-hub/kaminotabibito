# Lightning 闪电资源

闪电资源不是 MDX 模型，而是 Warcraft 3 的 `Splats` 定义和定义引用的私有贴图。

| 资源 | 游戏内路径 | 说明 |
| --- | --- | --- |
| `LightningData.slk` | `Splats\LightningData.slk` | 注册闪电 rawcode（例如 `BLSB`、`YESB`）及其宽度、颜色、生命周期和贴图引用。 |
| `SBL_*.blp` | `Common\Effect\Lightning\Texture\SBL_*.blp` | `LightningData.slk` 使用的项目私有闪电贴图；不复制 Warcraft 3 原生天气贴图。 |

当前 Beam 资源除原有红、黄、绿、蓝、白外，已补充四种七色封印演出专用贴图：
`SBL_PinkBeam.blp`、`SBL_BlackBeam.blp`、`SBL_GoldBeam.blp`、`SBL_CyanWhiteBeam.blp`。
对应 rawcode 为 `PNBM`、`BKMB`、`GDBM`、`CWBM`，均登记在 `Splats\LightningData.slk`。

代码入口为 `TS/系统/03．技能系统/00．技能模板+函数/02．通用函数/17．闪电效果代码.ts`，运行时只传 rawcode，资源路径由导入文件提供。
