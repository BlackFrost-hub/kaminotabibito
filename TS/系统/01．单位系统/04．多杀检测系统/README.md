# 多杀检测系统

## 概述

多杀检测系统用于检测短时间内连续击杀多个单位，支持批量击杀和效果触发。

## 文件结构

```
04．多杀检测系统/
├── 00．常量定义.ts      # 事件名、默认配置
├── 01．核心功能.ts      # 核心逻辑（监控、击杀检测）
├── 02．STES事件触发.ts  # 触发JASS端监听的STES事件
├── 03．事件处理.ts      # 处理JASS端触发的STES事件
├── index.ts            # 统一导出
└── README.md
```

## 系统开关

在 `00．常量定义.ts` 中设置：
```typescript
export const MULTI_KILL_SYSTEM_ENABLED = true;  // true启用，false禁用
```

## 核心API

### startMultiKillMonitor(config) - 启动监控

```typescript
interface MultiKillConfig {
  effectSource: any;           // 效果来源单位（施法者）
  target: any;                 // 目标单位（被监控者）
  killWindow?: number;         // 击杀窗口时间（秒，默认3秒）
  killThreshold?: number;      // 击杀阈值（默认3）
  killGroup?: any;             // 击杀组（单位组）
  diyEvent?: boolean;          // 是否触发自定义事件
  diyEventString?: string;     // 自定义事件名称
  finish?: boolean;            // 结束时是否显示来源单位
  effectID?: number;           // 效果ID（传递给效果事件）
  healAmount?: number;         // 治疗量（传递给效果事件）
  healTarget?: any;            // 治疗目标（传递给效果事件）
  healSource?: any;            // 治疗来源（传递给效果事件）
}

startMultiKillMonitor(config);
```

### 其他API

```typescript
// 停止监控
stopMultiKillMonitor(target);

// 添加单位到击杀组
addToKillGroup(target, unit);

// 从击杀组移除单位
removeFromKillGroup(target, unit);

// 检查是否正在被监控
isMultiKillMonitored(target);

// 获取当前监控数量
getMultiKillMonitorCount();
```

## 工作流程

1. **启动监控**：为目标单位注册伤害事件
2. **伤害检测**：当伤害 >= 当前生命时，累计击杀数
3. **窗口检测**：超过窗口时间则重置击杀数
4. **批量击杀**：击杀数 >= 阈值时，杀死击杀组中所有单位
5. **死亡处理**：目标死亡时，检查击杀组是否为空
6. **效果触发**：击杀组为空且自然死亡时，触发效果事件

## STES事件

### OnMultiKill（启动监控）

JASS端通过此事件启动多杀监控：

```jass
// 设置参数
call YDLocal1Set(unit, "effectSource", caster)
call YDLocal1Set(unit, "unit", target)
call YDLocal1Set(real, "killWindow", 3.0)
call YDLocal1Set(integer, "killThreshold", 3)
call YDLocal1Set(group, "killGroup", killGroup)
call YDLocal1Set(boolean, "DiyEvent", true)
call YDLocal1Set(string, "DiyEventString", "自定义事件名")
call YDLocal1Set(boolean, "Finish", true)
call YDLocal1Set(integer, "EffectID", 1)
call YDLocal1Set(real, "HealAmount", 100.0)
call YDLocal1Set(unit, "HealTarget", healTarget)
call YDLocal1Set(unit, "HealSource", healSource)

// 触发事件
call STES_Fire(null, "OnMultiKill")
```

### OnMultiKillEffectID（效果触发）

当击杀组清空且目标自然死亡时触发：

```jass
// JASS端监听器可读取参数
local integer effectID = YDLocal1Get(integer, "EffectID")
local real healAmount = YDLocal1Get(real, "HealAmount")
local unit healTarget = YDLocal1Get(unit, "HealTarget")
local unit healSource = YDLocal1Get(unit, "HealSource")
```

## 与原JASS代码的区别

| 原JASS | 优化后TS |
|--------|----------|
| 每个单位创建独立死亡触发器 | 复用单位死亡事件系统 |
| 逻辑嵌套深，难以维护 | 清晰的API和流程 |
| 参数不明确 | 明确的接口定义 |
| 触发器可能泄漏 | 自动清理资源 |

## 使用示例

```typescript
import { startMultiKillMonitor, addToKillGroup } from "系统.01．单位系统.04．多杀检测系统.01．核心功能";

// 创建击杀组
const killGroup = jass.CreateGroup();
jass.GroupAddUnit(killGroup, unit1);
jass.GroupAddUnit(killGroup, unit2);
jass.GroupAddUnit(killGroup, unit3);

// 启动监控
startMultiKillMonitor({
  effectSource: caster,
  target: mainTarget,
  killWindow: 3.0,
  killThreshold: 3,
  killGroup: killGroup,
  finish: true,
});
```

## 后续接手者注意

1. JASS端通过 STES "OnMultiKill" 事件启动监控
2. 参数名须与JASS端一致（effectSource, unit, killWindow等）
3. 击杀组由调用方创建，系统负责在适当时机销毁
