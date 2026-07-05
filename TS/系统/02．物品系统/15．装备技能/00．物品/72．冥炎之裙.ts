/** @noSelfInFile */

const jass = require("jass.common") as any;

const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { 获取单位玩家英雄配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具") as {
  获取单位玩家英雄配置: (this: void, unit: any) => Record<string, any> | null;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { 造成装备伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行") as {
  造成装备伤害: (this: void, source: any, target: any, amount: number, damageType: any, ranged?: boolean, weaponType?: any, 选项?: any) => void;
};
const { 注册持有战斗周期模板 } = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.04．持有战斗周期模板") as {
  注册持有战斗周期模板: (this: void, 参数: {
    名称: string;
    物品类型ID: number;
    周期秒: number;
    主体类型?: "玩家英雄" | "Boss" | "普通单位";
    on获取?: (this: void, event: { 单位: any; 物品: any; 持有数量: number; 前次数量: number }) => void;
    on丢弃?: (this: void, event: { 单位: any; 物品: any; 持有数量: number; 前次数量: number }) => void;
    on周期: (this: void, event: { 单位: any; 持有数量: number }) => void;
  }) => any;
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

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, unitState: any) => number;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;

const 冥炎之裙配置 = {
  物品名: "冥炎之裙",
  女性全属性加成: 15,
  周期秒: 1,
  作用范围: 300,
  每层每秒火焰伤害: 200,
  特效路径: "Abilities\\Spells\\NightElf\\Immolation\\ImmolationTarget.mdl",
  特效挂点: "origin",
  特效键: "装备:冥炎之裙",
} as const;

const 冥炎之裙物品ID = stringToFourCCSafe(resolveItemIdByName(冥炎之裙配置.物品名));

let 已初始化冥炎之裙 = false;

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

function 移除冥炎之裙持有者(this: void, unit: any): void {
  销毁Dz绑定单位特效(unit, 冥炎之裙配置.特效键);
}

function 同步冥炎之裙持有表现(this: void, unit: any, currentCount: number): void {
  if (!单位是英雄(unit) || currentCount <= 0) {
    移除冥炎之裙持有者(unit);
    return;
  }
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

function on冥炎之裙战斗周期(this: void, event: { 单位: any }): void {
  const unit = event.单位;
  if (!单位是英雄(unit)) {
    移除冥炎之裙持有者(unit);
    return;
  }

  if (!是否已有Dz绑定单位特效(unit, 冥炎之裙配置.特效键)) {
    创建Dz绑定单位特效(unit, 冥炎之裙配置.特效挂点, 冥炎之裙配置.特效路径, 冥炎之裙配置.特效键);
  }

  if (!单位存活(unit)) return;

  const damage = 冥炎之裙配置.每层每秒火焰伤害;
  const targets = getUnitsInRange(GetUnitX(unit), GetUnitY(unit), 冥炎之裙配置.作用范围);
  for (let j = 0; j < targets.length; j++) {
    const target = targets[j];
    if (target == null || target === 0 || target === unit) continue;
    if (!单位存活(target)) continue;
    造成装备伤害(unit, target, damage, DAMAGE_TYPE_FIRE, true, undefined, { 伤害形态: "AOE" });
  }
}

export function 初始化冥炎之裙持有效果(this: void): void {
  if (已初始化冥炎之裙) return;
  已初始化冥炎之裙 = true;
  if (冥炎之裙物品ID === 0) return;

  注册持有战斗周期模板({
    名称: "冥炎之裙",
    物品类型ID: 冥炎之裙物品ID,
    周期秒: 冥炎之裙配置.周期秒,
    主体类型: "玩家英雄",
    on获取: function on冥炎之裙模板获取(this: void, event): void {
      on获得冥炎之裙(event.单位, event.物品, event.持有数量, event.前次数量);
    },
    on丢弃: function on冥炎之裙模板丢弃(this: void, event): void {
      on失去冥炎之裙(event.单位, event.物品, event.持有数量, event.前次数量);
    },
    on周期: on冥炎之裙战斗周期,
  });
}

初始化冥炎之裙持有效果();

export {};
