# 治疗系统

## 概述

治疗系统提供完整的治疗和魔法恢复功能，包括治疗量计算、特效播放、事件触发、持续恢复（HOT）和物品治疗效果。

## 文件结构

```
02．治疗系统/
├── 00．常量定义.ts         # 开关、事件名、默认配置
├── 01．核心功能.ts         # 核心治疗逻辑（doHeal）
├── 02．治疗事件_旧版.ts    # 马甲单位治疗事件检测
├── 03．持续治疗效果.ts     # HOT（持续恢复）系统
├── 04．物品治疗效果.ts     # 物品治疗效果（A002/A0LF/A015/A0B8/A08C）
├── 05．魔法恢复.ts         # 魔法恢复逻辑（doManaRegen）
├── index.ts               # 统一导出
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

### doManaRegen() - 执行魔法恢复

```typescript
const actualRegen = doManaRegen(target, amount, showEffect?);
```

### 便捷函数

```typescript
// 生命治疗
spellHeal(source, target, amount, showEffect?, effectPath?)  // 技能治疗
itemHeal(source, target, amount, showEffect?, effectPath?)   // 物品治疗
regenHeal(target, amount)                                    // 生命恢复（无特效）

// 魔法恢复
doManaRegen(target, amount, showEffect?)                     // 魔法恢复
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

### 核心系统事件

| 事件名 | 参数 | 说明 |
|--------|------|------|
| 任意单位被治疗 | 治疗量(real)、治疗目标(unit)、治疗来源(unit) | doHeal内部触发 |
| 数值显示 | Real(real)、Unit(unit)、red/green/blue(real) | 显示漂浮文字 |

### 马甲单位治疗事件

| 事件名 | 触发条件 |
|--------|----------|
| 治疗事件 | 马甲单位（古树类型）施放治疗技能（医疗波/治疗链/神圣之光/德鲁伊生命恢复） |

### 持续治疗效果（HOT）

**API**：
```typescript
// 启动持续治疗效果
startHot(target, source, tickHP, tickMP, duration);

// 停止持续治疗效果
stopHot(target);

// 检查单位是否正在受HOT效果影响
isHotActive(target);

// 获取当前HOT单位数量
getHotUnitCount();

// 触发"持续治疗效果"事件（供JASS端调用）
fireHotEvent(target, source, tickHP, tickMP, duration?);
```

**结束条件**（任一满足）：
- 单位没有特定Buff（BIrm、BIrg、BIrl、Brej）
- 持续恢复倒计时 <= 0
- 单位死亡

### 物品治疗效果

| 技能ID | 类型 | 说明 |
|--------|------|------|
| A002 | 单体HP | 瞬间回复生命值 |
| A0LF | 单体MP | 瞬间回复魔法值 |
| A015 | 单体HP+MP | 瞬间回复生命和魔法 |
| A0B8 | 群体HP+MP | 范围1000内友方瞬间回复 |
| A08C | 单体HOT | 缓慢回复（10秒，每秒10%） |

**API**：
```typescript
// 通过技能ID执行物品治疗效果
doHealItemEffect(abilId, target, healHP, healMP);

// 通过技能ID字符串执行
doHealItemEffectById("A002", target, 100, 0);

// 检查是否为物品治疗技能
isHealItemAbility(abilId);
```

### 魔法恢复事件

**API**：
```typescript
// 触发"恢复魔法事件"（供JASS端调用）
fireManaRegenEvent(target, amount, source);
```

## 事件触发函数

```typescript
// 触发"任意单位被治疗"事件
fireHealEvent(source, target, amount);

// 触发"数值显示"事件（显示治疗/伤害数值）
fireShowDamageEvent(target, amount, red?, green?, blue?);
```

## 使用示例

```typescript
import { doHeal, doManaRegen, startHot, doHealItemEffectById } from "系统.04．伤害系统.02．治疗系统.index";

// 技能治疗
doHeal({
  HealSource: caster,
  HealTarget: target,
  HealAmount: 100,
  ItemHeal: false,
  HealEffect: true,
});

// 魔法恢复
doManaRegen(target, 50, true);

// 持续恢复（10秒，每秒20HP/10MP）
startHot(target, caster, 20, 10, 10);

// 物品治疗效果
doHealItemEffectById("A0B8", target, 100, 50);  // 群体回复
```

## 后续接手者注意

1. 所有治疗/恢复都直接调用TS函数（doHeal/doManaRegen），不需要通过STES事件传参
2. STES事件用于JASS端监听器响应（如显示漂浮文字）
3. Lua端可以触发JASS端的STES事件，JASS端也可以触发Lua端监听的事件
