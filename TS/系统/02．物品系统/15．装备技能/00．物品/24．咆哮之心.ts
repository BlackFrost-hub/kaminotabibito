/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 造成装备伤害 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/10．装备战斗执行";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const R2I = jass.R2I as (value: number) => number;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 咆哮之心物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 咆哮之心配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 施加临时属性效果, type 临时属性效果实例 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 启动计数周期执行 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/10．周期执行模板";

interface 咆哮之心上下文 {
  施法单位: any;
  目标单位: any;
  属性效果: 临时属性效果实例;
}

function 是否为咆哮之心(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 咆哮之心物品ID;
}

function on咆哮之心周期(this: void, 上下文: 咆哮之心上下文, 当前次数: number): boolean | void {
  if (当前次数 > 咆哮之心配置.次数) {
    上下文.属性效果.清除();
    return false;
  }
  createTimedEffect(咆哮之心配置.特效路径, GetUnitX(上下文.目标单位), GetUnitY(上下文.目标单位), 0, 咆哮之心配置.特效持续时间);
  造成装备伤害(上下文.施法单位, 上下文.目标单位, 咆哮之心配置.每跳伤害, DAMAGE_TYPE_MIND, false, undefined, { 伤害形态: "单体" });
}

export function 处理咆哮之心使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("25．咆哮之心", "进入", "处理咆哮之心使用");

  if (!是否为咆哮之心(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  const 目标单位 = 上下文.目标单位;
  if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0) return;

  const 持续毫秒 = 咆哮之心配置.次数 * 咆哮之心配置.周期 * 1000;
  const 附加攻击 = R2I(GetUnitStateJapi(目标单位, ConvertUnitState(0x15)) / 咆哮之心配置.力量转攻击除数);
  registerManualBuff(目标单位, "C028", 持续毫秒 / 1000, 附加攻击, {
    sourceUnit: 施法单位,
    effectSourceName: "咆哮之心",
    effectSourceType: "装备",
  });
  const 属性效果 = 施加临时属性效果(目标单位, 持续毫秒, [{ 类型: "攻击", 数值: 附加攻击 }]);
  const 周期上下文: 咆哮之心上下文 = { 施法单位, 目标单位, 属性效果 };
  启动计数周期执行({
    间隔毫秒: 咆哮之心配置.周期 * 1000,
    最大次数: 咆哮之心配置.次数,
    on周期: function on咆哮之心周期执行(this: void, event): boolean | void {
      return on咆哮之心周期(周期上下文, event.当前次数);
    },
  });
}

export {};
