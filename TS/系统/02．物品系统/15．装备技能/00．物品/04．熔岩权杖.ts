/** @noSelfInFile */


const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;

const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const { 快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.03．快速Buff") as {
  快速控制Buff: (this: void, 来源单位: any, 目标单位: any, 控制ID: number, 持续时间: number) => void;
};
const { 延后一帧执行伤害派生效果 } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  延后一帧执行伤害派生效果: (this: void, callback: () => void) => void;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any,
) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

import { 熔岩权杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 熔岩权杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为熔岩权杖(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return UnitHasItemOfTypeBJ(物品, 熔岩权杖物品ID) === true;
}

function 发射熔岩弹幕(this: void, 施法者: any, 目标单位: any): void {
  if (施法者 == null || 施法者 === 0 || 目标单位 == null || 目标单位 === 0) return;
  创建原生弹幕({
    所有者: 施法者,
    X: GetUnitX(施法者),
    Y: GetUnitY(施法者),
    速度: 熔岩权杖配置.速度,
    轨迹类型: "追踪",
    指定目标: 目标单位,
    命中半径: 100,
    生命周: 8,
    碰撞消失: true,
    最大总命中次数: 1,
    每单位最大命中次数: 1,
    最大总距离: 5000,
    模型: 熔岩权杖配置.弹幕模型,
    on命中单位: function 处理熔岩弹幕命中(this: void, 命中单位: any): void {
      if (命中单位 == null || 命中单位 === 0) return;
      UnitDamageTarget(施法者, 命中单位, 熔岩权杖配置.伤害值, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS);
      快速控制Buff(施法者, 命中单位, 0, 熔岩权杖配置.控制时间);
    },
  });
}

export function 处理熔岩权杖施法(this: void, 施法单位: any, 目标单位: any): void {
  debugLogForce("04．熔岩权杖", "进入", "处理熔岩权杖施法");

  if (!是否为熔岩权杖(施法单位)) return;
  if (目标单位 == null || 目标单位 === 0) {
    debugLogForce("04．熔岩权杖", "无目标单位，跳过");
    return;
  }
  延后一帧执行伤害派生效果(() => {
    debugLogForce("04．熔岩权杖", "延后一帧发射熔岩弹幕");
    发射熔岩弹幕(施法单位, 目标单位);
  });
}

export {};
