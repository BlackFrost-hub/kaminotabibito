/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { registerCritAppliedFinalDamageListener } = require("系统.04．伤害系统.06．暴击系统.01．暴击核心") as {
  registerCritAppliedFinalDamageListener: (this: void, callback: (this: void, record: any, applied: number, snapshot: any) => void) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (
  whichUnit: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any
) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const 地狱火卡牌幸运物品ID = stringToFourCCSafe(resolveItemIdByName("|cffff6800地狱火卡牌|r|cffff0000（幸运）|r"));

function 恢复自身最大生命百分比(this: void, source: any): void {
  const 最大生命 = GetUnitStateJapi(source, UNIT_STATE_MAX_LIFE);
  if (最大生命 <= 0) return;
  doHeal({
    HealSource: source,
    HealTarget: source,
    HealAmount: 最大生命 * 0.02,
    ItemHeal: true,
    HealEffect: false,
  });
}

function 造成额外物理伤害(this: void, source: any, target: any): void {
  UnitDamageTarget(source, target, 100, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

function 地狱火卡牌幸运暴击监听(this: void, record: any, _applied: number, _snapshot: any): void {
  if (地狱火卡牌幸运物品ID === 0) return;
  if (record.isNormalAttack !== true) return;
  if (!UnitHasItemOfTypeBJ(record.暴击归属单位, 地狱火卡牌幸运物品ID)) return;
  恢复自身最大生命百分比(record.暴击归属单位);
  造成额外物理伤害(record.attacker, record.target);
}

export function init地狱火卡牌幸运暴击(this: void): void {
  registerCritAppliedFinalDamageListener(地狱火卡牌幸运暴击监听);
}

init地狱火卡牌幸运暴击();

export {};
