# 技能吟唱条系统

## 概述

技能吟唱条系统用于在屏幕上显示技能吟唱进度条，支持多种颜色主题，通过STES事件触发。

**技术特点：**
- 不依赖YDLocal存储数据
- 使用Map存储吟唱条数据
- 使用中心计时器统一更新
- 支持多个同时存在的吟唱条

## 文件结构

```
TS/系统/03．技能系统/07．技能吟唱条/
├── 00．常量定义.ts   # 系统开关、颜色配置、模型路径、UI位置等常量
├── 01．核心功能.ts   # 吟唱条创建、中心计时器更新、帧销毁等核心逻辑
└── index.ts          # 统一导出入口
```

## 调用方式

### 方式一：通过STES事件触发（兼容旧接口）

在JASS/GUI中通过STES事件「注册吟唱条」触发：

```jass
// 设置参数
call YDLocal1Set(integer, "颜色ID", 1)      // 1-7 对应不同颜色
call YDLocal1Set(real, "sj", 3.0)           // 吟唱总时间（秒）
call YDLocal1Set(string, "string", "技能名") // 可选：自定义提示文本

// 触发事件
call STES_Fire("注册吟唱条")
```

### 方式二：直接调用TS函数（推荐）

```typescript
import { showCastBar } from "系统.03．技能系统.07．技能吟唱条.01．核心功能";

// 显示吟唱条（颜色ID, 总时间秒, 自定义文本）
showCastBar(1, 3.0, "火球术吟唱中");
```

## 颜色配置

| 颜色ID | 颜色 | 前景模型 | 背景模型 |
|--------|------|----------|----------|
| 1 | 绿色 | UI_shengmingzhi_gb2.mdx | UI_shengmingzhi-beijing_gb2.mdx |
| 2 | 蓝色 | UI_shengmingzhi_t1.mdx | UI_shengmingzhi-beijing_t1.mdx |
| 3 | 橙色 | UI_shengmingzhi_o2.mdx | UI_shengmingzhi-beijing_o2.mdx |
| 4 | 红色 | UI_shengmingzhi_r2.mdx | UI_shengmingzhi-beijing_r2.mdx |
| 5 | 紫色 | UI_shengmingzhi_p2.mdx | UI_shengmingzhi-beijing_p2.mdx |
| 6 | 金色 | UI_shengmingzhi_g2.mdx | UI_shengmingzhi-beijing_g2.mdx |
| 7 | 棕色 | UI_shengmingzhi_b2.mdx | UI_shengmingzhi-beijing_b2.mdx |

## 系统开关

在 `00．常量定义.ts` 中设置：

```typescript
export const CAST_BAR_ENABLED = false;  // true启用，false禁用
```

## 技术要点

### 1. 数据存储（不依赖YDLocal）

- 使用 `Map<number, CastBarData>` 存储所有吟唱条数据
- 每个吟唱条有唯一的自增ID
- 数据直接存储在内存中，不依赖JASS哈希表

### 2. 中心计时器

- 不再为每个吟唱条创建独立计时器
- 使用 `onTick10ms` 注册到中心计时器
- 每2个tick（0.02秒）更新一次所有吟唱条
- 性能更好，避免创建大量计时器

### 3. 帧生命周期

- 吟唱条通过 `DzCreateFrameByTagName` 创建SPRITE和TEXT帧
- 中心计时器统一更新所有吟唱条进度
- 完成后自动销毁所有帧并从Map中移除

### 4. 动画控制

- 使用 `DzFrameSetAnimateOffset` 控制前景动画进度
- 初始偏移为1.0（未开始），逐渐减少到0.0（完成）

### 5. 与原JASS的差异

- 原JASS使用YDLocal存储数据到计时器句柄，本实现使用Map存储
- 原JASS每个吟唱条一个独立计时器，本实现使用中心计时器统一管理
- 原JASS使用 `StringBufferLoad()` 显示倒计时，本实现使用 `formatTime()` 函数格式化
- 原JASS有 `NumberToString` STES事件遍历，本实现简化为直接更新文本

## 依赖

- `jass.common` - JASS原生函数
- `jass.japi` - DzAPI扩展函数（DzCreateFrameByTagName等）
- `系统.00．核心系统.05．中心计时器` - 中心计时器（onTick10ms）
- `lib.扩展函数.YDWE函数.02．YDLocal兼容` - YDLocal传参系统（兼容旧接口）
