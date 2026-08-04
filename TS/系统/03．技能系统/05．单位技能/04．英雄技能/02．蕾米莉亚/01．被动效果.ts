/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
};
const { 单位满足击杀前置条件 } = require("系统.03．技能系统.05．单位技能.00．公共.06．死亡前置判断") as {
  单位满足击杀前置条件: (this: void, dyingUnit: any) => boolean;
};
const { 蕾米莉亚单位技能配置 } = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.00．配置") as {
  蕾米莉亚单位技能配置: {
    单位类型ID: number;
    D: {
      技能类型ID: number;
    };
  };
};

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;

function 刷新蕾米莉亚恶魔突袭本次冷却(this: void, killerUnit: any): void {
  if (killerUnit == null || killerUnit === 0) return;
  if (GetUnitTypeId(killerUnit) !== 蕾米莉亚单位技能配置.单位类型ID) return;

  const owner = GetOwningPlayer(killerUnit);
  if (owner == null || owner === 0) return;
  if (getRegisteredPlayerHero(owner) !== killerUnit) return;

  YDWESetUnitAbilityStateSafe(killerUnit, 蕾米莉亚单位技能配置.D.技能类型ID, 1, 0.0);
}

function 处理蕾米莉亚击杀被动(this: void, dyingUnit: any, killingUnit: any): void {
  if (!单位满足击杀前置条件(dyingUnit)) return;
  刷新蕾米莉亚恶魔突袭本次冷却(killingUnit);
}

export function 注册蕾米莉亚击杀被动(this: void): void {
  registerDeathListener(处理蕾米莉亚击杀被动);
}

注册蕾米莉亚击杀被动();
