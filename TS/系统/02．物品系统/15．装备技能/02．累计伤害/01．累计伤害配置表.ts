/** @noSelfInFile */

import type { 回沙之书配置, 女妖头饰配置, 女妖头饰强化配置 } from "./00．类型定义";

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

export const 回沙之书累计配置: 回沙之书配置 = {
  物品名: "回沙之书",
  累计阈值: 400,
  法力恢复倍率: 0.12,
  特效路径: "war3mapImported\\SandAura.mdl",
  特效持续时间: 2.5,
  冷却时间: 8.0,
};

debugLogForce("累计伤害配置", "回沙之书配置已加载", "物品名:", 回沙之书累计配置.物品名);

export const 女妖头饰累计配置: 女妖头饰配置 = {
  物品名: "女妖头饰",
  累计阈值: 1500,
  追踪速度: 1500,
  追踪模型: "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl",
  追踪单位类型: "e02B",
  命中半径: 80,
  生命周期: 4,
  每秒毒伤: 500,
  毒伤持续时间: 2,
  减速攻速: 30,
  减速移速: 30,
  毒影BuffID: "C025",
};

debugLogForce("累计伤害配置", "女妖头饰配置已加载", "物品名:", 女妖头饰累计配置.物品名);

export const 女妖头饰强化累计配置: 女妖头饰强化配置 = {
  物品名: "女妖头饰-强化",
  命中次数阈值: 5,
  触发单位类型: "e02C",
};

debugLogForce("累计伤害配置", "女妖头饰强化配置已加载", "物品名:", 女妖头饰强化累计配置.物品名);

export const 累计伤害物品名表 = {
  回沙之书: 回沙之书累计配置.物品名,
  女妖头饰: 女妖头饰累计配置.物品名,
  女妖头饰强化: 女妖头饰强化累计配置.物品名,
} as const;

export {};
