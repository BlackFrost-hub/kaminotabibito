/** @noSelfInFile */

const { 施加恐惧 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加恐惧: (this: void, source: any, target: any, params: any) => number;
};
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

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围敌人, 取单位X, 取单位Y, 取单位攻击, 单位是英雄 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 调整状态ID属性 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/16．属性位移与指令";
import { registerManualBuff, getBuffRuntime } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const 攻击属性ID = 1;
const 恶魔铃铛光环周期毫秒 = 500;
const 恶魔铃铛光环Buff持续秒 = 1;

let 已初始化恶魔铃铛光环 = false;

function 计算恶魔铃铛光环攻击降低(this: void, target: any, 层数: number, 已应用值: number): number {
  const baseAttack = 取单位攻击(target) - 已应用值;
  if (!(baseAttack > 0) || 层数 <= 0) return 0;
  return -baseAttack * 物品使用数值配置.恶魔铃铛.光环攻击降低比例 * 层数;
}

function 应用恶魔铃铛攻击差值(this: void, target: any, delta: number): void {
  调整状态ID属性(target, 攻击属性ID, delta);
}

function 刷新恶魔铃铛攻击降低Buff(this: void, target: any, 攻击降低: number, 持续秒: number, 来源单位: any, 装备来源名称: string): void {
  if (!(攻击降低 > 0) || 持续秒 <= 0) return;
  const old = getBuffRuntime(target, 常规BuffID.攻击力降低);
  if (old != null && old.effectSourceName !== 装备来源名称 && old.effect > 攻击降低) return;
  registerManualBuff(target, 常规BuffID.攻击力降低, 持续秒, 攻击降低, {
    sourceUnit: 来源单位,
    effectSourceName: 装备来源名称,
    effectSourceType: "装备",
  });
}

function 同步恶魔铃铛光环Buff(
  this: void,
  target: any,
  _层数: number,
  holder: any,
  已应用值表: Record<string, number | undefined>,
): void {
  const attackReduction = -(已应用值表.攻击降低 ?? 0);
  刷新恶魔铃铛攻击降低Buff(target, attackReduction, 恶魔铃铛光环Buff持续秒, holder, "恶魔铃铛");
}

export function 初始化恶魔铃铛光环(this: void): void {
  if (已初始化恶魔铃铛光环) return;
  已初始化恶魔铃铛光环 = true;
  if (物品使用装备ID.恶魔铃铛 === 0) return;
  注册数值Buff范围光环({
    状态ID: "恶魔铃铛光环",
    物品类型ID: 物品使用装备ID.恶魔铃铛,
    间隔毫秒: 恶魔铃铛光环周期毫秒,
    半径: 物品使用数值配置.恶魔铃铛.光环半径,
    目标类型: "敌人",
    数值效果列表: [
      { key: "攻击降低", 计算总值: 计算恶魔铃铛光环攻击降低, 应用差值: 应用恶魔铃铛攻击差值 },
    ],
    Buff: {
      BuffID: 常规BuffID.攻击力降低,
      持续秒: 恶魔铃铛光环Buff持续秒,
      自定义同步: 同步恶魔铃铛光环Buff,
      归零移除: false,
    },
  });
}

export function 处理恶魔铃铛使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.恶魔铃铛)) return;
  const cfg = 物品使用数值配置.恶魔铃铛;
  const unit = ctx.施法单位;
  const enemies = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), cfg.半径);
  for (const enemy of enemies) {
    const fearTime = 单位是英雄(enemy) ? cfg.恐惧英雄 : cfg.恐惧普通;
    施加恐惧(unit, enemy, { 持续时间: fearTime, 模式: "逃离施法者", 效果来源名称: "恶魔铃铛", 效果来源类型: "装备" });
    const attack = 取单位攻击(enemy) * cfg.攻击降低比例;
    施加临时属性效果(enemy, cfg.持续毫秒, [{ 类型: "攻击", 数值: -attack }]);
    刷新恶魔铃铛攻击降低Buff(enemy, attack, cfg.持续毫秒 / 1000, unit, "恶魔铃铛");
  }
}

初始化恶魔铃铛光环();

export {};
