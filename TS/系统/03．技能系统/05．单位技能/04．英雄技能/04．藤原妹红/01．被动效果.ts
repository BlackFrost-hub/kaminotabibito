/** @noSelfInFile */

import { 藤原妹红单位技能配置 } from "./00．配置";
import { 播放藤原妹红单位音效, 创建藤原妹红点特效 } from "./00A．表现工具";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 创建致命伤害保命与限时免疫 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.10．致命伤害保命与限时免疫") as {
  创建致命伤害保命与限时免疫: (this: void, 参数: any) => any;
};
const { registerPlayerHeroListener, getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  registerPlayerHeroListener: (this: void, callback: (this: void, whichPlayer: any, whichHero: any) => void) => void;
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 读取单位最大生命, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  读取单位最大生命: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const PauseUnit = jass.PauseUnit as (this: void, unit: any, flag: boolean) => void;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const 藤原妹红单位类型ID = stringToFourCCSafe(藤原妹红单位技能配置.单位类型ID);
const 被动技能ID = stringToFourCCSafe(藤原妹红单位技能配置.被动.技能ID);
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

interface 藤原妹红被动重生上下文 {
  单位: any;
  攻击力伤害: number;
  重生阶段: number;
  环形层级: number;
  火焰已播放: boolean;
  回调ID: number;
  重生中: boolean;
}

interface 藤原妹红被动状态 {
  单位: any;
  冷却截止时间Ms: number;
  重生上下文?: 藤原妹红被动重生上下文;
  控制器?: any;
}

const 被动状态表: Record<number, 藤原妹红被动状态 | undefined> = {};

function 取单位句柄ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : (jass.GetHandleId(unit) || 0);
}

function 取被动状态(this: void, unit: any): 藤原妹红被动状态 | undefined {
  return 被动状态表[取单位句柄ID(unit)];
}

function 被动条件允许触发(this: void, context: any): boolean {
  const unit = context?.target;
  const state = 取被动状态(unit);
  if (state == null || state.重生上下文?.重生中 === true) return false;
  if (getServerTime() < state.冷却截止时间Ms) return false;
  const maximumMana = GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA);
  if (!(maximumMana > 0)) return false;
  return GetUnitState(unit, UNIT_STATE_MANA) / maximumMana >= 藤原妹红单位技能配置.被动.魔法值百分比门槛 * 0.01;
}

function 被动免疫伤害过滤(this: void, context: any): boolean {
  const state = 取被动状态(context?.target);
  return state?.重生上下文?.重生中 === true;
}

function 被动重生目标允许命中(this: void, source: any, target: any): boolean {
  return 单位存活(target)
    && !IsUnitType(target, UNIT_TYPE_ANCIENT)
    && !IsUnitType(target, UNIT_TYPE_MECHANICAL)
    && !IsUnitType(target, UNIT_TYPE_STRUCTURE)
    && jass.IsUnitEnemy(target, jass.GetOwningPlayer(source));
}

function 准备被动重生伤害(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 藤原妹红被动重生上下文 | undefined;
  if (context == null || !被动重生目标允许命中(context.单位, target)) return undefined;
  return {
    伤害: context.攻击力伤害 * 藤原妹红单位技能配置.被动.复活伤害攻击力倍率,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: true,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  };
}

function 结束被动重生(this: void, context: 藤原妹红被动重生上下文): void {
  if (!context.重生中) return;
  context.重生中 = false;
  if (context.回调ID !== 0) {
    removePeriodicCallback(context.回调ID);
    context.回调ID = 0;
  }
  const maximumLife = 读取单位最大生命(context.单位);
  if (maximumLife > 0) {
    SetUnitState(context.单位, UNIT_STATE_LIFE, maximumLife * 藤原妹红单位技能配置.被动.重生生命百分比 * 0.01);
  }
  创建藤原妹红点特效(
    藤原妹红单位技能配置.被动.重生爆炸特效,
    GetUnitX(context.单位),
    GetUnitY(context.单位),
  );
  SetUnitInvulnerable(context.单位, false);
  PauseUnit(context.单位, false);
  const state = 取被动状态(context.单位);
  if (state != null && state.重生上下文 === context) state.重生上下文 = undefined;
}

function 藤原妹红被动重生Tick(this: void, variable?: any): void {
  const context = variable as 藤原妹红被动重生上下文 | undefined;
  if (context == null || !context.重生中) return;
  if (!单位存活(context.单位)) {
    结束被动重生(context);
    return;
  }
  const cfg = 藤原妹红单位技能配置.被动;
  if (context.重生阶段 >= cfg.爆炸阶段) {
    结束被动重生(context);
    return;
  }

  const x = GetUnitX(context.单位);
  const y = GetUnitY(context.单位);
  if (!context.火焰已播放 && context.重生阶段 >= cfg.火焰阶段) {
    context.火焰已播放 = true;
    创建藤原妹红点特效(cfg.火焰特效, x, y);
  }
  for (let i = 1; i <= cfg.环形数量; i++) {
    const angle = cfg.环形间隔角度 * i;
    const radians = angle * 0.017453292519943295;
    创建藤原妹红点特效(
      cfg.环形特效,
      x + Cos(radians) * cfg.环形半径 * context.环形层级,
      y + Sin(radians) * cfg.环形半径 * context.环形层级,
      angle,
    );
  }
  const targets = 获取范围敌军(context.单位, x, y, cfg.伤害范围);
  造成批量AOE技能伤害({
    来源: context.单位,
    目标列表: targets,
    伤害类型: DAMAGE_TYPE_FIRE,
    技能ID: 被动技能ID,
    来源类型: "单位技能",
    标签: "藤原妹红-不死鸟重生",
    每目标处理器: 准备被动重生伤害,
    变量: context,
  });
  context.重生阶段 += cfg.重生阶段增量;
  context.环形层级 += 1;
  const maximumLife = 读取单位最大生命(context.单位);
  if (maximumLife > 0) SetUnitState(context.单位, UNIT_STATE_LIFE, maximumLife * context.重生阶段);
}

function 触发藤原妹红被动重生(this: void, event: any): void {
  const unit = event?.单位;
  const state = 取被动状态(unit);
  if (state == null) return;
  const cfg = 藤原妹红单位技能配置.被动;
  state.冷却截止时间Ms = getServerTime() + cfg.被动冷却秒 * 1000;
  const context: 藤原妹红被动重生上下文 = {
    单位: unit,
    攻击力伤害: 读取单位攻击力(unit),
    重生阶段: 0,
    环形层级: 1,
    火焰已播放: false,
    回调ID: 0,
    重生中: true,
  };
  state.重生上下文 = context;
  SetUnitState(unit, UNIT_STATE_LIFE, 1);
  SetUnitInvulnerable(unit, true);
  PauseUnit(unit, true);
  播放藤原妹红单位音效(unit, cfg.起手音效键);
  context.回调ID = addPeriodicCallback(cfg.重生周期毫秒, 藤原妹红被动重生Tick, context);
}

function 创建藤原妹红被动状态(this: void, unit: any): void {
  if (unit == null || unit === 0 || GetUnitTypeId(unit) !== 藤原妹红单位类型ID) return;
  const unitId = 取单位句柄ID(unit);
  if (unitId === 0 || 被动状态表[unitId] != null) return;
  const state: 藤原妹红被动状态 = {
    单位: unit,
    冷却截止时间Ms: 0,
  };
  被动状态表[unitId] = state;
  state.控制器 = 创建致命伤害保命与限时免疫({
    名称: "藤原妹红-不死鸟重生",
    单位: unit,
    固定生命下限: 1,
    免疫持续秒: 藤原妹红单位技能配置.被动.重生无敌持续秒,
    生命下限修正优先级: -100,
    免疫修正优先级: -99,
    过滤致命伤害: 被动条件允许触发,
    过滤免疫伤害: 被动免疫伤害过滤,
    on触发: 触发藤原妹红被动重生,
  });
}

function 藤原妹红玩家英雄注册(this: void, _player: any, hero: any): void {
  创建藤原妹红被动状态(hero);
}

function 初始化已注册藤原妹红(this: void): void {
  for (let i = 0; i < 16; i++) 创建藤原妹红被动状态(getRegisteredPlayerHero(jass.Player(i)));
}

registerPlayerHeroListener(藤原妹红玩家英雄注册);
初始化已注册藤原妹红();

export {};
