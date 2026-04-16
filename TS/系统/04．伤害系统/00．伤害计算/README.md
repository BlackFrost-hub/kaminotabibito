# 伤害计算系统文档

> 本文档用于指导后续AI理解和维护伤害计算系统

---

## 一、文件结构

```
TS/系统/04．伤害系统/04．伤害计算/
├── 01．属性读取.ts      (213行) - 单位/玩家属性读取、上限应用
├── 02．伤害修正.ts      (363行) - 护甲穿透、魔抗、属性伤害/抗性
├── 03．吸血吸魔.ts      (419行) - 吸血、吸魔、漂浮文字、马甲处理
├── 04．主计算流程.ts    (371行) - 完整伤害计算流程
├── 05．事件注册.ts      (97行)  - 伤害事件回调注册
└── index.ts             (25行)  - 统一导出
```

---

## 二、模块职责

### 01．属性读取.ts

**职责**：从单位/玩家读取属性值，应用玩家上限

**核心函数**：
```typescript
// 通用属性读取
getRealAttr(unit, "魔抗", 0)           // 读取实数属性
getBoolAttr(unit, "免疫伤害", false)   // 读取布尔属性

// 带上限的属性读取（仅对玩家生效）
getRealAttrWithLimit(unit, "魔抗", isPlayer)

// 快捷函数
isPlayerUnit(unit)                     // 判断是否玩家英雄
isImmuneDamage(unit)                   // 是否免疫伤害
isImmuneNormalAttack(unit)             // 是否免疫普攻
isIgnoreArmor(attacker)                // 是否无视护甲
```

**重要**：YDUserData属性名必须使用中文，不能用英文key！

---

### 02．伤害修正.ts

**职责**：护甲穿透、魔抗、属性伤害/抗性计算

**核心函数**：
```typescript
// 护甲穿透
applyArmorPenetration(damage, target, attacker)

// 魔抗计算
applyMagicResist(damage, target, attacker)

// 伤害类型修正
getPhysicalDamageModifier(attacker, target, isPlayer)
getSkillDamageModifier(attacker, target, isPlayer)
getNormalAttackModifier(attacker, target, isPlayer)

// 专精加成
getAntMasteryBonus(attacker, target)   // 蝼蚁专精
getBossMasteryBonus(attacker, target)  // Boss专精

// 召唤物修正
getSummonDamageModifier(attacker, target, isPlayer)
```

---

### 03．吸血吸魔.ts

**职责**：吸血、吸魔、漂浮文字显示、马甲单位处理

**核心函数**：
```typescript
// 吸血计算
calcLifeStealHeal(attacker, damage, isMagic, isNormalAttack)

// 吸魔计算
calcManaSteal(attacker, damage)

// 统一执行（推荐使用）
applyLifeAndManaSteal(attacker, damage, isMagic, isNormalAttack, showText)

// 马甲单位处理
isAncientUnit(unit)                    // 是否马甲单位
getStealBeneficiary(source)            // 获取吸血受益单位（马甲->玩家英雄）
```

**马甲单位处理**：
- 马甲单位（UNIT_TYPE_ANCIENT）造成的伤害
- 吸血/吸魔给所属玩家的英雄
- 英雄组存储位置：`YDUserDataGet("string", "玩家英雄", "单位组", "group")`

**漂浮文字**：
- 吸血：绿色 "+数值"
- 吸魔：蓝色 "+数值"

---

### 04．主计算流程.ts

**职责**：整合所有模块，执行完整的伤害计算流程

**核心函数**：
```typescript
// 计算最终伤害
calculateDamage(target, attacker, baseDamage): DamageResult

// 伤害事件处理（在回调中调用）
onDamageEvent(target, attacker, baseDamage)
```

**计算流程（17步）**：
1. 固定伤害减少/增加
2. 免疫判定
3. 护甲穿透（物理伤害）
4. 魔抗计算（魔法伤害）
5. 百分比伤害减少
6. 百分比伤害提高
7. 物理伤害修正
8. 魔法伤害修正
9. 强化伤害修正
10. 技能伤害修正
11-12. 普攻伤害修正
13. 属性伤害修正（7种）
14. 召唤物伤害修正
15. 专精加成
16. 最终伤害加成
17. 结算伤害

**真实伤害**：`DAMAGE_TYPE_MIND` 跳过所有计算

---

### 05．事件注册.ts

**职责**：注册伤害事件回调，启动伤害计算系统

**核心函数**：
```typescript
// 初始化（自动调用）
initDamageCalculation(60)

// 控制函数
enableDamageCalculation()
disableDamageCalculation()
```

**自动初始化**：模块加载时自动注册，无需手动调用

---

## 三、依赖关系

```
05．事件注册.ts
    └── 04．主计算流程.ts
            ├── 01．属性读取.ts
            ├── 02．伤害修正.ts
            │       └── 01．属性读取.ts
            └── 03．吸血吸魔.ts
                    └── 01．属性读取.ts
```

**外部依赖**：
- `lib.扩展函数.封装函数.06．伤害函数.index` - 伤害类型判断、伤害修改
- `lib.扩展函数.封装函数.03．漂浮文字.index` - 漂浮文字显示
- `lib.扩展函数.YDWE函数.index` - YDUserData属性读写
- `系统.04．伤害系统.01．伤害事件` - 伤害事件注册
- `系统.04．伤害系统.00．伤害常量` - 属性上限常量

---

## 四、属性名对照表

> **重要**：YDUserData使用中文属性名，不是英文key

| 中文属性名 | 说明 | 上限（玩家） |
|-----------|------|-------------|
| 魔抗 | 魔法抗性 | 50% |
| 物理抗性 | 物理抗性 | 30% |
| 伤害吸血 | 伤害吸血 | 5%（可突破） |
| 魔法伤害吸血 | 魔法吸血 | 15% |
| 普攻伤害吸血 | 普攻吸血 | 25% |
| 伤害吸魔 | 伤害吸魔 | 5%（可突破） |
| 伤害减少 | 固定减伤 | 无 |
| 伤害减少% | 百分比减伤 | 无 |
| 护甲穿透 | 护甲穿透 | 无 |
| 魔法穿透 | 魔法穿透 | 无 |
| 金属性伤害/抗性 | 金属性 | 无 |
| 木属性伤害/抗性 | 木属性 | 无 |
| 水属性伤害/抗性 | 水属性 | 无 |
| 火属性伤害/抗性 | 火属性 | 无 |
| 雷属性伤害/抗性 | 雷属性 | 无 |
| 光属性伤害/抗性 | 光属性 | 无 |
| 暗属性伤害/抗性 | 暗属性 | 无 |

**布尔属性**：
- 免疫伤害、免疫普攻、减伤关闭
- 无视护甲、无视魔抗
- 伤害吸血上限、伤害吸魔突破

---

## 五、伤害类型判断

```typescript
// 基础类型
isPhysicalDamage()    // 物理伤害
isMagicDamage()       // 魔法伤害
isEnhancedDamage()    // 强化伤害
isTrueDamage()        // 真实伤害

// 攻击类型
isNormalAttack()      // 普通攻击
isSkillAttack()       // 技能攻击
isSkillDamage()       // 技能伤害

// 属性伤害
isMetalDamage()       // 金属性（毒/酸/缓毒/疾病）
isWoodDamage()        // 木属性（植物）
isWaterDamage()       // 水属性（寒冷）
isFireDamage()        // 火属性（火焰）
isThunderDamage()     // 雷属性（闪电）
isLightDamage()       // 光属性（神圣）
isDarkDamage()        // 暗属性（暗影突袭）
```

---

## 六、注意事项

1. **属性名必须中文**：`YDUserDataGet("unit", unit, "魔抗", "real")` ✅

2. **伤害修改必须同帧**：`YDWESetEventDamage()` 必须在伤害事件回调中同步调用

3. **马甲单位吸血**：马甲单位造成的伤害，吸血给玩家英雄

4. **玩家上限**：部分属性有上限，仅对玩家生效，敌对单位不受限制

5. **DOT伤害跳过**：`fromDotTickBatch === true` 的伤害不参与计算

---

## 七、扩展指南

### 添加新属性

1. 在 `00．伤害常量.ts` 添加上限配置
2. 在 `01．属性读取.ts` 添加快捷函数（可选）
3. 在 `04．主计算流程.ts` 添加计算逻辑

### 添加新伤害类型

1. 在 `lib.扩展函数.封装函数.06．伤害函数.03．伤害类型判断.ts` 添加判断函数
2. 在 `04．主计算流程.ts` 的 `applyElementalDamage()` 添加处理

---

*文档版本: 1.0*
*更新日期: 2026/04/13*
