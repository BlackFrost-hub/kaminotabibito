/** @noSelfInFile */

const { isDamageReduceDisabled } = require("../../../04．伤害系统/00．伤害计算/01．属性读取") as {
  isDamageReduceDisabled: (this: void, unit: any) => boolean;
};
const { 伤害事件伤害类型 } = require("./00．公共/01．伤害事件工具") as {
  伤害事件伤害类型: { 精神: any };
};

const 血浴之母的第二条右腿 = require("../00．物品/117．血浴之母的第二条右腿") as {
  处理血浴之母的第二条右腿伤害修正: (this: void, context: any, 当前伤害: number) => number;
};
const 血浴之母的第二条左腿 = require("../00．物品/118．血浴之母的第二条左腿") as {
  处理血浴之母的第二条左腿伤害修正: (this: void, context: any, 当前伤害: number) => number;
};
const 防御蜘蛛项链 = require("../00．物品/119．防御蜘蛛项链") as {
  处理防御蜘蛛项链伤害修正: (this: void, context: any, 当前伤害: number) => number;
};
const 熔岩恶魔羽翼 = require("../00．物品/120．熔岩恶魔羽翼") as {
  处理熔岩恶魔羽翼伤害修正: (this: void, context: any, 当前伤害: number) => number;
};
const 精致沙斧 = require("../00．物品/121．精致沙斧") as {
  处理精致沙斧伤害修正: (this: void, context: any, 当前伤害: number) => number;
};
const 熔岩恶魔王翼 = require("../00．物品/122．熔岩恶魔王翼") as {
  处理熔岩恶魔王翼伤害修正: (this: void, context: any, 当前伤害: number) => number;
};
const 精致木盾 = require("../00．物品/123．精致木盾") as {
  处理精致木盾伤害修正: (this: void, context: any, 当前伤害: number) => number;
};
const 地狱火护肩 = require("../00．物品/124．地狱火护肩") as {
  处理地狱火护肩伤害修正: (this: void, context: any, 当前伤害: number) => number;
  处理地狱火护肩最终伤害: (this: void, ctx: any) => void;
};
const 恶荣胸甲 = require("../00．物品/125．恶荣胸甲") as {
  处理恶荣胸甲伤害修正: (this: void, context: any, 当前伤害: number) => number;
};
const 狱魔短匕 = require("../00．物品/126．狱魔短匕") as {
  处理狱魔短匕最终伤害: (this: void, ctx: any) => void;
};

function WPSHJS前置条件通过_伤害修正(this: void, context: any): boolean {
  if (context == null || context.target == null || context.target === 0) return false;
  if (!(context.currentDamage >= 1)) return false;
  if (context.rawDamageType === 伤害事件伤害类型.精神) return false;
  if (isDamageReduceDisabled(context.target)) return false;
  return true;
}

function WPSHJS前置条件通过_最终伤害(this: void, ctx: any): boolean {
  if (ctx == null || ctx.target == null || ctx.target === 0 || ctx.snapshot == null) return false;
  if (!(ctx.applied >= 1)) return false;
  if (ctx.snapshot.rawDamageType === 伤害事件伤害类型.精神) return false;
  if (isDamageReduceDisabled(ctx.target)) return false;
  return true;
}

function 限制伤害不为负数(this: void, value: number): number {
  if (value <= 0) return 0;
  return value;
}

export function 处理WPSHJS伤害修正(this: void, context: any, 初始伤害?: number): number {
  if (!WPSHJS前置条件通过_伤害修正(context)) return 初始伤害 ?? context.currentDamage;

  let 当前伤害 = 初始伤害 ?? context.currentDamage;
  当前伤害 = 血浴之母的第二条右腿.处理血浴之母的第二条右腿伤害修正(context, 当前伤害);
  当前伤害 = 血浴之母的第二条左腿.处理血浴之母的第二条左腿伤害修正(context, 当前伤害);
  当前伤害 = 防御蜘蛛项链.处理防御蜘蛛项链伤害修正(context, 当前伤害);
  当前伤害 = 熔岩恶魔羽翼.处理熔岩恶魔羽翼伤害修正(context, 当前伤害);
  当前伤害 = 精致沙斧.处理精致沙斧伤害修正(context, 当前伤害);
  当前伤害 = 熔岩恶魔王翼.处理熔岩恶魔王翼伤害修正(context, 当前伤害);
  当前伤害 = 精致木盾.处理精致木盾伤害修正(context, 当前伤害);
  当前伤害 = 地狱火护肩.处理地狱火护肩伤害修正(context, 当前伤害);
  当前伤害 = 恶荣胸甲.处理恶荣胸甲伤害修正(context, 当前伤害);
  return 限制伤害不为负数(当前伤害);
}

export function 处理WPSHJS最终伤害(this: void, ctx: any): void {
  if (!WPSHJS前置条件通过_最终伤害(ctx)) return;
  地狱火护肩.处理地狱火护肩最终伤害(ctx);
  狱魔短匕.处理狱魔短匕最终伤害(ctx);
}

export {};
