/** @noSelfInFile */

const { resolveItemIdByName } = require("../../13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 单位持有伤害事件装备, 取最大生命, 造成伤害事件伤害, 伤害事件伤害类型 } = require("../04．伤害事件/00．公共/01．伤害事件工具") as {
  单位持有伤害事件装备: (this: void, unit: any, itemTypeId: number) => boolean;
  取最大生命: (this: void, unit: any) => number;
  造成伤害事件伤害: (this: void, source: any, target: any, damage: number, damageType: any) => void;
  伤害事件伤害类型: { 强化: any };
};
const { 装备触发概率通过 } = require("../../../03．技能系统/00．技能模板+函数/01．技能函数/22．幸运值") as {
  装备触发概率通过: (this: void, rate: number, unit: any) => boolean;
};

const jass = require("jass.common") as any;
const GetHeroStr = jass.GetHeroStr as (whichHero: any, includeBonuses: boolean) => number;
const GetUnitLevel = jass.GetUnitLevel as (whichUnit: any) => number;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

const 地狱火护肩物品ID = stringToFourCCSafe(resolveItemIdByName("地狱火护肩"));
const 完全抵挡生命系数 = 0.02;
const 概率 = 0.3;
const 减伤后系数 = 0.6;
const 反击力量系数 = 4;

const 待处理反击伤害: Record<string, number | undefined> = {};
let 地狱火护肩反击进行中 = false;

function 取反击键(this: void, source: any, target: any): string {
  return GetHandleId(source) + ":" + GetHandleId(target);
}

export function 处理地狱火护肩伤害修正(this: void, context: any, 当前伤害: number): number {
  if (地狱火护肩物品ID === 0) return 当前伤害;
  if (地狱火护肩反击进行中) return 当前伤害;
  if (context == null || context.target == null || context.target === 0 || context.attacker == null || context.attacker === 0) return 当前伤害;
  if (!单位持有伤害事件装备(context.target, 地狱火护肩物品ID)) return 当前伤害;

  const 完全抵挡阈值 = 取最大生命(context.target) * 完全抵挡生命系数 + GetUnitLevel(context.target);
  if (当前伤害 < 完全抵挡阈值) {
    return 0;
  }

  if (!装备触发概率通过(概率, context.target)) return 当前伤害;
  待处理反击伤害[取反击键(context.target, context.attacker)] = GetHeroStr(context.target, true) * 反击力量系数;
  return 当前伤害 * 减伤后系数;
}

export function 处理地狱火护肩最终伤害(this: void, ctx: any): void {
  if (ctx == null || ctx.target == null || ctx.target === 0 || ctx.attacker == null || ctx.attacker === 0) return;
  const 键 = 取反击键(ctx.target, ctx.attacker);
  const 反击伤害 = 待处理反击伤害[键];
  if (!(反击伤害 != null && 反击伤害 > 0)) return;
  delete 待处理反击伤害[键];
  地狱火护肩反击进行中 = true;
  try {
    造成伤害事件伤害(ctx.target, ctx.attacker, 反击伤害, 伤害事件伤害类型.强化);
  } finally {
    地狱火护肩反击进行中 = false;
  }
}

export {};
