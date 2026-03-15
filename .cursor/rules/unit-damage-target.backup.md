# UnitDamageTarget 参数与伤害类型（项目参考）[备份]

用户提供的说明，供以后问到伤害、DOT、技能伤害时直接参考。

**注意**：第 4、5 参是「是否攻击伤害」「是否远程攻击」，**不是** burst/explosive。**是否是技能伤害由第 6 参决定**，ATTACK_TYPE_NORMAL = 技能伤害。

## 示例调用

```jass
UnitDamageTarget( gg_unit_Hamg_0002, gg_unit_hfoo_0019, 1.00, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
```

## 参数说明

| 参数位置 | 示例值 | 含义 |
|---------|--------|------|
| 1 | 单位 | 伤害来源 |
| 2 | 单位 | 伤害目标 |
| 3 | 实数 | 伤害量 |
| 4 | **false** | **是否攻击伤害**（true=攻击伤害，false=非攻击/法术伤害） |
| 5 | **false** | **是否远程攻击**（true=远程，false=近战） |
| 6 | ATTACK_TYPE_NORMAL | **攻击类型**：ATTACK_TYPE_NORMAL = 技能伤害；本地图常用此 |
| 7 | 见下表 | **伤害类型**（属性：普通/火/冰/光/精神等，决定显示与抗性） |
| 8 | WEAPON_TYPE_WHOKNOWS | 武器类型 |

## 伤害类型（第 7 参）可用值

| 常量 | 说明 |
|------|------|
| DAMAGE_TYPE_NORMAL | 普通伤害 |
| DAMAGE_TYPE_ENHANCED | 强化伤害 |
| DAMAGE_TYPE_FIRE | 火焰伤害 |
| DAMAGE_TYPE_COLD | 冰霜伤害 |
| DAMAGE_TYPE_LIGHTNING | 闪电伤害 |
| DAMAGE_TYPE_POISON | 毒素伤害 |
| DAMAGE_TYPE_DISEASE | 疾病伤害 |
| DAMAGE_TYPE_DIVINE | 神圣伤害 |
| DAMAGE_TYPE_MAGIC | 魔法伤害 |
| DAMAGE_TYPE_SONIC | 音波伤害 |
| DAMAGE_TYPE_ACID | 酸液伤害 |
| DAMAGE_TYPE_FORCE | 力量伤害 |
| DAMAGE_TYPE_DEATH | 死亡伤害 |
| DAMAGE_TYPE_MIND | 精神伤害 |
| DAMAGE_TYPE_PLANT | 植物伤害 |
| DAMAGE_TYPE_DEFENSIVE | 防御伤害 |
| DAMAGE_TYPE_DEMOLITION | 攻城伤害 |
| DAMAGE_TYPE_SLOW_POISON | 慢性毒素 |
| DAMAGE_TYPE_SPIRIT_LINK | 灵魂链接 |
| DAMAGE_TYPE_SHADOW_STRIKE | 暗影突袭 |
| DAMAGE_TYPE_UNIVERSAL | 通用伤害 |

## 常见组合（TS 里调用前先 setNextDamageTypeOverride）

- 技能攻击伤害 + 光属性：`setNextDamageTypeOverride(64 + 2048 + 8192)`，UnitDamageTarget 第4参=true、第5参=false/true（近战/远程），第7参=DAMAGE_TYPE_DIVINE。
- 仅技能伤害（如 DOT 精神）：`setNextDamageTypeOverride(2048 + 256)`，第4参=false、第5参=false。
