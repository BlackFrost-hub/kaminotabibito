/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerPlayerHeroListener, getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, player: any, hero: any) => void) => void;
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, unit: any, attributeName: string, delta: number) => void;
};
const { 自定义指定单位的小地图图标, 开启_关闭自定义指定单位的小地图图标 } = require("平台扩展API动作") as {
  自定义指定单位的小地图图标: (this: void, unit: any, path: string) => void;
  开启_关闭自定义指定单位的小地图图标: (this: void, unit: any, enabled: boolean) => void;
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
    被动: {
      伤害吸血上限: number;
      伤害吸血: number;
      开启小地图特殊标志: boolean;
      小地图图标路径: string;
    };
    额外D: {
      技能类型ID: number;
    };
  };
};

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const Player = jass.Player as (this: void, playerId: number) => any;
const UnitSetUsesAltIcon = jass.UnitSetUsesAltIcon as (this: void, enabled: boolean, unit: any) => void;
const 已应用蕾米莉亚被动英雄: Record<number, any | undefined> = {};

function 是蕾米莉亚(this: void, hero: any): boolean {
  return hero != null && hero !== 0 && GetUnitTypeId(hero) === 蕾米莉亚单位技能配置.单位类型ID;
}

function 清理蕾米莉亚选择被动(this: void, hero: any): void {
  if (hero == null || hero === 0) return;
  const 被动 = 蕾米莉亚单位技能配置.被动;
  调整玩家属性(hero, "伤害吸血上限", -被动.伤害吸血上限);
  调整玩家属性(hero, "伤害吸血", -被动.伤害吸血);
  UnitSetUsesAltIcon(false, hero);
  开启_关闭自定义指定单位的小地图图标(hero, false);
}

function 更新蕾米莉亚选择被动(this: void, player: any, hero: any): void {
  if (player == null || player === 0) return;
  const playerId = GetPlayerId(player);
  const previousHero = 已应用蕾米莉亚被动英雄[playerId];
  if (previousHero === hero) return;
  if (previousHero != null && previousHero !== 0) 清理蕾米莉亚选择被动(previousHero);
  delete 已应用蕾米莉亚被动英雄[playerId];
  if (!是蕾米莉亚(hero)) return;

  const 被动 = 蕾米莉亚单位技能配置.被动;
  调整玩家属性(hero, "伤害吸血上限", 被动.伤害吸血上限);
  调整玩家属性(hero, "伤害吸血", 被动.伤害吸血);
  if (被动.开启小地图特殊标志) UnitSetUsesAltIcon(true, hero);
  if (被动.小地图图标路径 !== "") {
    自定义指定单位的小地图图标(hero, 被动.小地图图标路径);
    开启_关闭自定义指定单位的小地图图标(hero, true);
  }
  已应用蕾米莉亚被动英雄[playerId] = hero;
}

function 初始化已有蕾米莉亚选择被动(this: void): void {
  for (let i = 0; i < 16; i++) {
    const player = Player(i);
    更新蕾米莉亚选择被动(player, getRegisteredPlayerHero(player));
  }
}

function 刷新蕾米莉亚恶魔突袭本次冷却(this: void, killerUnit: any): void {
  if (killerUnit == null || killerUnit === 0) return;
  if (GetUnitTypeId(killerUnit) !== 蕾米莉亚单位技能配置.单位类型ID) return;

  const owner = GetOwningPlayer(killerUnit);
  if (owner == null || owner === 0) return;
  if (getRegisteredPlayerHero(owner) !== killerUnit) return;

  YDWESetUnitAbilityStateSafe(killerUnit, 蕾米莉亚单位技能配置.额外D.技能类型ID, 1, 0.0);
}

function 处理蕾米莉亚击杀被动(this: void, dyingUnit: any, killingUnit: any): void {
  if (!单位满足击杀前置条件(dyingUnit)) return;
  刷新蕾米莉亚恶魔突袭本次冷却(killingUnit);
}

export function 注册蕾米莉亚击杀被动(this: void): void {
  registerPlayerHeroListener(更新蕾米莉亚选择被动);
  registerDeathListener(处理蕾米莉亚击杀被动);
  初始化已有蕾米莉亚选择被动();
}

注册蕾米莉亚击杀被动();
