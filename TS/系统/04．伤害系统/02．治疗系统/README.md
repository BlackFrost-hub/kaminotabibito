# 治疗系统

## 概述

治疗系统提供完整的治疗功能，包括治疗量计算、特效播放、事件触发和回调系统。

## 文件结构

```
00．治疗系统/
├── 00．常量定义.ts    # 开关、事件名、默认配置
├── 01．核心功能.ts    # 核心治疗逻辑
├── index.ts          # 统一导出
└── README.md
```

## 系统开关

在 `00．常量定义.ts` 中设置：
```typescript
export const HEAL_SYSTEM_ENABLED = true;  // true启用，false禁用
```

## 核心API

### doHeal(params) - 执行治疗

```typescript
interface HealParams {
  HealSource: any;        // 治疗来源（可为null）
  HealTarget: any;        // 治疗目标
  HealAmount: number;     // 基础治疗量
  ItemHeal: boolean;      // 是否物品治疗
  HealEffect: boolean;    // 是否播放特效
  HealEffectPath?: string; // 特效路径（可选）
}

const actualHeal = doHeal(params);  // 返回实际治疗量
```

### 便捷函数

```typescript
spellHeal(source, target, amount, showEffect?, effectPath?)  // 技能治疗
itemHeal(source, target, amount, showEffect?, effectPath?)   // 物品治疗
regenHeal(target, amount)                                    // 生命恢复（无特效）
```

## 治疗量计算

```
治疗量 = 基础量 × (1 + 来源治疗率 + 目标受到治疗率)
```

限制：不超过已损失生命值，不会溢出。

## 回调系统

```typescript
// 可修改治疗量（治疗暴击、护盾转换等）
registerHealCallback((source, target, amount, isItemHeal) => {
  return amount * 2;  // 双倍治疗
});

// 只读监听（任务统计、成就等）
registerHealEvent((source, target, amount, isItemHeal) => {
  console.log(`治疗了 ${amount}`);
});
```

## 治疗率存储

```typescript
setHealRate(unit, 0.2);           // +20% 治疗率
setReceivedHealRate(unit, 0.1);   // +10% 受到治疗率
getHealRate(unit);                // 获取治疗率
getReceivedHealRate(unit);        // 获取受到治疗率
```

## STES事件

| 事件名 | 参数 |
|--------|------|
| 任意单位被治疗 | 治疗量(real)、治疗目标(unit)、治疗来源(unit) |
| 数值显示 | 伤害值(real)、目标单位(unit)、RGB(integer) |

## 使用示例

```typescript
import { spellHeal, itemHeal, regenHeal } from "系统.04．伤害系统.00．治疗系统.index";

// 技能治疗
spellHeal(caster, target, 100, true);

// 物品治疗
itemHeal(owner, target, 50, true);

// 生命恢复
regenHeal(target, 10);

// 自定义特效
spellHeal(caster, target, 100, true, "Abilities\\Spells\\Other\\Heal\\Heal.mdl");
```
