/** @noSelfInFile */


const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require("jass.common") as any;

const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, 来源单位: any, 目标单位: any, 类型: string, 参数?: any) => number;
};

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
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

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 熔岩权杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 熔岩权杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

function 是否为熔岩权杖(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 熔岩权杖物品ID;
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
      施加扩展控制(施法者, 命中单位, "stun", { 持续时间: 熔岩权杖配置.控制时间 });
    },
  });
}

export function 处理熔岩权杖使用(this: void, 上下文: 物品技能事件上下文): void {
  debugLogForce("04．熔岩权杖", "进入", "处理熔岩权杖使用");

  if (!是否为熔岩权杖(上下文.物品)) return;
  发射熔岩弹幕(上下文.施法单位, 上下文.目标单位);
}

export {};
