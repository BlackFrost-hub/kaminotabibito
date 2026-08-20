/** @noSelfInFile */

import { 克劳德单位技能配置 } from "./00．配置";
import { 清理空牙Q联动, 读取凶斩命中, 设置空牙Q联动 } from "./00A．联动状态";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const { 开始冲锋, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, 参数: any) => number;
  停止位移: (this: void, id: number, reason?: string) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 确保单位可设置飞行高度 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享") as {
  确保单位可设置飞行高度: (this: void, unit: any) => void;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (unit: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块名: string, ...参数: any[]) => void;
};
const 模块名 = "克劳德-W";
const jglobals = require("jass.globals") as any;
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, unit: any) => void;
};

const 获取句柄ID = jass.GetHandleId as (this: void, handle: any) => number;
const 获取单位类型ID = jass.GetUnitTypeId as (this: void, unit: any) => number;
const 获取单位X = jass.GetUnitX as (this: void, unit: any) => number;
const 获取单位Y = jass.GetUnitY as (this: void, unit: any) => number;
const 获取单位面向 = jass.GetUnitFacing as (this: void, unit: any) => number;
const 获取随机实数 = jass.GetRandomReal as (this: void, low: number, high: number) => number;
const 获取单位Z = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const 设置单位X = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const 设置单位Y = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const 设置单位Z = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const 获取默认高度 = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const 设置动作 = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const 设置动作名 = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const 设置时间流速 = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const 设置技能可用 = jass.SetPlayerAbilityAvailable as (this: void, player: any, skillId: number, available: boolean) => void;
const 添加技能 = jass.UnitAddAbility as (this: void, unit: any, skillId: number) => boolean;
const 移除技能 = jass.UnitRemoveAbility as (this: void, unit: any, skillId: number) => boolean;
const 获取单位拥有者 = jass.GetOwningPlayer as (this: void, unit: any) => any;
const 获取技能目标X = jass.GetSpellTargetX as (this: void) => number;
const 获取技能目标Y = jass.GetSpellTargetY as (this: void) => number;
const 获取单位状态 = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const 判断敌人 = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const 判断类型 = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const 判断地形 = jass.IsTerrainPathable as (this: void, x: number, y: number, pathType: any) => boolean;
const 计算余弦 = jass.Cos as (this: void, radians: number) => number;
const 计算正弦 = jass.Sin as (this: void, radians: number) => number;
const 计算反正切 = jass.Atan2 as (this: void, y: number, x: number) => number;
const 角度转弧度 = jass.bj_DEGTORAD as number;
const 弧度转角度 = jass.bj_RADTODEG as number;
const 最大生命状态 = jass.UNIT_STATE_MAX_LIFE as any;
const 当前生命状态 = jass.UNIT_STATE_LIFE as any;
const 最大魔法状态 = jass.UNIT_STATE_MAX_MANA as any;
const 当前魔法状态 = jass.UNIT_STATE_MANA as any;
const 古树类型 = jass.UNIT_TYPE_ANCIENT as any;
const 机械类型 = jass.UNIT_TYPE_MECHANICAL as any;
const 可行走类型 = jass.PATHING_TYPE_WALKABILITY as any;
const 攻击类型 = jass.ATTACK_TYPE_NORMAL as any;
const 物理伤害类型 = jass.DAMAGE_TYPE_NORMAL as any;
const 强化伤害类型 = jass.DAMAGE_TYPE_ENHANCED as any;

const 配置 = 克劳德单位技能配置.W;
const 单位类型ID = stringToFourCCSafe(克劳德单位技能配置.单位ID);
const 初段技能ID = stringToFourCCSafe(配置.初段技能ID);
const 二段技能ID = stringToFourCCSafe(配置.二段技能ID);
const 三段技能ID = stringToFourCCSafe(配置.三段技能ID);
const 冲锋特效A单位ID = stringToFourCCSafe(配置.冲锋特效A单位ID);
const 冲锋特效B单位ID = stringToFourCCSafe(配置.冲锋特效B单位ID);
const 二段刀光单位ID = stringToFourCCSafe(配置.二段刀光单位ID);
const 命中刀光单位ID = stringToFourCCSafe(配置.命中刀光单位ID);
const 来源前缀 = "克劳德-W";
const 金属重斩武器类型 = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;

function 播放W音效(this: void, caster: any, key: string): void {
  const sound = jglobals[key];
  if (sound != null) PlaySoundOnUnitBJ(sound, 100, caster);
}

interface W表现单位记录 {
  单位: any;
  已移除: boolean;
}

function 移除W表现单位(this: void, variable?: any): void {
  const record = variable as W表现单位记录 | undefined;
  if (record == null || record.已移除) return;
  record.已移除 = true;
  if (record.单位 != null && record.单位 !== 0) 立即移除单位并取消排泄登记(record.单位);
}

function 创建W表现单位(this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number, duration: number): W表现单位记录 | null {
  const unit = 创建单位并登记排泄安全(owner, unitTypeId, x, y, facing);
  if (unit == null || unit === 0) return null;
  const record: W表现单位记录 = { 单位: unit, 已移除: false };
  if (duration > 0) {
    addDelayedCallback(duration * 1000, 移除W表现单位 as unknown as (this: void, variable?: any) => void, record);
  }
  return record;
}

function 设置W表现单位高度(this: void, record: W表现单位记录 | null, height: number): void {
  if (record == null || record.已移除 || record.单位 == null || record.单位 === 0) return;
  设置单位Z(record.单位, height, 0);
}

interface 克劳德W状态 {
  施法者: any;
  阶段: 0 | 1 | 2;
  进行中: boolean;
  等待输入: boolean;
  方向角: number;
  目标X: number;
  目标Y: number;
  技能实例ID?: number;
  位移ID: number;
  周期ID: number;
  Tick数: number;
  命中目标: any[];
  冲锋特效A: W表现单位记录 | null;
  冲锋特效B: W表现单位记录 | null;
  冲锋特效周期ID: number;
  冲锋特效Tick数: number;
}

const 状态表: Record<number, 克劳德W状态 | undefined> = {};

function 获取或创建W状态(this: void, unit: any): 克劳德W状态 {
  const id = 获取句柄ID(unit);
  let state = 状态表[id];
  if (state == null) {
    state = {
      施法者: unit, 阶段: 0, 进行中: false, 等待输入: false,
      方向角: 0, 目标X: 0, 目标Y: 0, 位移ID: 0, 周期ID: 0, Tick数: 0, 命中目标: [],
      冲锋特效A: null, 冲锋特效B: null, 冲锋特效周期ID: 0, 冲锋特效Tick数: 0,
    };
    状态表[id] = state;
  }
  return state;
}

function 目标合法(this: void, caster: any, target: any): boolean {
  return target != null && target !== 0 && 单位存活(target)
    && target !== caster
    && 判断敌人(target, 获取单位拥有者(caster))
    && !判断类型(target, 古树类型)
    && !判断类型(target, 机械类型);
}

function 目标未命中(this: void, state: 克劳德W状态, target: any): boolean {
  const targetId = 获取句柄ID(target);
  for (const old of state.命中目标) {
    if (获取句柄ID(old) === targetId) return false;
  }
  return true;
}

function 造成W伤害(this: void, state: 克劳德W状态, target: any, 倍率: number): void {
  const caster = state.施法者;
  if (!目标合法(caster, target)) return;
  造成单体技能伤害({
    来源: caster,
    目标: target,
    伤害: 读取单位攻击力(caster) * 倍率,
    伤害类型: 物理伤害类型,
    attack: true,
    ranged: false,
    attackType: 攻击类型,
    weaponType: 金属重斩武器类型,
    来源类型: "单位技能",
    技能ID: 初段技能ID,
    技能实例ID: state.技能实例ID,
    标签: `${来源前缀}-${state.阶段 + 1}段`,
  });
  if (state.阶段 === 2 && 读取凶斩命中(caster, target)) {
    const maxLife = 获取单位状态(target, 最大生命状态) || 0;
    const currentLife = 获取单位状态(target, 当前生命状态) || 0;
    const lostLife = maxLife > currentLife ? maxLife - currentLife : 0;
    if (lostLife > 0) {
      造成单体技能伤害({
        来源: caster,
        目标: target,
        伤害: lostLife * 配置.凶斩联动已损失生命比例,
        伤害类型: 强化伤害类型,
        attack: true,
        ranged: false,
        attackType: 攻击类型,
        来源类型: "单位技能",
        技能ID: 初段技能ID,
        技能实例ID: state.技能实例ID,
        标签: "克劳德-W-凶斩联动强化伤害",
      });
    }
  }
}

function W初段命中过滤(this: void, movingUnit: any, target: any, _moveId: number): boolean {
  const state = 状态表[获取句柄ID(movingUnit)];
  return state != null && state.阶段 === 0 && 目标合法(movingUnit, target) && 目标未命中(state, target);
}

function W初段命中(this: void, movingUnit: any, target: any, _moveId: number): void {
  const state = 状态表[获取句柄ID(movingUnit)];
  if (state == null || !目标合法(movingUnit, target) || !目标未命中(state, target)) return;
  state.命中目标.push(target);
  造成W伤害(state, target, 配置.初段伤害倍率);
  施加眩晕(movingUnit, target, 配置.初段控制秒, `${来源前缀}-初段硬直`, "技能");
  设置动作名(target, "Death");
}

function 清理W一段表现(this: void, state: 克劳德W状态): void {
  if (state.冲锋特效周期ID !== 0) {
    removePeriodicCallback(state.冲锋特效周期ID);
    state.冲锋特效周期ID = 0;
  }
  移除W表现单位(state.冲锋特效A);
  移除W表现单位(state.冲锋特效B);
  state.冲锋特效A = null;
  state.冲锋特效B = null;
  state.冲锋特效Tick数 = 0;
}

function 停止W一段表现跟随(this: void, state: 克劳德W状态): void {
  if (state.冲锋特效周期ID !== 0) {
    removePeriodicCallback(state.冲锋特效周期ID);
    state.冲锋特效周期ID = 0;
  }
  state.冲锋特效A = null;
  state.冲锋特效B = null;
  state.冲锋特效Tick数 = 0;
}

interface W目标高度恢复参数 {
  目标列表: any[];
}

function W三段目标高度恢复(this: void, variable?: any): void {
  const 参数 = variable as W目标高度恢复参数 | undefined;
  if (参数 == null) return;
  for (const target of 参数.目标列表) {
    if (单位存活(target)) 设置单位Z(target, 获取默认高度(target), 0);
  }
}

function 清理W壳(this: void, caster: any): void {
  const owner = 获取单位拥有者(caster);
  设置技能可用(owner, 初段技能ID, true);
  移除技能(caster, 二段技能ID);
  移除技能(caster, 三段技能ID);
}

function 清理W状态(this: void, state: 克劳德W状态, 目标高度恢复延迟秒: number = 0): void {
  const caster = state.施法者;
  debugLogForce(模块名, "清理W状态", "施法者", caster == null || caster === 0 ? "nil" : 获取句柄ID(caster), "阶段", state.阶段, "位移ID", state.位移ID, "周期ID", state.周期ID, "Tick数", state.Tick数);
  if (state.位移ID !== 0) {
    停止位移(state.位移ID, "中断");
    state.位移ID = 0;
  }
  if (state.周期ID !== 0) {
    removePeriodicCallback(state.周期ID);
    state.周期ID = 0;
  }
  清理W一段表现(state);
  if (caster != null && caster !== 0) {
    清理空牙Q联动(caster);
    移除单位暂停(caster, `${来源前缀}-自身`);
    设置时间流速(caster, 1);
    设置单位Z(caster, 获取默认高度(caster), 0);
    清理W壳(caster);
  }
  if (目标高度恢复延迟秒 > 0) {
    const 目标列表: any[] = [];
    for (const target of state.命中目标) {
      if (!单位存活(target)) continue;
      设置单位Z(target, 0, 0);
      目标列表.push(target);
    }
    if (目标列表.length > 0) {
      const 参数: W目标高度恢复参数 = { 目标列表 };
      addDelayedCallback(目标高度恢复延迟秒 * 1000, W三段目标高度恢复 as unknown as (this: void, variable?: any) => void, 参数);
    }
  } else {
    for (const target of state.命中目标) {
      if (单位存活(target)) 设置单位Z(target, 获取默认高度(target), 0);
    }
  }
  state.进行中 = false;
  state.等待输入 = false;
  state.阶段 = 0;
  state.Tick数 = 0;
  state.命中目标 = [];
  if (caster != null && caster !== 0) {
    const id = 获取句柄ID(caster);
    if (状态表[id] === state) delete 状态表[id];
  }
}

function W二段窗口超时(this: void, state: 克劳德W状态): void {
  debugLogForce(模块名, "W二段窗口超时", "进行中", state?.进行中, "等待输入", state?.等待输入, "阶段", state?.阶段);
  if (state != null && state.进行中 && state.等待输入 && state.阶段 === 0) 清理W状态(state);
}

function W三段窗口超时(this: void, state: 克劳德W状态): void {
  debugLogForce(模块名, "W三段窗口超时", "进行中", state?.进行中, "等待输入", state?.等待输入, "阶段", state?.阶段);
  if (state != null && state.进行中 && state.等待输入 && state.阶段 === 1) 清理W状态(state);
}

function W初段结束(this: void, caster: any, _reason: string, _moveId: number): void {
  const state = 状态表[获取句柄ID(caster)];
  debugLogForce(模块名, "W初段结束", "施法者", 获取句柄ID(caster), "原因", _reason, "状态存在", state != null, "进行中", state?.进行中, "阶段", state?.阶段);
  if (state == null || !state.进行中 || state.阶段 !== 0) return;
  state.位移ID = 0;
  if (_reason !== "完成" && _reason !== "撞墙") {
    清理W状态(state);
    return;
  }
  停止W一段表现跟随(state);
  state.等待输入 = true;
  移除单位暂停(caster, `${来源前缀}-自身`);
  设置时间流速(caster, 1);
  设置技能可用(获取单位拥有者(caster), 初段技能ID, false);
  添加技能(caster, 二段技能ID);
  addDelayedCallback(配置.二段窗口秒 * 1000, W二段窗口超时 as unknown as (this: void, variable?: any) => void, state);
}

function 设置W表现单位位置(this: void, record: W表现单位记录 | null, x: number, y: number): void {
  if (record == null || record.已移除 || record.单位 == null || record.单位 === 0) return;
  设置单位X(record.单位, x);
  设置单位Y(record.单位, y);
}

function W一段表现帧(this: void, state: 克劳德W状态, 同步特效位置: boolean): void {
  if (!单位存活(state.施法者)) return;
  state.冲锋特效Tick数 += 1;
  const caster = state.施法者;
  const casterX = 获取单位X(caster);
  const casterY = 获取单位Y(caster);
  创建点特效({
    模型路径: 配置.沿途爆炸模型,
    X: casterX,
    Y: casterY,
    Z: 获取单位Z(caster),
    持续秒: 配置.沿途爆炸持续秒,
  });
  if (同步特效位置) {
    const radians = state.方向角 * 角度转弧度;
    const effectX = casterX + 计算余弦(radians) * 配置.冲锋特效起点偏移;
    const effectY = casterY + 计算正弦(radians) * 配置.冲锋特效起点偏移;
    设置W表现单位位置(state.冲锋特效A, effectX, effectY);
    设置W表现单位位置(state.冲锋特效B, effectX, effectY);
  }
  for (const target of state.命中目标) {
    if (!单位存活(target)) continue;
    W移动单位(target, state.方向角, 配置.冲锋特效每Tick距离, false);
  }
}

function W一段表现Tick(this: void, variable?: any): void {
  const state = variable as 克劳德W状态 | undefined;
  if (state == null || !state.进行中 || state.阶段 !== 0 || !单位存活(state.施法者)) {
    if (state != null) 清理W一段表现(state);
    return;
  }
  W一段表现帧(state, true);
}

function 启动W一段表现(this: void, state: 克劳德W状态): void {
  const caster = state.施法者;
  const radians = state.方向角 * 角度转弧度;
  const x = 获取单位X(caster) + 计算余弦(radians) * 配置.冲锋特效起点偏移;
  const y = 获取单位Y(caster) + 计算正弦(radians) * 配置.冲锋特效起点偏移;
  const owner = 获取单位拥有者(caster);
  state.冲锋特效A = 创建W表现单位(owner, 冲锋特效A单位ID, x, y, state.方向角, 配置.冲锋特效持续秒);
  state.冲锋特效B = 创建W表现单位(owner, 冲锋特效B单位ID, x, y, state.方向角, 配置.冲锋特效持续秒);
  设置W表现单位高度(state.冲锋特效A, 获取单位Z(caster));
  设置W表现单位高度(state.冲锋特效B, 获取单位Z(caster));
  state.冲锋特效Tick数 = 0;
  state.冲锋特效周期ID = addPeriodicCallback(配置.二段周期秒 * 1000, W一段表现Tick as unknown as (this: void, variable?: any) => void, state);
}

function W一段启动(this: void, state: 克劳德W状态): void {
  if (!state.进行中 || !单位存活(state.施法者)) {
    debugLogForce(模块名, "W一段启动 前置不满足 清理", "进行中", state.进行中, "施法者存活", 单位存活(state.施法者));
    清理W状态(state);
    return;
  }
  播放W音效(state.施法者, 配置.初段音效键);
  移除单位暂停(state.施法者, `${来源前缀}-自身`);
  启动W一段表现(state);
  state.位移ID = 开始冲锋(state.施法者, {
    角度: state.方向角,
    距离: 配置.冲锋距离,
    持续时间: 配置.冲锋持续秒,
    检查地形: true,
    朝向跟随位移: true,
    暂停单位: true,
    禁用碰撞: true,
    命中半径: 配置.碰撞半径,
    只命中敌人: true,
    允许重复命中: false,
    命中后结束: false,
    命中过滤: W初段命中过滤,
    命中回调: W初段命中,
    结束回调: W初段结束,
    位移特效: "",
    附加位移特效: "",
    动画名: 配置.初段动作名,
  });
  debugLogForce(模块名, "W一段启动 冲锋创建", "施法者", 获取句柄ID(state.施法者), "位移ID", state.位移ID, "方向角", state.方向角, "距离", 配置.冲锋距离);
  if (state.位移ID === 0) 清理W状态(state);
}

function W移动单位(this: void, unit: any, angle: number, distance: number, 检查地形: boolean = true): boolean {
  if (unit == null || unit === 0 || !单位存活(unit)) return false;
  const x = 获取单位X(unit) + 计算余弦(angle * 角度转弧度) * distance;
  const y = 获取单位Y(unit) + 计算正弦(angle * 角度转弧度) * distance;
  if (!检查地形 || !判断地形(x, y, 可行走类型)) {
    设置单位X(unit, x);
    设置单位Y(unit, y);
    return true;
  }
  return false;
}

function W二段Tick(this: void, variable?: any): void {
  const state = variable as 克劳德W状态 | undefined;
  if (state == null || !state.进行中 || state.阶段 !== 1 || !单位存活(state.施法者)) {
    debugLogForce(模块名, "W二段Tick 前置不满足", "状态存在", state != null, "进行中", state?.进行中, "阶段", state?.阶段, "施法者存活", state?.施法者 == null ? false : 单位存活(state.施法者));
    if (state != null) 清理W状态(state);
    return;
  }
  state.Tick数 += 1;
  确保单位可设置飞行高度(state.施法者);
  if (W移动单位(state.施法者, state.方向角, 配置.二段移动距离)) {
    设置单位Z(state.施法者, 获取单位Z(state.施法者) + 配置.二段升高距离, 0);
    for (const target of state.命中目标) {
      if (!单位存活(target)) continue;
      确保单位可设置飞行高度(target);
      W移动单位(target, state.方向角, 配置.二段移动距离, false);
      设置单位Z(target, 获取单位Z(target) + 配置.二段升高距离, 0);
    }
  }
  if (state.Tick数 >= 配置.二段Tick数) {
    debugLogForce(模块名, "W二段Tick 完成 进入等待三段", "施法者", 获取句柄ID(state.施法者), "Tick数", state.Tick数, "命中目标数", state.命中目标.length);
    removePeriodicCallback(state.周期ID);
    state.周期ID = 0;
    state.Tick数 = 0;
    state.阶段 = 1;
    state.等待输入 = true;
    移除单位暂停(state.施法者, `${来源前缀}-自身`);
    设置时间流速(state.施法者, 1);
    添加技能(state.施法者, 三段技能ID);
    addDelayedCallback(配置.三段窗口秒 * 1000, W三段窗口超时 as unknown as (this: void, variable?: any) => void, state);
  }
}

function W三段Tick(this: void, variable?: any): void {
  const state = variable as 克劳德W状态 | undefined;
  if (state == null || !state.进行中 || state.阶段 !== 2 || !单位存活(state.施法者)) {
    debugLogForce(模块名, "W三段Tick 前置不满足", "状态存在", state != null, "进行中", state?.进行中, "阶段", state?.阶段, "施法者存活", state?.施法者 == null ? false : 单位存活(state.施法者));
    if (state != null) 清理W状态(state);
    return;
  }
  state.Tick数 += 1;
  if (W移动单位(state.施法者, state.方向角, 配置.二段移动距离)) {
    设置单位Z(state.施法者, 获取单位Z(state.施法者) - 配置.三段下降距离, 0);
    for (const target of state.命中目标) {
      if (!单位存活(target)) continue;
      W移动单位(target, state.方向角, 配置.二段移动距离, false);
      设置单位Z(target, 获取单位Z(target) - 配置.三段下降距离, 0);
    }
  }
  if (state.Tick数 >= 配置.二段Tick数) {
    debugLogForce(模块名, "W三段Tick 完成 清理", "施法者", 获取句柄ID(state.施法者), "Tick数", state.Tick数);
    创建点特效({
      模型路径: 配置.三段践踏模型,
      X: 获取单位X(state.施法者),
      Y: 获取单位Y(state.施法者),
      Z: 0,
      缩放: 配置.三段践踏缩放,
      持续秒: 1,
    });
    清理W状态(state, 配置.三段目标高度恢复延迟秒);
  }
}

function 创建W阶段刀光(this: void, state: 克劳德W状态, 高度偏移: number): void {
  const caster = state.施法者;
  const radians = state.方向角 * 角度转弧度;
  const x = 获取单位X(caster) + 计算余弦(radians) * 75;
  const y = 获取单位Y(caster) + 计算正弦(radians) * 75;
  const record = 创建W表现单位(获取单位拥有者(caster), 二段刀光单位ID, x, y, state.方向角, 配置.刀光持续秒);
  设置W表现单位高度(record, 获取单位Z(caster) + 高度偏移);
}

function 创建W命中刀光(this: void, caster: any, target: any): void {
  创建W表现单位(
    获取单位拥有者(caster),
    命中刀光单位ID,
    获取单位X(target),
    获取单位Y(target),
    获取随机实数(0, 360),
    配置.命中刀光持续秒,
  );
}

function 消耗W后续段(this: void, caster: any, fixedCost: number): boolean {
  const maxMana = 获取单位状态(caster, 最大魔法状态) || 0;
  const cost = fixedCost + maxMana * 配置.后续最大魔法消耗比例;
  const currentMana = 获取单位状态(caster, 当前魔法状态) || 0;
  debugLogForce(模块名, "W后续段魔耗判断", "施法者", 获取句柄ID(caster), "固定", fixedCost, "总需求", cost, "当前蓝", currentMana);
  if (cost <= 0 || currentMana < cost) {
    debugLogForce(模块名, "W后续段魔耗不足 返回false", "总需求", cost, "当前蓝", currentMana);
    return false;
  }
  减少魔法值(caster, cost, false, false);
  return true;
}

function 释放W初段(this: void, state: 克劳德W状态, caster: any, skillInstanceId?: number): void {
  debugLogForce(模块名, "释放W初段 进入", "施法者", caster == null ? "nil" : 获取句柄ID(caster), "已在进行", state.进行中, "技能实例ID", skillInstanceId);
  if (state.进行中) return;
  清理W壳(caster);
  state.施法者 = caster;
  state.阶段 = 0;
  state.进行中 = true;
  state.等待输入 = false;
  state.目标X = 获取技能目标X();
  state.目标Y = 获取技能目标Y();
  state.方向角 = 计算反正切(state.目标Y - 获取单位Y(caster), state.目标X - 获取单位X(caster)) * 弧度转角度;
  debugLogForce(模块名, "释放W初段 正常路径", "目标X", state.目标X, "目标Y", state.目标Y, "方向角", state.方向角);
  state.技能实例ID = skillInstanceId;
  state.命中目标 = [];
  添加单位暂停(caster, `${来源前缀}-自身`);
  设置动作名(caster, 配置.初段动作名);
  设置时间流速(caster, 配置.动作时间流速);
  addDelayedCallback(10, W一段启动 as unknown as (this: void, variable?: any) => void, state);
}

function 释放W二段(this: void, state: 克劳德W状态, caster: any): void {
  debugLogForce(模块名, "释放W二段 进入", "施法者", 获取句柄ID(caster), "进行中", state.进行中, "等待输入", state.等待输入, "阶段", state.阶段);
  if (!state.进行中 || !state.等待输入 || state.阶段 !== 0) return;
  if (!消耗W后续段(caster, 配置.二段代码追加固定魔耗)) return;
  播放W音效(caster, 配置.二段音效键);
  state.等待输入 = false;
  移除技能(caster, 二段技能ID);
  state.阶段 = 1;
  state.Tick数 = 0;
  state.方向角 = 获取单位面向(caster);
  const 二段目标 = 获取范围敌军(caster, 获取单位X(caster), 获取单位Y(caster), 配置.二段范围);
  state.命中目标 = [];
  for (const target of 二段目标) {
    if (目标合法(caster, target)) state.命中目标.push(target);
  }
  debugLogForce(模块名, "释放W二段 成功进入阶段1", "范围内敌军", 二段目标.length, "合法目标", state.命中目标.length);
  设置空牙Q联动(caster, state.方向角, state.命中目标);
  添加单位暂停(caster, `${来源前缀}-自身`);
  设置动作(caster, 配置.二段动作序号);
  设置时间流速(caster, 配置.动作时间流速);
  确保单位可设置飞行高度(caster);
  创建W阶段刀光(state, 0);
  for (const target of state.命中目标) {
    if (!目标合法(caster, target)) continue;
    造成W伤害(state, target, 配置.二段伤害倍率);
    施加眩晕(caster, target, 配置.二段控制秒, `${来源前缀}-二段硬直`, "技能");
    设置动作名(target, "Death");
    创建W命中刀光(caster, target);
    确保单位可设置飞行高度(target);
  }
  state.周期ID = addPeriodicCallback(配置.二段周期秒 * 1000, W二段Tick as unknown as (this: void, variable?: any) => void, state);
}

function 释放W三段(this: void, state: 克劳德W状态, caster: any): void {
  debugLogForce(模块名, "释放W三段 进入", "施法者", 获取句柄ID(caster), "进行中", state.进行中, "等待输入", state.等待输入, "阶段", state.阶段);
  if (!state.进行中 || !state.等待输入 || state.阶段 !== 1) return;
  if (!消耗W后续段(caster, 配置.三段代码追加固定魔耗)) return;
  播放W音效(caster, 配置.三段音效键);
  state.等待输入 = false;
  移除技能(caster, 三段技能ID);
  state.阶段 = 2;
  state.Tick数 = 0;
  state.方向角 = 获取单位面向(caster);
  const 三段候选 = 获取范围敌军(caster, 获取单位X(caster), 获取单位Y(caster), 配置.三段范围);
  const 最低命中高度 = 获取单位Z(caster) - 100;
  state.命中目标 = [];
  for (const target of 三段候选) {
    if (目标合法(caster, target) && 获取单位Z(target) >= 最低命中高度) state.命中目标.push(target);
  }
  debugLogForce(模块名, "释放W三段 成功进入阶段2", "范围内敌军", 三段候选.length, "合法目标", state.命中目标.length, "施法者Z", 获取单位Z(caster), "最低命中高度", 最低命中高度);
  添加单位暂停(caster, `${来源前缀}-自身`);
  设置动作(caster, 配置.三段动作序号);
  设置时间流速(caster, 配置.动作时间流速);
  创建W阶段刀光(state, -200);
  for (const target of state.命中目标) {
    if (!目标合法(caster, target)) continue;
    造成W伤害(state, target, 配置.三段伤害倍率);
    施加眩晕(caster, target, 配置.三段控制秒, `${来源前缀}-三段硬直`, "技能");
    设置动作名(target, "Death");
    创建W命中刀光(caster, target);
    确保单位可设置飞行高度(target);
  }
  state.周期ID = addPeriodicCallback(配置.二段周期秒 * 1000, W三段Tick as unknown as (this: void, variable?: any) => void, state);
}

function W初段可释放(this: void, state: 克劳德W状态, _caster: any): boolean {
  return !state.进行中;
}

function W二段可释放(this: void, state: 克劳德W状态, _caster: any): boolean {
  return state.进行中 && state.等待输入 && state.阶段 === 0;
}

function W三段可释放(this: void, state: 克劳德W状态, _caster: any): boolean {
  return state.进行中 && state.等待输入 && state.阶段 === 1;
}

function 克劳德W死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0 || 获取单位类型ID(dyingUnit) !== 单位类型ID) return;
  const state = 状态表[获取句柄ID(dyingUnit)];
  debugLogForce(模块名, "克劳德W死亡清理", "死亡单位", 获取句柄ID(dyingUnit), "状态存在", state != null);
  if (state != null) 清理W状态(state);
}

注册单位技能壳监听({
  名称: "克劳德-空牙一段",
  单位类型ID,
  技能ID: 初段技能ID,
  获取或创建上下文: 获取或创建W状态,
  可释放: W初段可释放,
  释放技能: 释放W初段,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 5,
});
注册单位技能壳监听({
  名称: "克劳德-空牙二段",
  单位类型ID,
  技能ID: 二段技能ID,
  获取或创建上下文: 获取或创建W状态,
  可释放: W二段可释放,
  释放技能: 释放W二段,
  创建独立技能实例: false,
});
注册单位技能壳监听({
  名称: "克劳德-空牙三段",
  单位类型ID,
  技能ID: 三段技能ID,
  获取或创建上下文: 获取或创建W状态,
  可释放: W三段可释放,
  释放技能: 释放W三段,
  创建独立技能实例: false,
});
registerDeathListener(克劳德W死亡清理);

export {};
