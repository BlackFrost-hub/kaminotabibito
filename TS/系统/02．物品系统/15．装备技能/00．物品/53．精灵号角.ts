/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围友军, 取单位X, 取单位Y, 取单位攻击, 取句柄ID } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 调整状态ID属性 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/16．属性位移与指令";
import { registerManualBuff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const { 注册数值Buff范围光环 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.02．数值Buff范围光环") as {
  注册数值Buff范围光环: (this: void, params: {
    状态ID: string;
    物品类型ID: number;
    间隔毫秒: number;
    半径: number;
    目标类型: "友军含自己" | "友军不含自己" | "敌人";
    数值效果列表: any[];
    Buff?: any;
  }) => void;
};

const 攻击属性ID = 1;
const 护甲属性ID = 2;
const 精灵号角光环周期毫秒 = 500;
const 精灵号角Buff持续秒 = 1;

let 已初始化精灵号角光环 = false;

function 计算精灵号角光环攻击(this: void, target: any, 层数: number, 已加攻击: number): number {
  const baseAttack = 取单位攻击(target) - 已加攻击;
  if (!(baseAttack > 0) || 层数 <= 0) return 0;
  return baseAttack * 物品使用数值配置.号角.精灵号角光环攻击比例 * 层数;
}

function 计算精灵号角光环护甲(this: void, _target: any, 层数: number): number {
  return 物品使用数值配置.号角.精灵号角光环护甲 * 层数;
}

function 应用精灵号角攻击差值(this: void, target: any, delta: number): void {
  调整状态ID属性(target, 攻击属性ID, delta);
}

function 应用精灵号角护甲差值(this: void, target: any, delta: number): void {
  调整状态ID属性(target, 护甲属性ID, delta);
}

function 取精灵号角光环Buff附加(this: void, _target: any, 层数: number, holder: any): any {
  return {
    sourceUnit: holder,
    effectSourceName: "精灵号角",
    effectSourceType: "装备",
    effectValue2: 物品使用数值配置.号角.精灵号角光环护甲 * 层数,
  };
}

export function 初始化精灵号角光环(this: void): void {
  if (已初始化精灵号角光环) return;
  已初始化精灵号角光环 = true;
  if (物品使用装备ID.精灵号角 === 0) return;
  注册数值Buff范围光环({
    状态ID: "精灵号角光环",
    物品类型ID: 物品使用装备ID.精灵号角,
    间隔毫秒: 精灵号角光环周期毫秒,
    半径: 物品使用数值配置.号角.半径,
    目标类型: "友军含自己",
    数值效果列表: [
      { key: "攻击", 计算总值: 计算精灵号角光环攻击, 应用差值: 应用精灵号角攻击差值 },
      { key: "护甲", 计算总值: 计算精灵号角光环护甲, 应用差值: 应用精灵号角护甲差值 },
    ],
    Buff: {
      BuffID: 常规BuffID.精灵号角_号角光环,
      持续秒: 精灵号角Buff持续秒,
      取显示值: function 取精灵号角光环Buff显示值(this: void, _target: any, 层数: number): number {
        return 10 * 层数;
      },
      取附加参数: 取精灵号角光环Buff附加,
    },
  });
}

export function 处理精灵号角使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.精灵号角)) return;
  const cfg = 物品使用数值配置.号角;
  const unit = ctx.施法单位;
  const allies = 获取范围友军(unit, 取单位X(unit), 取单位Y(unit), cfg.半径);
  const count = allies.length;
  if (count <= 0) return;
  const selfExtraAttack = cfg.精灵号角每单位攻击 * count;
  for (let i = 0; i < allies.length; i++) {
    const target = allies[i];
    const activeAttack = 取单位攻击(target) * cfg.精灵号角主动攻击比例;
    const extraAttack = 取句柄ID(target) === 取句柄ID(unit) ? selfExtraAttack : 0;
    施加临时属性效果(target, cfg.持续毫秒, [{ 类型: "攻击", 数值: activeAttack + extraAttack }]);
    registerManualBuff(target, 常规BuffID.精灵号角_王之号角, cfg.持续毫秒 / 1000, 15, {
      sourceUnit: unit,
      effectSourceName: "精灵号角",
      effectSourceType: "装备",
      effectValue2: extraAttack,
    });
  }
}

初始化精灵号角光环();

export {};
