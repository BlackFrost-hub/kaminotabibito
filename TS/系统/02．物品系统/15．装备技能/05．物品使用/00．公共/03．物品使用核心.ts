/** @noSelfInFile */

const { 注册物品技能事件监听 } = require("系统.00．核心系统.01．事件中心.13．物品技能事件中心") as {
  注册物品技能事件监听: (this: void, callback: (this: void, ctx: 物品技能事件上下文) => void) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

const jass = require("jass.common") as any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

import { 瑟兰迪尔的决心物品ID } from "../../03．主动技能/00．公共/01．主动技能物品ID";
import { 物品使用装备ID } from "./01．物品使用配置表";

export type 物品技能事件上下文 = {
  施法单位: any;
  物品: any;
  技能ID: number;
  目标X: number;
  目标Y: number;
  目标单位: any;
  目标可破坏物: any;
};

const 狱妖魔盾 = require("系统.02．物品系统.15．装备技能.00．物品.49．狱妖魔盾") as {
  初始化狱妖魔盾持有充能: (this: void) => void;
  处理狱妖魔盾使用: (this: void, ctx: 物品技能事件上下文) => void;
};
const 商人之书 = require("系统.02．物品系统.15．装备技能.00．物品.50．商人之书") as { 处理商人之书使用: (this: void, ctx: 物品技能事件上下文) => void };
const 狂暴树枝 = require("系统.02．物品系统.15．装备技能.00．物品.51．狂暴树枝") as { 处理狂暴树枝使用: (this: void, ctx: 物品技能事件上下文) => void };
const 首领号角 = require("系统.02．物品系统.15．装备技能.00．物品.52．首领号角") as { 处理首领号角使用: (this: void, ctx: 物品技能事件上下文) => void };
const 精灵号角 = require("系统.02．物品系统.15．装备技能.00．物品.53．精灵号角") as { 处理精灵号角使用: (this: void, ctx: 物品技能事件上下文) => void };
const 守卫大剑 = require("系统.02．物品系统.15．装备技能.00．物品.54．守卫大剑") as { 处理守卫大剑使用: (this: void, ctx: 物品技能事件上下文) => void };
const 斯尔能量之心 = require("系统.02．物品系统.15．装备技能.00．物品.55．斯尔能量之心") as {
  处理斯尔能量之心使用: (this: void, ctx: 物品技能事件上下文) => void;
  处理斯尔能量之心击杀: (this: void, dyingUnit: any, killingUnit: any) => void;
};
const 熔岩地狱之敲钟 = require("系统.02．物品系统.15．装备技能.00．物品.56．熔岩地狱之敲钟") as { 处理熔岩地狱之敲钟使用: (this: void, ctx: 物品技能事件上下文) => void };
const 阴暗之敲钟 = require("系统.02．物品系统.15．装备技能.00．物品.57．阴暗之敲钟") as { 处理阴暗之敲钟使用: (this: void, ctx: 物品技能事件上下文) => void };
const 地狱火卡牌攻击 = require("系统.02．物品系统.15．装备技能.00．物品.58．地狱火卡牌攻击") as { 处理地狱火卡牌攻击使用: (this: void, ctx: 物品技能事件上下文) => void };
const 焰混能量体 = require("系统.02．物品系统.15．装备技能.00．物品.59．焰混能量体") as {
  处理焰混能量体使用: (this: void, ctx: 物品技能事件上下文) => void;
  处理焰混能量体伤害: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void;
};
const 恶斯胸甲 = require("系统.02．物品系统.15．装备技能.00．物品.60．恶斯胸甲") as {
  处理恶斯胸甲使用: (this: void, ctx: 物品技能事件上下文) => void;
  处理恶斯胸甲伤害修正: (this: void, context: any) => number;
};
const 亡灵魔鞋 = require("系统.02．物品系统.15．装备技能.00．物品.61．亡灵魔鞋") as { 处理亡灵魔鞋使用: (this: void, ctx: 物品技能事件上下文) => void };
const 恶魔铃铛 = require("系统.02．物品系统.15．装备技能.00．物品.62．恶魔铃铛") as { 处理恶魔铃铛使用: (this: void, ctx: 物品技能事件上下文) => void };
const 魔古战刃 = require("系统.02．物品系统.15．装备技能.00．物品.63．魔古战刃") as {
  处理魔古战刃使用: (this: void, ctx: 物品技能事件上下文) => void;
  处理魔古战刃伤害: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void;
};
const 女妖魔甲 = require("系统.02．物品系统.15．装备技能.00．物品.64．女妖魔甲") as { 处理女妖魔甲使用: (this: void, ctx: 物品技能事件上下文) => void };
const 熔灵宝石之戒 = require("系统.02．物品系统.15．装备技能.00．物品.65．熔灵宝石之戒") as { 处理熔灵宝石之戒使用: (this: void, ctx: 物品技能事件上下文) => void };
const 浴血药剂 = require("系统.02．物品系统.15．装备技能.00．物品.66．浴血药剂") as { 处理浴血药剂使用: (this: void, ctx: 物品技能事件上下文) => void };
const 浴魔药剂 = require("系统.02．物品系统.15．装备技能.00．物品.67．浴魔药剂") as { 处理浴魔药剂使用: (this: void, ctx: 物品技能事件上下文) => void };
const 浴灵药剂 = require("系统.02．物品系统.15．装备技能.00．物品.68．浴灵药剂") as { 处理浴灵药剂使用: (this: void, ctx: 物品技能事件上下文) => void };
const 嗜狱恶剑 = require("系统.02．物品系统.15．装备技能.00．物品.69．嗜狱恶剑") as { 处理嗜狱恶剑使用: (this: void, ctx: 物品技能事件上下文) => void };
const 盗贼神符魔抗 = require("系统.02．物品系统.15．装备技能.00．物品.70．盗贼神符魔抗") as { 处理盗贼神符魔抗使用: (this: void, ctx: 物品技能事件上下文) => void };
const 火把 = require("系统.02．物品系统.15．装备技能.00．物品.71．火把") as { 处理火把使用: (this: void, ctx: 物品技能事件上下文) => void };
const 抗毒药水 = require("系统.02．物品系统.15．装备技能.00．物品.114．抗毒药水") as { 处理抗毒药水使用: (this: void, ctx: 物品技能事件上下文) => void };
const 瑟兰迪尔的决心 = require("系统.02．物品系统.15．装备技能.00．物品.162．瑟兰迪尔的决心") as { 处理瑟兰迪尔的决心使用: (this: void, ctx: 物品技能事件上下文) => void };
const 影骨披风 = require("系统.02．物品系统.15．装备技能.00．物品.131．影骨披风") as { 处理影骨披风使用: (this: void, ctx: 物品技能事件上下文) => void };
const 阴影陷阱装置 = require("系统.02．物品系统.15．装备技能.00．物品.134．阴影陷阱装置") as { 处理阴影陷阱装置使用: (this: void, ctx: 物品技能事件上下文) => void };

let 已初始化 = false;

function 物品使用单位是英雄(this: void, ctx: 物品技能事件上下文): boolean {
  const unit = ctx.施法单位;
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true;
}

function on物品使用链路(this: void, ctx: 物品技能事件上下文): void {
  if (!物品使用单位是英雄(ctx)) return;
  if (ctx.物品 == null || ctx.物品 === 0) return;
  const 物品类型ID = GetItemTypeId(ctx.物品);
  switch (物品类型ID) {
    case 物品使用装备ID.狱妖魔盾:
      狱妖魔盾.处理狱妖魔盾使用(ctx);
      break;
    case 物品使用装备ID.商人之书:
      商人之书.处理商人之书使用(ctx);
      break;
    case 物品使用装备ID.狂暴树枝:
      狂暴树枝.处理狂暴树枝使用(ctx);
      break;
    case 物品使用装备ID.首领号角:
      首领号角.处理首领号角使用(ctx);
      break;
    case 物品使用装备ID.精灵号角:
      精灵号角.处理精灵号角使用(ctx);
      break;
    case 物品使用装备ID.守卫大剑:
      守卫大剑.处理守卫大剑使用(ctx);
      break;
    case 物品使用装备ID.斯尔能量之心:
      斯尔能量之心.处理斯尔能量之心使用(ctx);
      break;
    case 物品使用装备ID.熔岩地狱之敲钟:
      熔岩地狱之敲钟.处理熔岩地狱之敲钟使用(ctx);
      break;
    case 物品使用装备ID.阴暗之敲钟:
      阴暗之敲钟.处理阴暗之敲钟使用(ctx);
      break;
    case 物品使用装备ID.地狱火卡牌攻击:
      地狱火卡牌攻击.处理地狱火卡牌攻击使用(ctx);
      break;
    case 物品使用装备ID.焰混能量体:
      焰混能量体.处理焰混能量体使用(ctx);
      break;
    case 物品使用装备ID.恶斯胸甲:
      恶斯胸甲.处理恶斯胸甲使用(ctx);
      break;
    case 物品使用装备ID.亡灵魔鞋:
      亡灵魔鞋.处理亡灵魔鞋使用(ctx);
      break;
    case 物品使用装备ID.恶魔铃铛:
      恶魔铃铛.处理恶魔铃铛使用(ctx);
      break;
    case 物品使用装备ID.魔古战刃:
      魔古战刃.处理魔古战刃使用(ctx);
      break;
    case 物品使用装备ID.女妖魔甲:
      女妖魔甲.处理女妖魔甲使用(ctx);
      break;
    case 物品使用装备ID.熔灵宝石之戒:
      熔灵宝石之戒.处理熔灵宝石之戒使用(ctx);
      break;
    case 物品使用装备ID.浴血药剂:
      浴血药剂.处理浴血药剂使用(ctx);
      break;
    case 物品使用装备ID.浴魔药剂:
      浴魔药剂.处理浴魔药剂使用(ctx);
      break;
    case 物品使用装备ID.浴灵药剂:
      浴灵药剂.处理浴灵药剂使用(ctx);
      break;
    case 物品使用装备ID.嗜狱恶剑:
      嗜狱恶剑.处理嗜狱恶剑使用(ctx);
      break;
    case 物品使用装备ID.盗贼神符魔抗:
      盗贼神符魔抗.处理盗贼神符魔抗使用(ctx);
      break;
    case 物品使用装备ID.火把:
      火把.处理火把使用(ctx);
      break;
    case 物品使用装备ID.抗毒药水:
      抗毒药水.处理抗毒药水使用(ctx);
      break;
    case 瑟兰迪尔的决心物品ID:
      瑟兰迪尔的决心.处理瑟兰迪尔的决心使用(ctx);
      break;
    case 物品使用装备ID.影骨披风:
      影骨披风.处理影骨披风使用(ctx);
      break;
    case 物品使用装备ID.阴影陷阱装置:
      阴影陷阱装置.处理阴影陷阱装置使用(ctx);
      break;
  }
}

function on物品使用死亡事件(this: void, dyingUnit: any, killingUnit: any): void {
  斯尔能量之心.处理斯尔能量之心击杀(dyingUnit, killingUnit);
}

function on物品使用最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied >= 1)) return;
  if (snapshot != null && snapshot.isTrueDamage === true) return;
  焰混能量体.处理焰混能量体伤害(target, attacker, applied, snapshot);
  魔古战刃.处理魔古战刃伤害(target, attacker, applied, snapshot);
}

function on物品使用伤害修正(this: void, context: any): number {
  if (!(context.currentDamage >= 1)) return context.currentDamage;
  if (context.isTrueDamage === true) return context.currentDamage;
  return 恶斯胸甲.处理恶斯胸甲伤害修正(context);
}

export function 初始化装备物品使用链(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  狱妖魔盾.初始化狱妖魔盾持有充能();
  注册物品技能事件监听(on物品使用链路);
  registerDeathListener(on物品使用死亡事件);
  registerAppliedFinalDamageListener(on物品使用最终伤害);
  registerDamageModifier(on物品使用伤害修正, 30);
}

初始化装备物品使用链();

export {};
