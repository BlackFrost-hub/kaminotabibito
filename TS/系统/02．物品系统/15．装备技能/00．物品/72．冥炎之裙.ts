/** @noSelfInFile */

const jass = require("jass.common") as any;

const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { 监听指定物品获取丢弃, 获取单位当前持有指定物品数量 } = require("系统.02．物品系统.15．装备技能.06．获取丢弃.index") as {
  监听指定物品获取丢弃: (
    this: void,
    itemTypeId: number,
    获取回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
    丢弃回调?: (this: void, unit: any, item: any, currentCount: number, previousCount: number) => void,
  ) => void;
  获取单位当前持有指定物品数量: (this: void, unit: any, itemTypeId: number) => number;
};
const { 获取单位玩家英雄配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位玩家英雄配置: (this: void, unit: any) => Record<string, any> | null;
};
const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 创建Dz绑定单位特效, 是否已有Dz绑定单位特效, 销毁Dz绑定单位特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建Dz绑定单位特效: (this: void, unit: any, attachPoint: string, modelPath: string, effectKey?: string) => any;
  是否已有Dz绑定单位特效: (this: void, unit: any, effectKey?: string) => boolean;
  销毁Dz绑定单位特效: (this: void, unit: any, effectKey?: string) => void;
};
const stringToFourCCSafe = (require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
}).stringToFourCCSafe;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, unitState: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (
  this: void,
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any,
) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 冥炎之裙配置 = {
  物品名: "冥炎之裙",
  女性全属性加成: 15,
  周期毫秒: 1000,
  作用范围: 300,
  每层每秒火焰伤害: 200,
  特效路径: "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl",
  特效挂点: "origin",
  特效键: "装备:冥炎之裙",
} as const;

const 冥炎之裙物品ID = stringToFourCCSafe(resolveItemIdByName(冥炎之裙配置.物品名));

const 冥炎之裙持有者列表: any[] = [];
const 冥炎之裙持有者表: Record<number, any | undefined> = {};

let 已初始化冥炎之裙 = false;

function 获取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 单位是英雄(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 单位是女性英雄(this: void, unit: any): boolean {
  if (!单位是英雄(unit)) return false;
  const config = 获取单位玩家英雄配置(unit);
  return config != null && config.gender === "female";
}

function 加入冥炎之裙持有者(this: void, unit: any): void {
  const unitId = 获取单位ID(unit);
  if (unitId === 0 || 冥炎之裙持有者表[unitId] != null) return;
  冥炎之裙持有者表[unitId] = unit;
  冥炎之裙持有者列表.push(unit);
}

function 移除冥炎之裙持有者(this: void, unit: any): void {
  const unitId = 获取单位ID(unit);
  if (unitId === 0) return;
  delete 冥炎之裙持有者表[unitId];
  for (let i = 冥炎之裙持有者列表.length - 1; i >= 0; i--) {
    if (获取单位ID(冥炎之裙持有者列表[i]) === unitId) {
      冥炎之裙持有者列表.splice(i, 1);
    }
  }
  销毁Dz绑定单位特效(unit, 冥炎之裙配置.特效键);
}

function 同步冥炎之裙持有表现(this: void, unit: any, currentCount: number): void {
  if (!单位是英雄(unit) || currentCount <= 0) {
    移除冥炎之裙持有者(unit);
    return;
  }
  加入冥炎之裙持有者(unit);
  if (!是否已有Dz绑定单位特效(unit, 冥炎之裙配置.特效键)) {
    创建Dz绑定单位特效(unit, 冥炎之裙配置.特效挂点, 冥炎之裙配置.特效路径, 冥炎之裙配置.特效键);
  }
}

function 调整冥炎之裙女性全属性(this: void, unit: any, deltaCount: number): void {
  if (!单位是女性英雄(unit) || deltaCount === 0) return;
  SGSS_SetState(unit, 6, 冥炎之裙配置.女性全属性加成 * deltaCount);
}

function on获得冥炎之裙(this: void, unit: any, _item: any, currentCount: number, previousCount: number): void {
  if (!单位是英雄(unit)) return;
  if (previousCount <= 0 && currentCount > 0) {
    调整冥炎之裙女性全属性(unit, 1);
  }
  同步冥炎之裙持有表现(unit, currentCount > 0 ? 1 : 0);
}

function on失去冥炎之裙(this: void, unit: any, _item: any, currentCount: number, previousCount: number): void {
  if (!单位是英雄(unit)) return;
  if (currentCount <= 0 && previousCount > 0) {
    调整冥炎之裙女性全属性(unit, -1);
  }
  同步冥炎之裙持有表现(unit, currentCount > 0 ? 1 : 0);
}

function on冥炎之裙周期(this: void): void {
  for (let i = 冥炎之裙持有者列表.length - 1; i >= 0; i--) {
    const unit = 冥炎之裙持有者列表[i];
    if (!单位是英雄(unit)) {
      移除冥炎之裙持有者(unit);
      continue;
    }

    const count = 获取单位当前持有指定物品数量(unit, 冥炎之裙物品ID);
    if (count <= 0) {
      移除冥炎之裙持有者(unit);
      continue;
    }

    if (!是否已有Dz绑定单位特效(unit, 冥炎之裙配置.特效键)) {
      创建Dz绑定单位特效(unit, 冥炎之裙配置.特效挂点, 冥炎之裙配置.特效路径, 冥炎之裙配置.特效键);
    }

    if (!单位存活(unit)) continue;

    const damage = 冥炎之裙配置.每层每秒火焰伤害;
    const targets = getUnitsInRange(GetUnitX(unit), GetUnitY(unit), 冥炎之裙配置.作用范围);
    for (let j = 0; j < targets.length; j++) {
      const target = targets[j];
      if (target == null || target === 0 || target === unit) continue;
      if (!单位存活(target)) continue;
      UnitDamageTarget(unit, target, damage, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS);
    }
  }
}

export function 初始化冥炎之裙持有效果(this: void): void {
  if (已初始化冥炎之裙) return;
  已初始化冥炎之裙 = true;
  if (冥炎之裙物品ID === 0) return;

  监听指定物品获取丢弃(冥炎之裙物品ID, on获得冥炎之裙, on失去冥炎之裙);
  addPeriodicCallback(冥炎之裙配置.周期毫秒, on冥炎之裙周期);
}

初始化冥炎之裙持有效果();

export {};
