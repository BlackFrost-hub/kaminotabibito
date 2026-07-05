/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { 创建句柄上下文托管器 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/24．句柄上下文托管";
const { 造成装备伤害 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行") as {
  造成装备伤害: (this: void, source: any, target: any, amount: number, damageType: any, ranged?: boolean, weaponType?: any, 选项?: any) => void;
};

const jass = require("jass.common") as any;

const { createTimedEffect, 创建Dz绑定单位特效, 销毁Dz绑定单位特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
  创建Dz绑定单位特效: (this: void, unit: any, attachPoint: string, modelPath: string, effectKey?: string) => any;
  销毁Dz绑定单位特效: (this: void, unit: any, effectKey?: string) => void;
};
const { 开始充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
};
const { 获取坐标范围敌人 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围") as {
  获取坐标范围敌人: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};

const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (u: any, state: any, value: number) => void;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 破血之戒物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 破血之戒配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 破血之戒特效键, 破血之戒绑定附着点 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";

type 破血之戒上下文 = Pick<物品技能事件上下文, "施法单位" | "目标X" | "目标Y" | "目标单位">;

const 破血之戒上下文托管器 = 创建句柄上下文托管器<破血之戒上下文>("破血之戒上下文");

function 是否为破血之戒(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return jass.GetItemTypeId(物品) === 破血之戒物品ID;
}

function 清理破血之戒上下文(this: void, 单位: any): void {
  破血之戒上下文托管器.清空(单位);
}

function 结算破血之戒(this: void, 施法单位: any): void {
  const 上下文 = 破血之戒上下文托管器.读取(施法单位);
  if (上下文 == null) return;

  const 伤害值 = 破血之戒配置.基础伤害 + GetUnitState(施法单位, ConvertUnitState(0x15)) * 3;
  const 敌人列表 = 获取坐标范围敌人(施法单位, 上下文.目标X, 上下文.目标Y, 破血之戒配置.作用范围);
  createTimedEffect(破血之戒配置.选取特效路径, 上下文.目标X, 上下文.目标Y, 0, 1);

  for (let i = 0; i < 敌人列表.length; i++) {
    const 敌人 = 敌人列表[i];
    if (敌人 == null || 敌人 === 0) continue;
    造成装备伤害(施法单位, 敌人, 伤害值, DAMAGE_TYPE_ENHANCED, true, undefined, { 伤害形态: "AOE" });
  }
}

function 开始破血之戒充能(this: void, 施法单位: any): void {
  创建Dz绑定单位特效(施法单位, 破血之戒绑定附着点, 破血之戒配置.施法特效路径, 破血之戒特效键);
  开始充能(施法单位, {
    持续时间: 破血之戒配置.充能时间,
    主单位: 施法单位,
    主单位死亡时中断: true,
    显示进度条特效: true,
    充能完成回调: function 破血之戒完成回调(this: void, 单位: any, _充能ID: number): void {
      结算破血之戒(单位);
    },
    结束回调: function 破血之戒结束回调(this: void, 单位: any, _原因: any, _充能ID: number): void {
      销毁Dz绑定单位特效(单位, 破血之戒特效键);
      清理破血之戒上下文(单位);
    },
  });
}

export function 处理破血之戒使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("05．破血之戒", "进入", "处理破血之戒使用");
  if (!是否为破血之戒(上下文.物品)) return;
  if (上下文.目标单位 == null || 上下文.目标单位 === 0) return;

  const 施法单位 = 上下文.施法单位;
  破血之戒上下文托管器.写入(施法单位, {
    施法单位,
    目标X: 上下文.目标X,
    目标Y: 上下文.目标Y,
    目标单位: 上下文.目标单位,
  });

  const 当前生命 = GetUnitState(施法单位, UNIT_STATE_LIFE);
  SetUnitState(施法单位, UNIT_STATE_LIFE, 当前生命 - 1000);
  开始破血之戒充能(施法单位);
}

export {};
