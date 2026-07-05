/** @noSelfInFile */

import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { 播放瑟兰迪尔台词 } from "./15．台词播放";

const { getServerTime, addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 施加单体攻击力降低Buff } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.03．攻击力降低") as {
  施加单体攻击力降低Buff: (this: void, 来源单位: any, 目标单位: any, 参数: any) => boolean;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能最远敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能最远敌对英雄: (this: void, boss: any) => any;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 创建循环点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建循环点特效: (this: void, 参数: any) => any;
};
const { 显示场地常驻AOE吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示场地常驻AOE吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};

const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const R2I = jass.R2I as (value: number) => number;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 播放点特效(this: void, model: string, x: number, y: number, duration = 1, scale = 1): void {
  const effect = AddSpecialEffect(model, x, y);
  if (effect != null && effect !== 0) {
    if (scale !== 1) EXSetEffectSize(effect, scale);
    YDWETimerDestroyEffectSafe(duration, effect);
  }
}

function 造成伤害(this: void, boss: any, target: any, amount: number, damageType: any): void {
  if (!单位有效(boss) || !单位有效(target) || amount <= 0) return;
  造成AOE技能伤害({
    来源: boss,
    目标: target,
    伤害: amount,
    attack: false,
    ranged: false,
    attackType: jass.ATTACK_TYPE_NORMAL,
    伤害类型: damageType,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
  });
}

function 按攻击和最大生命计算伤害(this: void, boss: any, target: any, 攻击力比例: number, 最大生命比例: number): number {
  const config = 瑟兰迪尔数值与表现配置.审判之环;
  return (读取单位攻击力(boss) * 攻击力比例 + GetUnitState(target, UNIT_STATE_MAX_LIFE) * 最大生命比例) * config.伤害总倍率;
}

function 取象限名称(this: void, color: number): string {
  if (color === 1) return "红";
  if (color === 2) return "蓝";
  if (color === 3) return "绿";
  return "金";
}

function 取象限吟唱条颜色(this: void, color: number): number {
  if (color === 1) return 4;
  if (color === 2) return 7;
  if (color === 3) return 1;
  return 6;
}

function 取象限法阵颜色(this: void, color: number): number {
  if (color === 1) return 0xFFFF4040;
  if (color === 2) return 0xFF4080FF;
  if (color === 3) return 0xFF40FF60;
  return 0xFFFFD060;
}

export function 尝试触发瑟兰迪尔审判之环(this: void, context: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.审判之环;
  const now = getServerTime();
  if (context.审判之环进行中) return;
  if (context.上次审判之环Ms > 0 && now - context.上次审判之环Ms < config.周期秒 * 1000) return;
  context.上次审判之环Ms = now;
  释放瑟兰迪尔审判之环(context);
}

export function 释放瑟兰迪尔审判之环(this: void, context: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.审判之环;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  if (context.审判之环进行中) return;
  context.审判之环进行中 = true;
  播放瑟兰迪尔台词(boss, "审判之环");

  启动瑟兰迪尔审判之环轮次(context);
}

function 启动瑟兰迪尔审判之环轮次(this: void, context: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.审判之环;
  const boss = context.Boss单位;
  if (!单位有效(boss)) {
    context.审判之环进行中 = false;
    关闭吟唱条("场地常驻AOE");
    return;
  }
  const color = GetRandomInt(1, 4);
  const 象限名称 = 取象限名称(color);
  const 表现中心 = { x: GetUnitX(boss), y: GetUnitY(boss) };
  显示场地常驻AOE吟唱条({
    总时长: config.周期秒,
    颜色ID: 取象限吟唱条颜色(color),
    标题文本: config.吟唱条标题文本 + "：" + 象限名称,
    提示文本: "场地常驻AOE：下次审判象限 " + 象限名称,
  });
  创建循环点特效({
    模型路径: config.特效,
    X: 表现中心.x,
    Y: 表现中心.y,
    缩放: config.法阵缩放,
    顶点颜色: 取象限法阵颜色(color),
    重建间隔秒: config.法阵重建间隔秒,
    单次持续秒: config.法阵单次持续秒,
    总持续秒: config.周期秒,
    存活条件: function 瑟兰迪尔审判之环法阵仍有效(this: void): boolean {
      return context.审判之环进行中 && 单位有效(boss);
    },
  });

  addDelayedCallback(R2I(config.周期秒 * 1000), function 瑟兰迪尔审判之环结算(this: void): void {
    if (!context.审判之环进行中) return;
    if (!单位有效(boss)) {
      context.审判之环进行中 = false;
      关闭吟唱条("场地常驻AOE");
      return;
    }
    结算瑟兰迪尔审判之环象限(boss, color);
    context.上次审判之环Ms = getServerTime();
    启动瑟兰迪尔审判之环轮次(context);
  });
}

function 结算瑟兰迪尔审判之环象限(this: void, boss: any, color: number): void {
  const config = 瑟兰迪尔数值与表现配置.审判之环;
  if (color === 2) {
    const target = 获取Boss技能最远敌对英雄(boss);
    if (单位有效(target)) {
      施加单体攻击力降低Buff(boss, target, {
        BuffID: config.审判压制BuffID,
        持续时间: config.持续秒,
        攻击力: 读取单位攻击力(target) * config.蓝攻击力降低比例,
        图标路径: "BuffIcon\\Boss\\Thranduil\\shenpanyazhi.blp",
      });
    }
    return;
  }

  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    const x = GetUnitX(target);
    const y = GetUnitY(target);
    if (color === 1) {
      播放点特效(config.红特效, x, y, 1);
      造成伤害(boss, target, 按攻击和最大生命计算伤害(boss, target, config.红伤害Boss攻击力比例, config.红伤害目标最大生命比例), jass.DAMAGE_TYPE_FIRE);
    } else if (color === 3) {
      播放点特效(config.绿特效, x, y, 1);
      const life = GetUnitState(target, UNIT_STATE_LIFE);
      const maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);
      if (maxLife > 0 && life / maxLife > 0.75) {
        造成伤害(boss, target, 按攻击和最大生命计算伤害(boss, target, config.绿高血伤害Boss攻击力比例, config.绿高血伤害目标最大生命比例), jass.DAMAGE_TYPE_LIGHTNING);
      } else {
        造成伤害(boss, target, 按攻击和最大生命计算伤害(boss, target, config.绿低血伤害Boss攻击力比例, config.绿低血伤害目标最大生命比例), jass.DAMAGE_TYPE_LIGHTNING);
      }
    } else {
      播放点特效(config.金特效, x, y, 1);
      const mana = GetUnitState(target, UNIT_STATE_MANA);
      const maxMana = GetUnitState(target, UNIT_STATE_MAX_MANA);
      const maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);
      const lostRatio = maxMana > 0 ? (maxMana - mana) / maxMana : 0;
      造成伤害(boss, target, maxLife * lostRatio, jass.DAMAGE_TYPE_MIND);
    }
  }
}

export function 停止瑟兰迪尔审判之环(this: void, context: 瑟兰迪尔运行时上下文): void {
  context.审判之环进行中 = false;
  关闭吟唱条("场地常驻AOE");
}

export function 注册瑟兰迪尔审判之环(this: void): void {
}
