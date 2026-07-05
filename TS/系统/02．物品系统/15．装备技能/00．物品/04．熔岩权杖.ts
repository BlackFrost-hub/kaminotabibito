/** @noSelfInFile */
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
const { 造成装备伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行") as {
  造成装备伤害: (this: void, source: any, target: any, amount: number, damageType: any, ranged?: boolean, weaponType?: any, 选项?: any) => void;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;

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
      造成装备伤害(施法者, 命中单位, 熔岩权杖配置.伤害值, DAMAGE_TYPE_FIRE, false, undefined, { 伤害形态: "单体" });
      快速控制Buff(施法者, 命中单位, 0, 熔岩权杖配置.控制时间);
    },
  });
}

export function 处理熔岩权杖施法(this: void, 施法单位: any, 目标单位: any): void {
  if (!是否为熔岩权杖(施法单位)) return;
  if (目标单位 == null || 目标单位 === 0) {
    return;
  }
  延后一帧执行伤害派生效果(() => {
    发射熔岩弹幕(施法单位, 目标单位);
  });
}

export {};
