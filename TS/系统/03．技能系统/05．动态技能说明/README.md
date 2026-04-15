# 动态技能说明系统

## 概述

本系统用于动态更新技能说明文字，支持根据单位属性自动计算并刷新技能描述。

## 文件结构

```
05．动态技能说明/
├── 00．常量定义.ts    # 系统常量（事件ID、属性名、运算符等）
├── 01．核心功能.ts    # 核心实现（注册、刷新、公式解析）
├── README.md          # 本说明文档
└── index.ts           # 统一导出入口
```

## 快速开始

### 1. 注册技能说明

```typescript
import { registerSkillTip, registerSkillUbertip, registerSkillTips } from "系统.03．技能系统.05．动态技能说明";

// 方式1：只注册技能名称（TIP）
registerSkillTip(unit, abilityId, "火球术[技能等级]级");

// 方式2：只注册详细说明（UBERTIP）
registerSkillUbertip(unit, abilityId, "造成[力量*3]点伤害，持续[智力*0.5]秒");

// 方式3：同时注册两者
registerSkillTips(
  unit,
  abilityId,
  "火球术[技能等级]级",                    // TIP
  "造成[攻击力*1.5+50]点魔法伤害",         // UBERTIP
  1  // 技能等级（可选，默认1）
);
```

### 2. 手动刷新

```typescript
import { refreshUnitSkillTips, refreshAllSkillTips } from "系统.03．技能系统.05．动态技能说明";

// 刷新单个单位的所有技能说明
refreshUnitSkillTips(unit);

// 刷新所有单位的所有技能说明
refreshAllSkillTips();
```

### 3. 取消注册

```typescript
import { unregisterDynamicSkillTip } from "系统.03．技能系统.05．动态技能说明";

// 取消指定技能的注册
unregisterDynamicSkillTip(unit, abilityId);

// 取消该单位所有技能的注册
unregisterDynamicSkillTip(unit);
```

## 公式语法

### 括号格式

支持两种括号格式：
- 英文括号：`[公式]`
- 中文括号：`（公式）`

### 运算符

| 运算符 | 说明 |
|--------|------|
| `+` | 加法 |
| `-` | 减法 |
| `*` 或 `×` | 乘法 |
| `/` 或 `÷` | 除法 |
| `()` | 括号（改变优先级） |

### 支持的属性变量

| 变量名 | 说明 |
|--------|------|
| `力量` | 力量（含绿字） |
| `敏捷` | 敏捷（含绿字） |
| `智力` | 智力（含绿字） |
| `力量白` | 力量白字（不含绿字） |
| `敏捷白` | 敏捷白字（不含绿字） |
| `智力白` | 智力白字（不含绿字） |
| `生命` | 当前生命值 |
| `最大生命` | 最大生命值 |
| `魔法` | 当前魔法值 |
| `最大魔法` | 最大魔法值 |
| `攻击力` | 攻击力（基础+绿字） |
| `护甲` | 护甲值 |
| `移动速度` | 移动速度 |
| `等级` / `英雄等级` | 英雄等级 |
| `经验` | 经验值 |
| `技能等级` | 技能等级（注册时传入） |

### 公式示例

```
[力量*3]                    → 力量 × 3
[攻击力*1.5+50]             → 攻击力 × 1.5 + 50
[智力*2+敏捷*1]             → 智力 × 2 + 敏捷 × 1
[(力量+敏捷)*0.5]           → (力量 + 敏捷) × 0.5
[攻击力×3+10×技能等级]       → 攻击力 × 3 + 10 × 技能等级
```

## 自动事件处理

系统初始化时会自动注册以下事件：

1. **单位升级事件**：自动刷新该单位所有技能说明
2. **单位死亡事件**：自动取消该单位所有技能注册

## 扩展自定义属性

```typescript
import { registerAttributeGetter, unregisterAttributeGetter } from "系统.03．技能系统.05．动态技能说明";

// 注册自定义属性
registerAttributeGetter("暴击率", (unit) => {
  // 返回单位的暴击率
  return getUnitCritRate(unit);
});

// 之后可以在公式中使用
registerSkillUbertip(unit, abilityId, "暴击率：[暴击率*100]%");

// 移除自定义属性
unregisterAttributeGetter("暴击率");
```

## 注意事项

1. **不要使用正则表达式**：tstl不支持正则表达式，本系统使用字符串遍历实现公式解析
2. **使用绝对路径**：require时使用绝对路径如 `require("系统.03．技能系统.05．动态技能说明")`
3. **技能等级变量**：`技能等级` 变量需要在注册时传入，用于公式计算
4. **单位死亡自动清理**：单位死亡时会自动取消注册，无需手动处理

## API 参考

### 注册函数

| 函数 | 说明 |
|------|------|
| `registerSkillTip(unit, abilityId, template, level?)` | 注册技能名称 |
| `registerSkillUbertip(unit, abilityId, template, level?)` | 注册详细说明 |
| `registerSkillTips(unit, abilityId, tipTemplate, ubertipTemplate, level?)` | 同时注册两者 |
| `registerDynamicSkillTip(unit, abilityId, template, level?, tipType?)` | 底层注册函数 |

### 刷新函数

| 函数 | 说明 |
|------|------|
| `refreshUnitSkillTips(unit)` | 刷新单位所有技能说明 |
| `refreshAllSkillTips()` | 刷新所有单位所有技能说明 |

### 注销函数

| 函数 | 说明 |
|------|------|
| `unregisterDynamicSkillTip(unit, abilityId?)` | 取消注册 |

### 扩展函数

| 函数 | 说明 |
|------|------|
| `registerAttributeGetter(name, getter)` | 注册自定义属性 |
| `unregisterAttributeGetter(name)` | 移除自定义属性 |
| `getSupportedAttributes()` | 获取所有支持的属性名 |

### 调试函数

| 函数 | 说明 |
|------|------|
| `getRegisteredSkillCount(unit)` | 获取单位注册技能数量 |
| `getTotalRegisteredCount()` | 获取总注册数量 |
