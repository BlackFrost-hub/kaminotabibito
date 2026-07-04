/** @noSelfInFile */

import { stringToFourCC, 单位有效 } from "../../02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};

export interface 单位技能壳监听参数<T> {
  名称: string;
  单位类型ID: string | number;
  技能ID: string | number;
  获取或创建上下文: (this: void, unit: any) => T | undefined;
  释放技能: (this: void, context: T, unit: any) => void;
  可释放?: (this: void, context: T, unit: any) => boolean;
}

const 监听列表: 单位技能壳监听参数<any>[] = [];
let 已注册监听 = false;

function 转ID(this: void, id: string | number): number {
  return typeof id === "number" ? id : stringToFourCC(id);
}

function on单位技能壳监听施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (!单位有效(castingUnit)) return;
  const unitTypeId = GetUnitTypeId(castingUnit);
  for (let i = 0; i < 监听列表.length; i++) {
    const 参数 = 监听列表[i];
    if (spellAbilityId !== 转ID(参数.技能ID)) continue;
    if (unitTypeId !== 转ID(参数.单位类型ID)) continue;
    const context = 参数.获取或创建上下文(castingUnit);
    if (context == null) continue;
    if (参数.可释放 != null && !参数.可释放(context, castingUnit)) continue;
    参数.释放技能(context, castingUnit);
  }
}

function 确保单位技能壳总监听(this: void): void {
  if (已注册监听) return;
  已注册监听 = true;
  registerSpellEffectListener(on单位技能壳监听施法);
}

export function 注册单位技能壳监听<T>(this: void, 参数: 单位技能壳监听参数<T>): void {
  确保单位技能壳总监听();
  监听列表.push(参数 as 单位技能壳监听参数<any>);
}

export {};
