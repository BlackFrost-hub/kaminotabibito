/** @noSelfInFile */

import { 鹿目圆单位技能配置 } from "./00．配置";
import { 鹿目圆BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/10．鹿目圆";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 移除单位负面Buff } = require("系统.05．Buff系统.05．Buff清除函数") as {
  移除单位负面Buff: (this: void, unit: any, onlyPurgable?: boolean) => number;
};
const { 临时调整攻速, 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  临时调整攻速: (this: void, unit: any, value: number) => void;
  调整玩家属性: (this: void, unit: any, attributeName: string, delta: number) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { 确保单位可设置飞行高度 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享") as {
  确保单位可设置飞行高度: (this: void, unit: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 延后一帧执行伤害派生效果 } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  延后一帧执行伤害派生效果: (this: void, callback: (this: void) => void) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 取单位ID, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  取单位ID: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};

const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => boolean;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const ShowUnit = jass.ShowUnit as (this: void, unit: any, show: boolean) => void;
const PauseUnit = jass.PauseUnit as (this: void, unit: any, flag: boolean) => void;
const UnitRemoveBuffsEx = jass.UnitRemoveBuffsEx as (this: void, unit: any, removePositive: boolean, removeNegative: boolean, magic: boolean, physical: boolean, timedLife: boolean, aura: boolean, autoDispel: boolean) => void;
const UnitApplyTimedLife = jass.UnitApplyTimedLife as (this: void, unit: any, buffId: number, duration: number) => void;
const ConvertUnitState = jass.ConvertUnitState as (this: void, stateId: number) => any;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_ATTACK1_BASE = ConvertUnitState(0x12);
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const DzSetUnitID = japi.DzSetUnitID as (this: void, unit: any, unitTypeId: number) => void;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitStateJapi = japi.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const DzSetUnitModel = japi.DzSetUnitModel as ((this: void, unit: any, model: string) => void) | undefined;
const UNIT_TIMED_LIFE_BUFF = stringToFourCCSafe("BHwe");
const BJ_DEGTORAD = (jass.bj_DEGTORAD ?? 0.017453292519943295) as number;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;

const 配置 = 鹿目圆单位技能配置;

interface 圆神状态 {
  英雄: any;
  到期毫秒: number;
  版本: number;
  阶段: "降临中" | "已完成";
  位置X: number;
  位置Y: number;
  降临起始ID: number;
  降临展示ID: number;
  降临下降ID: number;
  状态到期ID: number;
  持续跟随ID: number;
  降临下降次数: number;
  圆神樱花特效: any;
}

interface 圆环强化状态 {
  英雄: any;
  层数: number;
  到期毫秒: number;
  版本: number;
  W立即满蓄: boolean;
}

interface 因果层状态 {
  来源: any;
  目标: any;
  到期毫秒列表: number[];
  满层下次触发毫秒: number;
}

interface 圆神普攻派生记录 {
  来源: any;
  目标: any;
  伤害: number;
  ranged: boolean;
}

const 圆神状态表: Record<number, 圆神状态 | undefined> = {};
const 圆环强化状态表: Record<number, 圆环强化状态 | undefined> = {};
const 因果层状态表: Record<string, 因果层状态 | undefined> = {};
const 圆神普攻派生队列: 圆神普攻派生记录[] = [];
const 圆环之理施法中表: Record<number, boolean | undefined> = {};

let 圆神状态版本 = 0;
let 圆环强化版本 = 0;
let 被动层数驱动已注册 = false;
let 共享状态已注册 = false;

function 因果层状态键(this: void, source: any, target: any): string {
  return String(取单位ID(source)) + "#" + String(取单位ID(target));
}

export function 是鹿目圆(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const typeId = GetUnitTypeId(unit);
  return typeId === 配置.单位.普通类型ID || typeId === 配置.单位.圆神类型ID;
}

export function 是鹿目圆圆神(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const state = 圆神状态表[取单位ID(unit)];
  return state != null && state.英雄 === unit && GetUnitTypeId(unit) === 配置.单位.圆神类型ID;
}

export function 鹿目圆伤害无视魔抗(this: void, unit: any): boolean {
  return 是鹿目圆圆神(unit);
}

export function 获取圆神剩余秒(this: void, unit: any): number {
  const state = 圆神状态表[取单位ID(unit)];
  if (state == null || state.英雄 !== unit) return 0;
  const remaining = state.到期毫秒 - getServerTime();
  return remaining > 0 ? remaining / 1000 : 0;
}

function 确保鹿目圆形态技能(this: void, hero: any): void {
  if (hero == null || hero === 0) return;
  const 技能 = 配置.技能;
  UnitAddAbility(hero, 技能.Q.类型ID);
  UnitAddAbility(hero, 技能.W蓄力.类型ID);
  UnitAddAbility(hero, 技能.W发射.类型ID);
  UnitAddAbility(hero, 技能.E.类型ID);
  UnitAddAbility(hero, 技能.D.类型ID);
  UnitAddAbility(hero, 技能.圆神入口.类型ID);
  UnitAddAbility(hero, 技能.圆神返回.类型ID);
  UnitAddAbility(hero, 技能.R.类型ID);
}

function 同步圆神技能可用性(this: void, hero: any, 圆神中: boolean, 降临已完成: boolean = true): void {
  if (hero == null || hero === 0) return;
  const owner = GetOwningPlayer(hero);
  const 技能 = 配置.技能;
  const 圆环之理施法中 = 圆环之理施法中表[取单位ID(hero)] === true;
  SetPlayerAbilityAvailable(owner, 技能.圆神入口.类型ID, !圆神中 && !圆环之理施法中);
  SetPlayerAbilityAvailable(owner, 技能.旧圆神入口.类型ID, !圆神中 && !圆环之理施法中);
  SetPlayerAbilityAvailable(owner, 技能.圆神返回.类型ID, 圆神中 && !圆环之理施法中);
  SetPlayerAbilityAvailable(owner, 技能.R.类型ID, 圆神中 && 降临已完成 && !圆环之理施法中);
  SetPlayerAbilityAvailable(owner, 技能.W蓄力.类型ID, true);
  SetPlayerAbilityAvailable(owner, 技能.W发射.类型ID, false);
}

/** R 成功后直到全部箭道与脉冲清理完成，都不恢复圆神入口技能。 */
export function 设置鹿目圆圆环之理施法状态(this: void, hero: any, 施法中: boolean): void {
  if (hero == null || hero === 0) return;
  const id = 取单位ID(hero);
  if (施法中) 圆环之理施法中表[id] = true;
  else delete 圆环之理施法中表[id];
  同步圆神技能可用性(hero, 是鹿目圆圆神(hero), true);
}

function 取圆神状态(this: void, hero: any): 圆神状态 | undefined {
  const state = 圆神状态表[取单位ID(hero)];
  return state != null && state.英雄 === hero ? state : undefined;
}

/** 源 JASS 的 1..6 循环：六个点特效位于中心点外 400 码，角度为 60° 的整数倍。 */
function 播放圆神降临点特效(this: void, state: 圆神状态, 创建环绕特效: boolean): void {
  const cfg = 配置.圆神;
  创建点特效({
    模型路径: cfg.降临中心特效路径,
    X: state.位置X,
    Y: state.位置Y,
    Z: cfg.降临中心高度,
    面向角度: cfg.降临面向角度,
    缩放: cfg.降临特效缩放,
    持续秒: cfg.降临特效持续秒,
    动画索引: 0,
  });
  if (!创建环绕特效) return;

  for (let i = 1; i <= 6; i++) {
    const radians = i * 60 * BJ_DEGTORAD;
    创建点特效({
      模型路径: cfg.降临环绕特效路径,
      X: state.位置X + cfg.降临环绕半径 * Cos(radians),
      Y: state.位置Y + cfg.降临环绕半径 * Sin(radians),
      Z: cfg.降临环绕高度,
      面向角度: cfg.降临面向角度,
      缩放: cfg.降临特效缩放,
      持续秒: cfg.降临特效持续秒,
    });
  }
}

function 圆神降临起始(this: void, variable?: any): void {
  const data = variable as { hero: any; version: number } | undefined;
  if (data == null) return;
  const state = 取圆神状态(data.hero);
  if (state == null || state.版本 !== data.version || state.阶段 !== "降临中") return;
  state.降临起始ID = 0;
  if (!单位存活(state.英雄) || GetUnitTypeId(state.英雄) !== 配置.单位.圆神类型ID) {
    结束鹿目圆圆神(state.英雄, "降临中断");
    return;
  }

  state.位置X = GetUnitX(state.英雄);
  state.位置Y = GetUnitY(state.英雄);
  UnitRemoveBuffsEx(state.英雄, false, true, false, false, false, false, true);
  ShowUnit(state.英雄, false);
  PauseUnit(state.英雄, true);
  播放圆神降临点特效(state, true);
  state.降临展示ID = addDelayedCallback(配置.圆神.降临展示延迟毫秒, 圆神降临展示英雄, state);
}

function 圆神降临展示英雄(this: void, variable?: any): void {
  const state = variable as 圆神状态 | undefined;
  if (state == null || 取圆神状态(state.英雄) !== state || state.阶段 !== "降临中") return;
  state.降临展示ID = 0;
  if (!单位存活(state.英雄) || GetUnitTypeId(state.英雄) !== 配置.单位.圆神类型ID) {
    结束鹿目圆圆神(state.英雄, "降临中断");
    return;
  }

  SetUnitPosition(state.英雄, state.位置X, state.位置Y);
  SetUnitInvulnerable(state.英雄, true);
  PauseUnit(state.英雄, false);
  ShowUnit(state.英雄, true);
  播放圆神降临点特效(state, false);
  确保单位可设置飞行高度(state.英雄);
  SetUnitFlyHeight(state.英雄, 1000, 0);
  state.降临下降次数 = 0;
  state.降临下降ID = addPeriodicCallback(配置.圆神.降临下降间隔毫秒, 圆神降临下降, state);
}

function 创建圆神樱花单位(this: void, state: 圆神状态): void {
  const shell = 创建单位并登记排泄安全(
    GetOwningPlayer(state.英雄),
    配置.单位壳.圆神樱花,
    state.位置X,
    state.位置Y,
    0,
  );
  if (shell == null || shell === 0) return;
  state.圆神樱花特效 = shell;
  SetUnitScale(shell, 配置.圆神.樱花缩放, 配置.圆神.樱花缩放, 配置.圆神.樱花缩放);
  确保单位可设置飞行高度(shell);
  SetUnitFlyHeight(shell, 配置.圆神.樱花高度, 0);
  SetUnitStateJapi(shell, UNIT_STATE_MAX_LIFE, 配置.圆神.樱花生命值);
  SetUnitState(shell, UNIT_STATE_LIFE, 配置.圆神.樱花生命值);
  UnitApplyTimedLife(shell, UNIT_TIMED_LIFE_BUFF, 配置.圆神.樱花持续秒);
  if (DzSetUnitModel != null) DzSetUnitModel(shell, 配置.圆神.樱花模型路径);
}

function 圆神降临下降(this: void, variable?: any): void {
  const state = variable as 圆神状态 | undefined;
  if (state == null || 取圆神状态(state.英雄) !== state || state.阶段 !== "降临中") return;
  if (state.降临下降次数 >= 配置.圆神.降临下降次数) {
    removePeriodicCallback(state.降临下降ID);
    state.降临下降ID = 0;
    SetUnitInvulnerable(state.英雄, false);
    SetUnitFlyHeight(state.英雄, 0, 0);
    创建圆神樱花单位(state);
    state.阶段 = "已完成";
    state.到期毫秒 = getServerTime() + 配置.圆神.持续秒 * 1000;
    state.状态到期ID = addDelayedCallback(配置.圆神.持续秒 * 1000, 圆神状态到期, { hero: state.英雄, version: state.版本 });
    state.持续跟随ID = addPeriodicCallback(100, 圆神持续跟随, state);
    同步圆神技能可用性(state.英雄, true, true);
    return;
  }
  state.降临下降次数 += 1;
  SetUnitFlyHeight(state.英雄, GetUnitFlyHeight(state.英雄) - 配置.圆神.降临下降步长, 0);
}

function 圆神持续跟随(this: void, variable?: any): void {
  const state = variable as 圆神状态 | undefined;
  if (state == null || 取圆神状态(state.英雄) !== state || state.阶段 !== "已完成") return;
  if (!单位存活(state.英雄) || GetUnitTypeId(state.英雄) !== 配置.单位.圆神类型ID) {
    结束鹿目圆圆神(state.英雄, "形态改变");
    return;
  }
  if (state.圆神樱花特效 != null && state.圆神樱花特效 !== 0 && GetUnitTypeId(state.圆神樱花特效) !== 0) {
    SetUnitPosition(state.圆神樱花特效, GetUnitX(state.英雄), GetUnitY(state.英雄));
  }
}

/** 源：进入/退出圆神时将攻击 1 基础值设为 15.00 + 智力×1.35。 */
function 设置圆神攻击力(this: void, hero: any): void {
  if (hero == null || hero === 0) return;
  const 目标攻击力 = 配置.圆神.攻击基础值 + jass.GetHeroInt(hero, false) * 配置.圆神.攻击智力系数;
  // 攻击基础值属于 JAPI 属性；普通 jass.SetUnitState 不能可靠写入替换形态后的攻击值。
  SetUnitStateJapi(hero, UNIT_STATE_ATTACK1_BASE, 目标攻击力);
}

function 圆神状态到期(this: void, variable?: any): void {
  const data = variable as { hero: any; version: number } | undefined;
  if (data == null) return;
  const state = 圆神状态表[取单位ID(data.hero)];
  if (state == null || state.版本 !== data.version) return;
  state.状态到期ID = 0;
  结束鹿目圆圆神(data.hero, "自然到期");
}

export function 进入鹿目圆圆神(this: void, hero: any): boolean {
  if (!单位存活(hero) || GetUnitTypeId(hero) !== 配置.单位.普通类型ID) {
    return false;
  }
  if (是鹿目圆圆神(hero)) {
    return false;
  }

  确保鹿目圆形态技能(hero);
  DzSetUnitID(hero, 配置.单位.圆神类型ID);
  确保鹿目圆形态技能(hero);
  const state: 圆神状态 = {
    英雄: hero,
    到期毫秒: 0,
    版本: ++圆神状态版本,
    阶段: "降临中",
    位置X: GetUnitX(hero),
    位置Y: GetUnitY(hero),
    降临起始ID: 0,
    降临展示ID: 0,
    降临下降ID: 0,
    状态到期ID: 0,
    持续跟随ID: 0,
    降临下降次数: 0,
    圆神樱花特效: null,
  };
  圆神状态表[取单位ID(hero)] = state;
  // 源 A0FR：进入圆神时攻击 1 基础值设为 15+智力×1.35。
  设置圆神攻击力(hero);
  调整玩家属性(hero, "魔法伤害", 配置.圆神.魔法伤害加成);
  移除单位负面Buff(hero, true);
  registerManualBuff(hero, 鹿目圆BuffID.圆神之力, 配置.圆神.持续秒 + 配置.圆神.降临Buff额外持续秒, 配置.圆神.魔法伤害加成, {
    sourceUnit: hero,
    stack: 1,
  });
  同步圆神技能可用性(hero, true, false);
  state.降临起始ID = addDelayedCallback(配置.圆神.降临起始延迟毫秒, 圆神降临起始, { hero, version: state.版本 });
  return true;
}

export function 结束鹿目圆圆神(this: void, hero: any, 原因: string = "结束"): void {
  if (hero == null || hero === 0) return;
  const id = 取单位ID(hero);
  const state = 圆神状态表[id];
  if (state == null && GetUnitTypeId(hero) !== 配置.单位.圆神类型ID) return;

  移除单位指定Buff(hero, 鹿目圆BuffID.圆神之力);
  if (state != null) {
    if (state.降临起始ID !== 0) {
      removeDelayedCallback(state.降临起始ID);
      state.降临起始ID = 0;
    }
    if (state.降临展示ID !== 0) {
      removeDelayedCallback(state.降临展示ID);
      state.降临展示ID = 0;
    }
    if (state.降临下降ID !== 0) {
      removePeriodicCallback(state.降临下降ID);
      state.降临下降ID = 0;
    }
    if (state.状态到期ID !== 0) {
      removeDelayedCallback(state.状态到期ID);
      state.状态到期ID = 0;
    }
    if (state.持续跟随ID !== 0) {
      removePeriodicCallback(state.持续跟随ID);
      state.持续跟随ID = 0;
    }
    if (state.圆神樱花特效 != null && state.圆神樱花特效 !== 0 && GetUnitTypeId(state.圆神樱花特效) !== 0) {
      立即移除单位并取消排泄登记(state.圆神樱花特效);
      state.圆神樱花特效 = null;
    }
    if (state.阶段 === "降临中") {
      SetUnitInvulnerable(hero, false);
      PauseUnit(hero, false);
      ShowUnit(hero, true);
      if (单位存活(hero)) {
        确保单位可设置飞行高度(hero);
        SetUnitFlyHeight(hero, GetUnitDefaultFlyHeight(hero), 0);
      }
    }
    调整玩家属性(hero, "魔法伤害", -配置.圆神.魔法伤害加成);
    delete 圆神状态表[id];
  }
  if (GetUnitTypeId(hero) === 配置.单位.圆神类型ID) {
    DzSetUnitID(hero, 配置.单位.普通类型ID);
  }
  // 源 Func014T：圆神自然结束时恢复攻击 1 基础值；R 结束也必须保留有效攻击值。
  if (原因 !== "死亡") 设置圆神攻击力(hero);
  确保鹿目圆形态技能(hero);
  同步圆神技能可用性(hero, false);
}

function 获取圆神入口上下文(this: void, hero: any): { 英雄: any } | undefined {
  return GetUnitTypeId(hero) === 配置.单位.普通类型ID ? { 英雄: hero } : undefined;
}

function 释放圆神入口(this: void, _context: { 英雄: any }, hero: any): void {
  if (!进入鹿目圆圆神(hero)) return;
  SetUnitAnimation(hero, "spell");
}

function 获取圆神返回上下文(this: void, hero: any): { 英雄: any } | undefined {
  return 是鹿目圆圆神(hero) ? { 英雄: hero } : undefined;
}

function 释放圆神返回(this: void, _context: { 英雄: any }, hero: any): void {
  结束鹿目圆圆神(hero, "主动返回");
}

function 刷新圆环强化Buff(this: void, state: 圆环强化状态): void {
  const hero = state.英雄;
  const now = getServerTime();
  const remaining = (state.到期毫秒 - now) / 1000;
  移除单位指定Buff(hero, 鹿目圆BuffID.圆环之力一次强化);
  移除单位指定Buff(hero, 鹿目圆BuffID.圆环之力二次强化);
  if (state.层数 <= 0 || !(remaining > 0)) return;
  const buffId = state.层数 >= 2 ? 鹿目圆BuffID.圆环之力二次强化 : 鹿目圆BuffID.圆环之力一次强化;
  registerManualBuff(hero, buffId, remaining, state.层数, {
    sourceUnit: hero,
    stack: state.层数,
  });
}

function 圆环强化到期(this: void, variable?: any): void {
  const data = variable as { hero: any; version: number } | undefined;
  if (data == null) return;
  const state = 圆环强化状态表[取单位ID(data.hero)];
  if (state == null || state.版本 !== data.version) return;
  清除鹿目圆圆环强化(data.hero);
}

export function 激活鹿目圆圆环强化(this: void, hero: any): number {
  if (!单位存活(hero) || !是鹿目圆(hero)) {
    return 0;
  }
  const now = getServerTime();
  const id = 取单位ID(hero);
  let state = 圆环强化状态表[id];
  if (state == null || state.到期毫秒 <= now) {
    // 源：3s 窗口外首次施放，hit=1（无额外蓝耗）
    state = {
      英雄: hero,
      层数: 1,
      到期毫秒: now + 配置.D.持续秒 * 1000,
      版本: ++圆环强化版本,
      W立即满蓄: 是鹿目圆圆神(hero),
    };
    圆环强化状态表[id] = state;
  } else {
    // 源：3s 窗口内再次施放 → hit+1 并刷新 3s 窗口；从第2次起每次(≥2)扣 8% 蓝（由 D 技能结算）
    state.层数 += 1;
    state.到期毫秒 = now + 配置.D.持续秒 * 1000;
    state.版本 = ++圆环强化版本;
    if (是鹿目圆圆神(hero)) state.W立即满蓄 = true;
  }
  刷新圆环强化Buff(state);
  const 剩余毫秒 = state.到期毫秒 - now;
  addDelayedCallback(剩余毫秒 >= 1 ? 剩余毫秒 : 1, 圆环强化到期, { hero, version: state.版本 });
  return state.层数;
}

export function 获取鹿目圆圆环强化层数(this: void, hero: any): number {
  const state = 圆环强化状态表[取单位ID(hero)];
  if (state == null || state.到期毫秒 <= getServerTime()) return 0;
  return state.层数;
}

export function 消耗鹿目圆圆环强化(this: void, hero: any): number {
  const state = 圆环强化状态表[取单位ID(hero)];
  if (state == null || state.到期毫秒 <= getServerTime()) {
    return 0;
  }
  const layers = state.层数;
  清除鹿目圆圆环强化(hero);
  return layers;
}

export function 消耗鹿目圆W立即满蓄标记(this: void, hero: any): boolean {
  const state = 圆环强化状态表[取单位ID(hero)];
  if (state == null || state.到期毫秒 <= getServerTime() || state.W立即满蓄 !== true) return false;
  state.W立即满蓄 = false;
  return true;
}

export function 清除鹿目圆圆环强化(this: void, hero: any): void {
  if (hero == null || hero === 0) return;
  delete 圆环强化状态表[取单位ID(hero)];
  移除单位指定Buff(hero, 鹿目圆BuffID.圆环之力一次强化);
  移除单位指定Buff(hero, 鹿目圆BuffID.圆环之力二次强化);
}

function 刷新因果层Buff(this: void, state: 因果层状态): void {
  const count = state.到期毫秒列表.length;
  if (count <= 0) {
    移除单位指定Buff(state.目标, 鹿目圆BuffID.因果之力);
    return;
  }
  const now = getServerTime();
  let maxExpiry = now;
  for (let i = 0; i < state.到期毫秒列表.length; i++) {
    if (state.到期毫秒列表[i] > maxExpiry) maxExpiry = state.到期毫秒列表[i];
  }
  const 剩余秒 = (maxExpiry - now) / 1000;
  registerManualBuff(state.目标, 鹿目圆BuffID.因果之力, 剩余秒 >= 0.1 ? 剩余秒 : 0.1, 配置.被动.每层攻速, {
    sourceUnit: state.来源,
    stack: count,
  });
}

function 触发因果满层(this: void, state: 因果层状态): void {
  const now = getServerTime();
  if (state.到期毫秒列表.length < 配置.被动.最大层数 || now < state.满层下次触发毫秒) return;
  state.满层下次触发毫秒 = now + 配置.被动.满层触发内置冷却秒 * 1000;
  移除单位负面Buff(state.目标, false);
  const maxLife = GetUnitStateJapi(state.目标, UNIT_STATE_MAX_LIFE);
  if (maxLife > 0) {
    doHeal({
      HealSource: state.来源,
      HealTarget: state.目标,
      HealAmount: maxLife * 配置.被动.满层治疗最大生命比例,
      ItemHeal: false,
      HealEffect: true,
      HealShowText: true,
    });
  }
}

export function 鹿目圆治疗友军(this: void, source: any, target: any, life: number, mana: number = 0, 叠加因果: boolean = true): number {
  if (!单位存活(source) || !单位存活(target)) return 0;
  const actual = doHeal({
    HealSource: source,
    HealTarget: target,
    HealAmount: life,
    HealManaAmount: mana,
    ItemHeal: false,
    HealEffect: life > 0,
    HealShowText: life > 0,
    ManaEffect: mana > 0,
    ManaShowText: mana > 0,
  });
  if (actual > 0 && 叠加因果 && 是鹿目圆(source) && IsUnitAlly(target, GetOwningPlayer(source)) === true) {
    添加鹿目圆因果层(source, target);
  }
  return actual;
}

export function 添加鹿目圆因果层(this: void, source: any, target: any): void {
  if (!单位存活(source) || !单位存活(target)) return;
  const key = 因果层状态键(source, target);
  let state = 因果层状态表[key];
  if (state == null) {
    state = {
      来源: source,
      目标: target,
      到期毫秒列表: [],
      满层下次触发毫秒: 0,
    };
    因果层状态表[key] = state;
  }
  if (state.到期毫秒列表.length < 配置.被动.最大层数) {
    state.到期毫秒列表.push(getServerTime() + 配置.被动.单层持续秒 * 1000);
    临时调整攻速(target, 配置.被动.每层攻速);
  }
  刷新因果层Buff(state);
  触发因果满层(state);
}

function 清理因果层状态(this: void, key: string, state: 因果层状态): void {
  const count = state.到期毫秒列表.length;
  if (count > 0 && state.目标 != null && state.目标 !== 0) {
    临时调整攻速(state.目标, -配置.被动.每层攻速 * count);
  }
  移除单位指定Buff(state.目标, 鹿目圆BuffID.因果之力);
  delete 因果层状态表[key];
}

function 推进鹿目圆因果层(this: void): void {
  const now = getServerTime();
  for (const key in 因果层状态表) {
    const state = 因果层状态表[key];
    if (state == null) continue;
    if (!单位存活(state.来源) || !单位存活(state.目标)) {
      清理因果层状态(key, state);
      continue;
    }
    let removed = 0;
    const kept: number[] = [];
    for (let i = 0; i < state.到期毫秒列表.length; i++) {
      if (state.到期毫秒列表[i] <= now) removed += 1;
      else kept.push(state.到期毫秒列表[i]);
    }
    if (removed > 0) {
      state.到期毫秒列表 = kept;
      临时调整攻速(state.目标, -配置.被动.每层攻速 * removed);
      if (kept.length <= 0) {
        清理因果层状态(key, state);
        continue;
      }
      刷新因果层Buff(state);
    }
  }
}

function 结算圆神普攻派生队列(this: void): void {
  while (圆神普攻派生队列.length > 0) {
    const record = 圆神普攻派生队列.shift();
    if (record == null || !单位存活(record.来源) || !单位存活(record.目标)) continue;
    造成单体技能伤害({
      来源: record.来源,
      目标: record.目标,
      伤害: record.伤害,
      伤害类型: DAMAGE_TYPE_MAGIC,
      attack: true,
      ranged: record.ranged,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "普攻强化",
      技能ID: 配置.技能.圆神入口.类型ID,
      标签: "鹿目圆-圆神魔法普攻",
      参与技能伤害加成: false,
      忽略魔法抗性: true,
    });
  }
}

function 圆神普攻伤害修正(this: void, context: any): number {
  const attacker = context?.attacker;
  if (!是鹿目圆圆神(attacker)) return context?.currentDamage ?? 0;
  if (context?.isNormalAttack !== true || context?.isPhysicalDamage !== true) return context.currentDamage;
  if (context?.isWrappedSkillDamage === true) return context.currentDamage;
  const target = context.target;
  const amount = context.baseDamage;
  if (target == null || target === 0 || !(amount > 0)) return 0;
  圆神普攻派生队列.push({
    来源: attacker,
    目标: target,
    伤害: amount,
    ranged: context.isRangedAttack === true,
  });
  延后一帧执行伤害派生效果(结算圆神普攻派生队列);
  return 0;
}

function 鹿目圆死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (!是鹿目圆(dyingUnit)) return;
  结束鹿目圆圆神(dyingUnit, "死亡");
  清除鹿目圆圆环强化(dyingUnit);
  for (const key in 因果层状态表) {
    const state = 因果层状态表[key];
    if (state == null) continue;
    if (state.来源 === dyingUnit || state.目标 === dyingUnit) 清理因果层状态(key, state);
  }
}

export function 注册鹿目圆状态与被动(this: void): void {
  if (共享状态已注册) return;
  共享状态已注册 = true;
  const 技能 = 配置.技能;
  注册单位技能壳监听({
    名称: "鹿目圆-进入圆神",
    单位类型ID: 配置.单位.普通类型ID,
    技能ID: 技能.圆神入口.类型ID,
    获取或创建上下文: 获取圆神入口上下文,
    释放技能: 释放圆神入口,
    创建独立技能实例: false,
  });
  注册单位技能壳监听({
    名称: "鹿目圆-进入圆神（旧入口）",
    单位类型ID: 配置.单位.普通类型ID,
    技能ID: 技能.旧圆神入口.类型ID,
    获取或创建上下文: 获取圆神入口上下文,
    释放技能: 释放圆神入口,
    创建独立技能实例: false,
  });
  注册单位技能壳监听({
    名称: "鹿目圆-结束圆神",
    单位类型ID: 配置.单位.圆神类型ID,
    技能ID: 技能.圆神返回.类型ID,
    获取或创建上下文: 获取圆神返回上下文,
    释放技能: 释放圆神返回,
    创建独立技能实例: false,
  });
  registerDamageModifier(圆神普攻伤害修正, 100);
  registerDeathListener(鹿目圆死亡清理);
  if (!被动层数驱动已注册) {
    被动层数驱动已注册 = true;
    addPeriodicCallback(100, 推进鹿目圆因果层);
  }
}

注册鹿目圆状态与被动();

export {};
