/** @noSelfInFile */

const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 扩散伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.08．扩散伤害.扩散伤害") as {
  扩散伤害: (this: void, 参数: {
    来源单位: any;
    主目标: any;
    伤害值: number;
    扩散半径: number;
    扩散百分比: number;
    是否包含主目标?: boolean;
    攻击类型?: any;
    伤害类型?: any;
    武器类型?: any;
  }) => void;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { 获取同类伤害类型 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.08．同类伤害类型") as {
  获取同类伤害类型: (this: void, snapshot: any) => { 攻击类型: any; 伤害类型: any; 武器类型: any };
};

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

import { 巨魔大剑物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 巨魔大剑配置 } from "../03．主动技能/02．施法触发/00．施法触发配置";
import { 创建施法后首伤窗口 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制";

function 单位持有巨魔大剑(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (巨魔大剑物品ID <= 0) {
    return false;
  }
  const result = UnitHasItemOfTypeBJ(单位, 巨魔大剑物品ID) === true;
  return result;
}

function 巨魔大剑条件成立(this: void, 施法单位: any, 目标单位: any): boolean {
  if (!IsUnitType(施法单位, UNIT_TYPE_HERO)) {
    return false;
  }
  if (!单位持有巨魔大剑(施法单位)) {
    return false;
  }
  const result = 目标单位 != null && 目标单位 !== 0;
  return result;
}

function 巨魔大剑首伤过滤(this: void, event: any): boolean {
  const snapshot = event.伤害快照;
  if (snapshot != null && snapshot.isTrueDamage === true) return false;
  return 单位持有巨魔大剑(event.攻击者);
}

function 处理巨魔大剑首伤(this: void, event: any): void {
  const target = event.目标;
  const attacker = event.攻击者;
  const applied = event.本次伤害;
  const snapshot = event.伤害快照;
  const x = GetUnitX(target);
  const y = GetUnitY(target);
  createTimedEffect(巨魔大剑配置.扩散特效路径, x, y, 0, 巨魔大剑配置.扩散特效持续时间);

  const 类型 = 获取同类伤害类型(snapshot);
  扩散伤害({
    来源单位: attacker,
    主目标: target,
    伤害值: applied,
    扩散半径: 巨魔大剑配置.扩散半径,
    扩散百分比: 巨魔大剑配置.扩散百分比,
    是否包含主目标: false,
    攻击类型: 类型.攻击类型,
    伤害类型: 类型.伤害类型,
    武器类型: 类型.武器类型,
  });
}

const 巨魔大剑首伤窗口 = 创建施法后首伤窗口({
  名称: "巨魔大剑",
  持续秒: 巨魔大剑配置.持续时间,
  过滤伤害: 巨魔大剑首伤过滤,
  on首伤: 处理巨魔大剑首伤,
});

export function 处理巨魔大剑施法(this: void, 施法单位: any, 技能ID: number, 目标单位: any): void {
  if (!巨魔大剑条件成立(施法单位, 目标单位)) return;
  巨魔大剑首伤窗口.打开(施法单位);
}

export {};
