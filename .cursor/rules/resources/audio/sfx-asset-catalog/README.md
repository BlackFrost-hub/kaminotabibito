# Boss SFX 资产分类目录

> 本目录只记录 `imports/Sound` 中已有、且项目 Markdown 明确写过听感或声音构成的正式 SFX。Voice 台词、训练音频、`audio_temp` 候选和没有声音描述的正式文件不收录。

## 分类入口

| 声响分类 | 文件 | 数量 | 主要语义 |
| --- | --- | ---: | --- |
| 环绕持续 | [`aura.md`](aura.md) | 1 | 环绕单位或地面的持续层。 |
| 蓄力与冲锋 | [`charge-rush.md`](charge-rush.md) | 3 | 蓄力、冲锋、路径拖尾和推进感。 |
| 爪痕与斩痕 | [`claw-slash.md`](claw-slash.md) | 2 | 爪痕、斩痕、抓击和刀刃质感。 |
| 点名与诅咒 | [`mark-curse.md`](mark-curse.md) | 2 | 点名、诅咒、拘束和封锁感。 |
| 瞬时爆发 | [`instant-burst.md`](instant-burst.md) | 7 | 瞬时爆发、破碎、炸裂和重击。 |
| 镜像与残影 | [`illusion-echo.md`](illusion-echo.md) | 3 | 镜像、残影、投影和回响。 |
| 直线与贯穿 | [`line-pierce.md`](line-pierce.md) | 2 | 直线波、切面、丝带、贯穿和回流。 |
| 法阵与符文 | [`magic-ritual.md`](magic-ritual.md) | 0 | 法阵、符文、仪式和规则感脉冲。 |
| 标记与锚点 | [`marker-anchor.md`](marker-anchor.md) | 0 | 核心、节点、血印和锚点。 |
| 升降与回填 | [`rise-return.md`](rise-return.md) | 3 | 升起、坠落、回填和空中主体感。 |
| 旋转与环绕 | [`rotate-circulate.md`](rotate-circulate.md) | 0 | 旋转刃、回旋、漩涡和环形运动。 |
| 护盾与屏障 | [`shield-barrier.md`](shield-barrier.md) | 1 | 护盾、屏障、格挡和破盾。 |
| 扩散与放射 | [`spread-radiate.md`](spread-radiate.md) | 1 | 扩散、散射、放射和范围展开。 |
| 未指定分类 | [`unassigned.md`](unassigned.md) | 15 | 已有声音描述，但无法可靠对应以上声响形态。 |

## 文件组织规则

1. 每条正式音效只进入一个主分类文件，不因不同技能或角色复制条目。
2. 分类名称按声音形态语义命名，参考 `.cursor/rules/resources/visual/effect-asset-catalog/form/README.md` 的形态划分，但不复制特效目录名。
3. 表格只写正式资源、大概声音和来源，不写技能用途、播放节点或接入代码。
4. 新音效必须先迁入 `imports/Sound`，并在需求文档补齐声音描述后才能进入分类文件。

## 收录概况

- 已收录：40 条。
- 未收录：139 个正式文件。详见 [`unrecorded.md`](unrecorded.md)。
- 精确重复组：0 组（SHA-256）。
- 本目录不根据文件名或主观试听补写声音说明。
