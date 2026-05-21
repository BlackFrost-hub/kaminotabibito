/** @noSelfInFile */

const { resolveItemIdByName } = require("../../13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 单位持有伤害事件装备, 造成伤害事件伤害, 伤害事件伤害类型, 伤害事件攻击类型 } = require("../04．伤害事件/00．公共/01．伤害事件工具") as {
  单位持有伤害事件装备: (this: void, unit: any, itemTypeId: number) => boolean;
  造成伤害事件伤害: (this: void, source: any, target: any, damage: number, damageType: any) => void;
  伤害事件伤害类型: { 普通: any; 强化: any };
  伤害事件攻击类型: { 普通: any };
};
const { 读取玩家属性 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  读取玩家属性: (this: void, unit: any, attrName: string) => number;
};
const { 是否恶魔单位 } = require("../../../03．技能系统/00．技能模板+函数/02．通用函数/01．便捷短函数集合/06．精英单位判断") as {
  是否恶魔单位: (this: void, unit: any) => boolean;
};

const 狱魔短匕物品ID = stringToFourCCSafe(resolveItemIdByName("狱魔短匕"));
const 魔法加成阈值 = 0.01;
const 额外伤害系数 = 0.45;

export function 处理狱魔短匕最终伤害(this: void, ctx: any): void {
  if (狱魔短匕物品ID === 0) return;
  if (ctx == null || ctx.attacker == null || ctx.attacker === 0 || ctx.target == null || ctx.target === 0 || ctx.snapshot == null) return;
  if (!单位持有伤害事件装备(ctx.attacker, 狱魔短匕物品ID)) return;
  if (!(ctx.applied > 0)) return;
  if (读取玩家属性(ctx.attacker, "魔法伤害") <= 魔法加成阈值) return;
  if (ctx.snapshot.rawAttackType !== 伤害事件攻击类型.普通) return;
  if (ctx.snapshot.rawDamageType === 伤害事件伤害类型.普通) return;
  if (ctx.snapshot.rawDamageType === 伤害事件伤害类型.强化) return;
  if (是否恶魔单位(ctx.target) !== true) return;
  造成伤害事件伤害(ctx.attacker, ctx.target, ctx.applied * 额外伤害系数, 伤害事件伤害类型.强化);
}

export {};
