# 纯规划英雄 Buff 图标制作记录

## 记录范围

2026-08-15 扫描 `04．英雄技能` 目录后，确认以下目录只有迁移规划文档，没有英雄技能实现 `.ts`：

`01．cloud`、`11．佐佐木小次郎`、`12．八云紫`、`13．坂井悠二`、`14．铃仙`、`14．黑崎一护`、`15．鹿目圆`、`16．塞拉斯`、`17．Saber`。

本次只制作计划中明确需要玩家看到的持续 Buff/状态图标，不新增英雄 TS 实现，不新增 TS Buff 表，不改变技能入口。

## 资源规范

- 生成模型：`gpt-image-2`。
- 源图：`1024x1024` PNG，临时保存在 `tmp/imagegen/hero-buffs-1024/<英雄英文目录>/`。
- 最终资源：等比例缩放为 `64x64`，编码为项目现有格式 `BLP1`，保存在 `imports/BuffIcon/Hero/<英雄英文目录>/`。
- 每张图都包含完整 Warcraft III 原生银色 Buff 外框；不含文字、水印或现代 UI 面板。
- 最终 BLP 已检查：宽高 `64x64`、文件结构有效、mipmap 存在、源图与成品方向一致。
- 计划中的纯内部计数、短暂选择窗口和可选状态没有单独生成图标，避免图标与实际 TS Buff 生命周期不一致。

## 已生成清单

| 英雄 | 目录 | 数量 | 图标文件 |
| --- | --- | ---: | --- |
| 云端 | `Cloud` | 8 | `cloud_blaze_burn`、`cloud_frost_slow`、`cloud_shadow_stun`、`cloud_light_dark_state`、`cloud_insight`、`cloud_breach`、`cloud_guard`、`cloud_agility` |
| 佐佐木小次郎 | `Sasaki` | 2 | `sasaki_heartless_sight`、`sasaki_tsubame_guard` |
| 八云紫 | `YakumoYukari` | 1 | `yakumo_yukari_hidden_gap` |
| 坂井悠二 | `SakaiYuuji` | 8 | `sakai_q_control`、`sakai_silver_prison`、`sakai_grammatica_guard`、`sakai_divine_gate`、`sakai_misty_shock`、`sakai_snake_descent`、`sakai_snake_aura`、`sakai_ally_command` |
| 铃仙 | `Reisen` | 10 | `reisen_q_stealth`、`reisen_q_slow`、`reisen_q_anti_stealth`、`reisen_w_decoy`、`reisen_w_madness`、`reisen_e_air_dodge`、`reisen_e_stun`、`reisen_r_roll`、`reisen_r_stun`、`reisen_d_wave` |
| 黑崎一护 | `KurosakiIchigo` | 7 | `ichigo_bankai`、`ichigo_spirit_repulse`、`ichigo_flash_invulnerable`、`ichigo_flash_end_stun`、`ichigo_ground_channel`、`ichigo_damage_guard`、`ichigo_slow_field` |
| 鹿目圆 | `KanameMadoka` | 7 | `madoka_causal_power`、`madoka_arrow_charge`、`madoka_rainbow_rain`、`madoka_goddess_power`、`madoka_ring_power_one`、`madoka_ring_power_two`、`madoka_circle_truth` |
| 塞拉斯 | `Sylas` | 7 | `sylas_fire_attack`、`sylas_ice_attack`、`sylas_lightning_attack`、`sylas_burn`、`sylas_freeze`、`sylas_lightning_slow`、`sylas_grand_magic` |
| Saber | `Saber` | 5 | `saber_mana_release`、`saber_avalon`、`saber_wind_control`、`saber_wind_slow`、`saber_impact_stun` |

总计：**55 张**。

## 实现阶段接入规则

1. 后续新增英雄 Buff 表时，`icon` 必须引用上表对应的 `BuffIcon\\Hero\\<目录>\\<文件>.blp`，不能把图标路径只写进 ini。
2. 图标只表达状态，不能代替同步的伤害、控制、属性、位置、冷却、魔耗或状态机逻辑。
3. Buff 的开始、刷新、叠层、驱散、死亡、打断、重复施加和正常结束，必须与真实状态共用生命周期。
4. 佐佐木 Q 的 0.3 秒短减速、铃仙 W 选择窗口、云端 R 升空可选表现、鹿目圆的可选攻击附加状态没有单独生成资源；实现时如确认需要玩家可见，再复用现有语义图标或单独补图。
5. 本记录只表示资源已准备，不表示对应英雄已经实现或 Buff 已经注册。
