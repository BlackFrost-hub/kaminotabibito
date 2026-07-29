/** @noSelfInFile */
/**
 * TS 原生弹幕 - 命中处理
 */

import type { 原生弹幕内部实例 } from "../00．类型";
import {
  ATTACK_TYPE_NORMAL,
  DAMAGE_TYPE_NORMAL,
  WEAPON_TYPE_WHOKNOWS,
} from "../01．共享";
import { 触发原生弹幕STES事件 } from "../02．事件/index";

const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { isSameUnit, isUnitAlly, isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isSameUnit: (this: void, unitA: any, unitB: any) => boolean;
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const {
  创建命中规则状态,
  重置命中规则状态,
  单位是否还能命中,
  记录单位命中,
  命中规则是否应停止,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则") as {
  创建命中规则状态: (this: void, 参数?: any) => any;
  重置命中规则状态: (this: void, 状态: any) => void;
  单位是否还能命中: (this: void, 状态: any, 单位: any) => boolean;
  记录单位命中: (this: void, 状态: any, 单位: any) => boolean;
  命中规则是否应停止: (this: void, 状态: any) => boolean;
};

export function 创建弹幕命中规则状态(this: void, 实例: 原生弹幕内部实例): any {
  return 创建命中规则状态({
    每单位最大命中次数: 实例.参数.每单位最大命中次数,
    最大总命中次数: 实例.参数.最大总命中次数,
    首个命中后停止: 实例.参数.碰撞消失 === true,
  });
}

export function 重置弹幕命中规则状态(this: void, 实例: 原生弹幕内部实例): void {
  重置命中规则状态(实例.命中规则状态);
}

function 读取弹幕伤害形态(this: void, 实例: 原生弹幕内部实例): "单体" | "AOE" | "未知" {
  const 显式形态 = 实例.参数.伤害形态;
  if (显式形态 != null) return 显式形态;
  return "未知";
}

function 目标阵营允许(this: void, 实例: 原生弹幕内部实例, 目标单位: any): boolean {
  const 来源单位 = 实例.参数.所有者;
  if (目标单位 == null || 目标单位 === 0) return false;
  if (isSameUnit(目标单位, 实例.弹幕单位)) return false;
  if (实例.参数.允许命中所有者 !== true && isSameUnit(目标单位, 来源单位)) return false;

  const 影响目标 = 实例.参数.影响目标 ?? "敌方";
  if (影响目标 === "全部") return true;
  if (影响目标 === "友方") return isUnitAlly(目标单位, 来源单位);
  return isUnitEnemy(目标单位, 来源单位);
}

function 目标自定义允许(this: void, 实例: 原生弹幕内部实例, 目标单位: any): boolean {
  const 筛选 = 实例.参数.目标筛选;
  if (筛选 == null) return true;
  return 筛选(目标单位, 实例.id);
}

function 结算命中伤害(this: void, 实例: 原生弹幕内部实例, 目标单位: any): void {
  if (实例.当前伤害值 <= 0) return;
  造成技能伤害({
    来源: 实例.参数.所有者,
    目标: 目标单位,
    伤害: 实例.当前伤害值,
    伤害类型: 实例.参数.伤害类型 ?? DAMAGE_TYPE_NORMAL,
    ranged: false,
    attackType: 实例.参数.攻击类型 ?? ATTACK_TYPE_NORMAL,
    weaponType: 实例.参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS,
    来源类型: 实例.参数.来源类型 ?? "单位技能",
    技能ID: 实例.参数.技能ID,
    技能实例ID: 实例.参数.技能实例ID,
    标签: 实例.参数.技能标签,
    伤害形态: 读取弹幕伤害形态(实例),
    参与技能伤害加成: 实例.参数.参与技能伤害加成,
  });
}

function 处理单个目标命中(this: void, 实例: 原生弹幕内部实例, 目标单位: any): boolean {
  if (!目标阵营允许(实例, 目标单位)) return false;
  if (!目标自定义允许(实例, 目标单位)) return false;
  if (!单位是否还能命中(实例.命中规则状态, 目标单位)) return false;
  if (!记录单位命中(实例.命中规则状态, 目标单位)) return false;

  结算命中伤害(实例, 目标单位);

  const 回调 = 实例.参数.on命中;
  if (回调 != null) {
    回调(目标单位, 实例.id);
  }
  const 命中单位回调 = 实例.参数.on命中单位;
  if (命中单位回调 != null) {
    命中单位回调(目标单位, 实例.id);
  }
  触发原生弹幕STES事件(实例.参数.STES?.命中事件名, 实例, {
    目标单位,
    伤害值: 实例.当前伤害值,
  });
  return true;
}

export function 处理弹幕命中(this: void, 实例: 原生弹幕内部实例): boolean {
  const 半径 = 实例.参数.命中半径 ?? 0;
  if (半径 <= 0) return false;

  const 目标列表 = getUnitsInRange(实例.当前X, 实例.当前Y, 半径);
  let 已命中 = false;
  for (let i = 0; i < 目标列表.length; i++) {
    if (处理单个目标命中(实例, 目标列表[i])) {
      已命中 = true;
      if (实例.参数.碰撞消失 === true || 命中规则是否应停止(实例.命中规则状态)) {
        return true;
      }
    }
  }
  return 已命中 && 命中规则是否应停止(实例.命中规则状态);
}
