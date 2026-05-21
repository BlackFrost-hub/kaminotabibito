/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 是玩家英雄组单位 } = require("系统.04．伤害系统.00．伤害计算.01A．玩家英雄判定") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 命中概率通过 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  命中概率通过: (this: void, 原始概率: number, 攻击者: any) => boolean;
};
const { CreateFloatTextOnUnit } = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: any) => any;
};
const { 命中系统配置 } = require("系统.04．伤害系统.04．命中系统.00．命中配置") as {
  命中系统配置: {
    生效最低伤害: number;
    默认命中概率: number;
    未命中文本: string;
    漂浮文字: any;
  };
};

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;

function 调用玩家英雄判定(this: void, unit: any): boolean {
  return 是玩家英雄组单位(unit) === true;
}

export interface 命中判定结果 {
  结束链路: boolean;
  伤害: number;
  命中概率: number;
}

function 限制概率(this: void, value: number): number {
  if (value <= 0) return 0;
  if (value >= 1) return 1;
  return value;
}

function 读取单位实数(this: void, unit: any, 属性名: string): number {
  if (unit == null || unit === 0) return 0;
  return Number(YDUserDataGetSafe("unit", unit, 属性名, "real")) || 0;
}

function 读取玩家实数(this: void, player: any, 属性名: string): number {
  if (player == null || player === 0) return 0;
  return Number(YDUserDataGetSafe("player", player, 属性名, "real")) || 0;
}

export function 读取单位命中率偏移(this: void, unit: any): number {
  return 读取单位实数(unit, "命中率");
}

export function 读取玩家命中率偏移(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return 读取玩家实数(GetOwningPlayer(unit), "命中率");
}

/** 正向命中只用于抵消目标闪避，或被装备特例转化为额外暴击率。 */
export function 读取正向命中率偏移(this: void, unit: any): number {
  const 单位命中 = 读取单位命中率偏移(unit);
  const 玩家命中 = 读取玩家命中率偏移(unit);
  let 正向命中 = 0;
  if (单位命中 > 正向命中) 正向命中 = 单位命中;
  if (玩家命中 > 正向命中) 正向命中 = 玩家命中;
  return 正向命中;
}

/**
 * 负向命中才会让攻击落空。
 * 语义：-0.10 表示 90% 命中，-0.50 表示 50% 命中；正向命中不在这里判定。
 */
function 读取负向命中率偏移(this: void, unit: any): number {
  const 单位命中 = 读取单位命中率偏移(unit);
  const 玩家命中 = 读取玩家命中率偏移(unit);

  if (!调用玩家英雄判定(unit) && 单位命中 < 0) return 单位命中;
  if (玩家命中 < 0) return 玩家命中;
  return 0;
}

function 显示未命中(this: void, target: any): void {
  CreateFloatTextOnUnit(target, 命中系统配置.未命中文本, 命中系统配置.漂浮文字);
}

export function 执行命中判定(this: void, attacker: any, target: any, currentDamage: number): 命中判定结果 {
  if (attacker == null || attacker === 0 || target == null || target === 0) {
    return { 结束链路: false, 伤害: currentDamage, 命中概率: 命中系统配置.默认命中概率 };
  }
  if (currentDamage < 命中系统配置.生效最低伤害) {
    return { 结束链路: false, 伤害: currentDamage, 命中概率: 命中系统配置.默认命中概率 };
  }

  // 只有负向命中率需要掷点；幸运值修正统一封装在 命中概率通过 内。
  const 命中率偏移 = 读取负向命中率偏移(attacker);
  if (命中率偏移 >= 0) {
    return { 结束链路: false, 伤害: currentDamage, 命中概率: 命中系统配置.默认命中概率 };
  }

  const 基础命中概率 = 限制概率(命中系统配置.默认命中概率 + 命中率偏移);
  if (命中概率通过(基础命中概率, attacker)) {
    return { 结束链路: false, 伤害: currentDamage, 命中概率: 基础命中概率 };
  }

  显示未命中(target);
  return { 结束链路: true, 伤害: 0, 命中概率: 基础命中概率 };
}

export {};
