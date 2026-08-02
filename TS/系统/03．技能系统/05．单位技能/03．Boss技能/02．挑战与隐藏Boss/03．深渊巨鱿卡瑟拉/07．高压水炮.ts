/** @noSelfInFile */

import { 卡瑟拉单位技能配置 } from "./00．配置";
import { 获取或创建卡瑟拉上下文, 取玩家触手残片, type 卡瑟拉运行时上下文 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置, 卡瑟拉音效配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, stringToFourCC, 取坐标角度, 极坐标X, 极坐标Y, 点到线段距离平方, 距离平方XY } from "./14．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 提交预计算BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 取单位属性抗性 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.13．属性抗性门槛") as {
  取单位属性抗性: (this: void, unit: any, type: string, applyLimit?: boolean) => number;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始击退: (this: void, unit: any, params: any) => number;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  施加眩晕: (this: void, source: any, target: any, duration: number) => void;
};

const 卡瑟拉单位类型ID = stringToFourCC(卡瑟拉单位技能配置.单位ID);
const 高压水炮技能ID = stringToFourCC(卡瑟拉数值与表现配置.高压水炮.技能槽位);
let 已注册 = false;

function 选择最远玩家(this: void, boss: any): any {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);
  let best: any = undefined;
  let bestDist = -1;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const dist = 距离平方XY(bx, by, GetUnitX(hero), GetUnitY(hero));
    if (dist > bestDist) {
      bestDist = dist;
      best = hero;
    }
  }
  return best;
}

function 玩家水抗达标(this: void, context: 卡瑟拉运行时上下文, hero: any): boolean {
  const cfg = 卡瑟拉数值与表现配置.高压水炮;
  const fragmentResist = 取玩家触手残片(context, hero) * 卡瑟拉数值与表现配置.触手残片.水抗加成;
  return 取单位属性抗性(hero, "水", true) + fragmentResist >= cfg.水抗门槛;
}

function 播放水炮路径特效(this: void, context: 卡瑟拉运行时上下文, startX: number, startY: number, angle: number): void {
  const cfg = 卡瑟拉数值与表现配置.高压水炮;
  let distance = cfg.路径水花间隔;
  while (distance <= cfg.距离) {
    const effect = AddSpecialEffect(cfg.路径水花模型路径, 极坐标X(startX, angle, distance), 极坐标Y(startY, angle, distance));
    DestroyEffect(effect);
    distance = distance + cfg.路径水花间隔;
  }
}

function 结算高压水炮(this: void, context: 卡瑟拉运行时上下文, startX: number, startY: number, angle: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 卡瑟拉数值与表现配置.高压水炮;
  const endX = 极坐标X(startX, angle, cfg.距离);
  const endY = 极坐标Y(startY, angle, cfg.距离);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const radius2 = (cfg.宽度 * 0.5) * (cfg.宽度 * 0.5);
  const damage = 读取单位攻击力(boss) * cfg.Boss攻击力比例;
  播放Boss坐标音效(卡瑟拉音效配置.高压水炮.发射, startX, startY, 卡瑟拉音效配置.默认裁断距离);
  播放水炮路径特效(context, startX, startY, angle);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (点到线段距离平方(GetUnitX(hero), GetUnitY(hero), startX, startY, endX, endY) > radius2) continue;
    提交预计算BossAOE技能伤害({
      技能ID: 高压水炮技能ID,
      来源: boss,
      目标: hero,
      伤害: damage,
      attack: true,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: "卡瑟拉高压水炮",
    });
    if (玩家水抗达标(context, hero)) continue;
    开始击退(hero, {
      来源单位: boss,
      距离: cfg.距离,
      每秒速度: 1500,
      检查地形: true,
      暂停单位: true,
      结束回调: function 卡瑟拉高压水炮击退结束(this: void, movedUnit: any): void {
        if (单位有效(movedUnit)) 施加眩晕(boss, movedUnit, cfg.击退到边缘眩晕秒);
      },
    });
  }
}

export function 释放卡瑟拉高压水炮(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.Boss潜入中) return;
  if (context.阶段 < 2) return;
  const target = 选择最远玩家(boss);
  if (!单位有效(target)) return;
  const cfg = 卡瑟拉数值与表现配置.高压水炮;
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const angle = 取坐标角度(startX, startY, targetX, targetY);
  创建技能提示圈({
    类型: "矩形",
    X: startX,
    Y: startY,
    宽度: cfg.宽度,
    长度: cfg.距离,
    朝向: angle,
    持续时间: cfg.前摇秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    名称: "卡瑟拉-高压水炮",
    施法者: boss,
    目标X: targetX,
    目标Y: targetY,
    生效前重新面向: false,
    硬直秒: cfg.前摇秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    恢复动画编号: 5,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.前摇秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    清理: context.清理,
    播放台词: function 卡瑟拉高压水炮开始提示(this: void): void {
      播放卡瑟拉台词(boss, "高压水炮");
    },
    on生效: function 卡瑟拉高压水炮时间线生效(this: void): void {
      结算高压水炮(context, startX, startY, angle);
    },
  });
}

function on卡瑟拉高压水炮施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 高压水炮技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 卡瑟拉单位类型ID) return;
  const context = 获取或创建卡瑟拉上下文(castingUnit);
  if (context == null) return;
  释放卡瑟拉高压水炮(context);
}

export function 注册卡瑟拉高压水炮(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "07．高压水炮",
    单位类型ID: 卡瑟拉单位类型ID,
    技能ID: 高压水炮技能ID,
    获取或创建上下文: 获取或创建卡瑟拉上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 卡瑟拉运行时上下文, boss: any): void {
      on卡瑟拉高压水炮施法(boss, 高压水炮技能ID);
    },
  });
}
