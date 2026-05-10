/** @noSelfInFile */
/**
 * 扩散伤害
 *
 * 对主目标造成全额伤害，对范围内其他敌方单位造成百分比伤害。
 * 常用于溅射、分裂、连锁等技能效果。
 *
 * 使用示例：
 *   扩散伤害({ 来源单位, 主目标, 伤害值: 500, 扩散半径: 300, 扩散百分比: 0.5 });
 *   // 主目标受到500伤害，300范围内所有其他敌人受到250伤害
 */

const jass = require("jass.common") as any;

const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any, target: any, amount: number,
  attack: boolean, ranged: boolean,
  attackType: any, damageType: any, weaponType: any
) => boolean;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

export interface 扩散伤害参数 {
  来源单位: any;
  主目标: any;
  伤害值: number;
  扩散半径: number;
  扩散百分比: number;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
}

export function 扩散伤害(参数: 扩散伤害参数): void {
  const {
    来源单位,
    主目标,
    伤害值,
    扩散半径,
    扩散百分比,
    攻击类型 = ATTACK_TYPE_NORMAL,
    伤害类型 = DAMAGE_TYPE_NORMAL,
    武器类型 = null,
  } = 参数;

  if (!来源单位 || !主目标 || 伤害值 <= 0) return;

  debugLogForce("扩散伤害", "开始 主目标hid=", GetHandleId(主目标), "伤害=", 伤害值);

  const 主目标初始血量 = GetUnitState(主目标, UNIT_STATE_LIFE);
  UnitDamageTarget(来源单位, 主目标, 伤害值, false, false, 攻击类型, 伤害类型, 武器类型);
  const 主目标剩余血量 = GetUnitState(主目标, UNIT_STATE_LIFE);
  debugLogForce("扩散伤害", "主目标 初始血量=", 主目标初始血量, "剩余血量=", 主目标剩余血量);

  if (扩散半径 <= 0 || 扩散百分比 <= 0) {
    debugLogForce("扩散伤害", "跳过扩散 半径=", 扩散半径, "百分比=", 扩散百分比);
    return;
  }

  const x = GetUnitX(主目标);
  const y = GetUnitY(主目标);
  debugLogForce("扩散伤害", "主目标坐标 x=", x, "y=", y, "扩散半径=", 扩散半径);

  const 副目标列表 = getUnitsInRange(x, y, 扩散半径);
  debugLogForce("扩散伤害", "getUnitsInRange返回", 副目标列表.length, "个单位");

  const 扩散伤害值 = 伤害值 * 扩散百分比;
  debugLogForce("扩散伤害", "扩散伤害值=", 扩散伤害值);

  for (const 副目标 of 副目标列表) {
    const 副目标hid = GetHandleId(副目标);
    if (副目标 === 主目标) {
      debugLogForce("扩散伤害", "跳过主目标 hid=", 副目标hid);
      continue;
    }
    const 是敌人 = isUnitEnemy(副目标, 来源单位);
    debugLogForce("扩散伤害", "副目标 hid=", 副目标hid, "是敌人=", 是敌人);
    if (!是敌人) continue;
    const 副目标初始血量 = GetUnitState(副目标, UNIT_STATE_LIFE);
    UnitDamageTarget(来源单位, 副目标, 扩散伤害值, false, false, 攻击类型, 伤害类型, 武器类型);
    const 副目标剩余血量 = GetUnitState(副目标, UNIT_STATE_LIFE);
    debugLogForce("扩散伤害", "副目标 hid=", 副目标hid, "初始血量=", 副目标初始血量, "剩余血量=", 副目标剩余血量);
  }

  debugLogForce("扩散伤害", "结束");
}

export {};
