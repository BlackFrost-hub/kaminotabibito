# AI自动使用技能系统

## 概述

本系统用于让AI单位（主要是中立敌对单位）自动使用技能。系统会定时检测已注册的AI单位，根据技能优先级和条件自动施放技能。

## 文件结构

```
06．AI自动使用技能/
├── 00．常量定义.ts    # 系统常量（开关、优先级、目标类型等）
├── 01．核心功能.ts    # 核心实现（注册、检测、施放）
├── README.md          # 本说明文档
└── index.ts           # 统一导出入口
```

## 系统状态

**当前状态：未启用**

要启用系统，修改 `00．常量定义.ts` 中的：
```typescript
export const AI_SKILL_SYSTEM_ENABLED = true;  // 改为 true
```

## 工作流程

```
每 0.5 秒
    │
    ▼
遍历所有 AI 单位
    │
    ▼
按优先级排序技能
    │
    ▼
检查：冷却 ✓ 魔法 ✓ 等级 ✓
    │
    ▼
寻找合适目标
    │
    ▼
检查：距离 ✓ 条件 ✓
    │
    ▼
发布命令
```

## 快速开始

### 1. 启用系统

```typescript
// 修改 00．常量定义.ts
export const AI_SKILL_SYSTEM_ENABLED = true;
```

### 2. 注册AI单位

```typescript
import { registerAIUnit, unregisterAIUnit } from "系统.03．技能系统.06．AI自动使用技能";

// 手动注册单位为AI单位
registerAIUnit(unit);

// 取消注册
unregisterAIUnit(unit);
```

### 3. 注册技能

```typescript
import { registerAISkill, registerAISkills } from "系统.03．技能系统.06．AI自动使用技能";
import { TARGET_TYPE_UNIT, PRIORITY_DAMAGE } from "系统.03．技能系统.06．AI自动使用技能";

// 注册单个技能
registerAISkill(unit, {
  abilityId: 0x00000000,      // 技能ID（四字码）
  orderId: 0x00000000,        // 命令ID（通魔技能需要）
  targetType: TARGET_TYPE_UNIT, // 目标类型
  priority: PRIORITY_DAMAGE,    // 优先级
  castRange: 600,               // 施法距离
  minLevel: 1,                  // 最小等级
});

// 批量注册
registerAISkills(unit, [config1, config2, config3]);
```

## 自动注册机制

系统会自动注册以下单位：

1. **中立敌对的非英雄单位**：在单位创建时自动注册为AI单位
2. **单位死亡时自动清理**：无需手动取消注册

## 技能配置

### AISkillConfig 接口

```typescript
interface AISkillConfig {
  abilityId: number;           // 技能ID
  orderId: number;             // 命令ID（通魔技能需要）
  targetType: SkillTargetType; // 目标类型
  priority: number;            // 优先级（0-100）
  castRange: number;           // 施法距离
  manaCost?: number;           // 魔法消耗（可选）
  cooldown?: number;           // 冷却时间（可选）
  minLevel: number;            // 最小等级要求
  targetFilter?: TargetFilter; // 目标筛选函数
  pointCondition?: (caster) => { x, y } | null; // 点目标条件
}
```

### 目标类型

| 常量 | 值 | 说明 |
|------|-----|------|
| `TARGET_TYPE_NONE` | 0 | 无目标技能（立即施放） |
| `TARGET_TYPE_POINT` | 1 | 点目标技能 |
| `TARGET_TYPE_UNIT` | 2 | 单位目标技能 |

### 优先级常量

| 常量 | 值 | 说明 |
|------|-----|------|
| `PRIORITY_LOWEST` | 0 | 最低优先级 |
| `PRIORITY_LOW` | 25 | 低优先级 |
| `PRIORITY_NORMAL` | 50 | 普通优先级 |
| `PRIORITY_HIGH` | 75 | 高优先级 |
| `PRIORITY_HIGHEST` | 100 | 最高优先级 |
| `PRIORITY_CONTROL` | 100 | 控制技能 |
| `PRIORITY_DAMAGE` | 75 | 伤害技能 |
| `PRIORITY_SUPPORT` | 50 | 辅助技能 |
| `PRIORITY_HEAL` | 80 | 治疗技能 |

## API 参考

### 注册函数

| 函数 | 说明 |
|------|------|
| `registerAIUnit(unit)` | 注册单位为AI单位 |
| `unregisterAIUnit(unit)` | 取消AI单位注册 |
| `registerAISkill(unit, config)` | 为AI单位注册技能 |
| `registerAISkills(unit, configs)` | 批量注册技能 |
| `unregisterAISkill(unit, abilityId?)` | 取消技能注册 |

### 系统函数

| 函数 | 说明 |
|------|------|
| `initAISkillSystem()` | 初始化系统 |
| `isSystemEnabled()` | 检查系统是否启用 |
| `getAIUnitCount()` | 获取AI单位数量 |
| `getAISkillCount(unit)` | 获取单位注册的技能数量 |

## 待完善功能

以下功能需要后续开发者完善：

### 1. 通魔技能命令ID

在 `00．常量定义.ts` 中：
```typescript
export const ORDER_ID_CHANNEL_MAGIC = 0;  // 待确认
export const ABILITY_ID_CHANNEL_MAGIC = 0;  // 待确认
```

### 2. 目标搜索逻辑

在 `01．核心功能.ts` 的 `findBestTarget` 函数中：
- 实现单位目标技能的目标搜索
- 添加敌我判断
- 添加距离判断
- 添加目标筛选条件

### 3. 点目标技能逻辑

在技能配置中实现 `pointCondition` 函数：
- 寻找最佳施法点
- 考虑AOE范围
- 考虑敌人聚集度

### 4. 技能冷却读取

当前从技能读取冷却时间可能不准确，需要：
- 使用 `EXGetAbilityState` 获取实际冷却
- 或在配置中手动指定冷却时间

### 5. 性能优化

- 使用单位组缓存
- 优化目标搜索算法
- 添加距离检测优化

## 扩展建议

### 自定义目标筛选

```typescript
// 只攻击英雄
registerAISkill(unit, {
  abilityId: skillId,
  targetType: TARGET_TYPE_UNIT,
  targetFilter: (caster, target) => {
    return jass.IsUnitType(target, jass.UNIT_TYPE_HERO);
  },
  // ...
});

// 只攻击低血量敌人
registerAISkill(unit, {
  abilityId: skillId,
  targetType: TARGET_TYPE_UNIT,
  targetFilter: (caster, target) => {
    const hp = jass.GetUnitState(target, jass.UNIT_STATE_LIFE);
    const maxHp = jass.GetUnitState(target, jass.UNIT_STATE_MAX_LIFE);
    return hp / maxHp < 0.3;
  },
  // ...
});
```

### 点目标技能

```typescript
// 在敌人聚集处施放AOE
registerAISkill(unit, {
  abilityId: skillId,
  targetType: TARGET_TYPE_POINT,
  pointCondition: (caster) => {
    // 返回最佳施法点
    return { x: 100, y: 100 };
  },
  // ...
});
```

## 注意事项

1. **系统默认关闭**：需要手动启用 `AI_SKILL_SYSTEM_ENABLED = true`
2. **通魔技能**：需要配置正确的 `orderId`
3. **性能考虑**：大量AI单位时注意性能
4. **单位死亡自动清理**：无需手动取消注册
5. **使用绝对路径**：require时使用绝对路径
