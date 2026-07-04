/** @noSelfInFile */

import { 卡瑟拉单位技能配置 } from "./00．配置";
import { 获取或创建卡瑟拉上下文, type 卡瑟拉运行时上下文 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, stringToFourCC, 距离XY, 限制数值 } from "./14．公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 开始方向抵抗牵引 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.方向抵抗牵引") as {
  开始方向抵抗牵引: (this: void, 参数: any) => any;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．物品技能工具") as {
  施加眩晕: (this: void, source: any, target: any, duration: number) => void;
};

const 卡瑟拉单位类型ID = stringToFourCC(卡瑟拉单位技能配置.单位ID);
const 深海涡流技能ID = stringToFourCC(卡瑟拉数值与表现配置.深海涡流.技能槽位);
let 已注册 = false;

function 播放限时涡流特效(this: void, context: 卡瑟拉运行时上下文, x: number, y: number): void {
  const cfg = 卡瑟拉数值与表现配置.深海涡流;
  const model: string = cfg.涡流模型路径;
  if (model === "") return;
  const effect = AddSpecialEffect(model, x, y);
  context.清理.登记特效("卡瑟拉-深海涡流特效", effect);
  const id = addDelayedCallback(cfg.涡流特效持续秒 * 1000, function 卡瑟拉深海涡流特效销毁(this: void): void {
    DestroyEffect(effect);
  });
  context.清理.登记延迟回调("卡瑟拉-深海涡流特效销毁", id);
}

function 结算深海涡流爆发(this: void, context: 卡瑟拉运行时上下文, x: number, y: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 卡瑟拉数值与表现配置.深海涡流;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const dist = 距离XY(GetUnitX(hero), GetUnitY(hero), x, y);
    if (dist > cfg.最大半径) continue;
    const t = 限制数值(dist / cfg.最大半径, 0, 1);
    const coeff = cfg.最近伤害系数 - (cfg.最近伤害系数 - cfg.最远伤害系数) * t;
    UnitDamageTarget(boss, hero, cfg.基础水伤害 * coeff, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS);
    施加眩晕(boss, hero, cfg.眩晕秒);
  }
}

export function 释放卡瑟拉深海涡流(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 卡瑟拉数值与表现配置.深海涡流;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  播放卡瑟拉台词(boss, "深海涡流");
  播放限时涡流特效(context, x, y);
  创建技能提示圈({
    类型: "圆形",
    X: x,
    Y: y,
    半径: cfg.最大半径,
    持续时间: cfg.爆发延迟秒,
    来源单位: boss,
  });
  开始方向抵抗牵引({
    名称: "卡瑟拉-深海涡流牵引",
    目标单位列表: heroes,
    中心X: x,
    中心Y: y,
    持续秒: cfg.爆发延迟秒,
    每秒拉力速度: cfg.拉力速度,
    抵抗方向角度: GetUnitFacing(boss) + 180,
    抵抗夹角: cfg.抵抗夹角,
    抵抗后拉力倍率: cfg.抵抗后拉力倍率,
    清理篮子: context.清理,
  });
  const id = addDelayedCallback(cfg.爆发延迟秒 * 1000, function 卡瑟拉深海涡流爆发(this: void): void {
    结算深海涡流爆发(context, x, y);
  });
  context.清理.登记延迟回调("卡瑟拉-深海涡流爆发", id);
}

function on卡瑟拉深海涡流施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 深海涡流技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 卡瑟拉单位类型ID) return;
  const context = 获取或创建卡瑟拉上下文(castingUnit);
  if (context == null) return;
  释放卡瑟拉深海涡流(context);
}

export function 注册卡瑟拉深海涡流(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "03．深海涡流",
    单位类型ID: 卡瑟拉单位类型ID,
    技能ID: 深海涡流技能ID,
    获取或创建上下文: 获取或创建卡瑟拉上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 卡瑟拉运行时上下文, boss: any): void {
      on卡瑟拉深海涡流施法(boss, 深海涡流技能ID);
    },
  });
}
