/** @noSelfInFile */

import { 克劳德单位技能配置 } from "./00．配置";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean) => number;
};
const { 造成单体技能伤害, 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
  造成批量AOE技能伤害: (this: void, 参数: any) => number;
};
const { 开始冲锋, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, 参数: any) => number;
  停止位移: (this: void, id: number, reason?: string) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 创建点特效, 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number, animSpeed?: number, 动画索引?: number, 面向弧度?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 确保单位可设置飞行高度 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享") as {
  确保单位可设置飞行高度: (this: void, unit: any) => void;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
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
const 模块名 = "克劳德-R";
const jglobals = require("jass.globals") as any;
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, unit: any) => void;
};

const 获取句柄ID = jass.GetHandleId as (this: void, handle: any) => number;
const 获取单位类型ID = jass.GetUnitTypeId as (this: void, unit: any) => number;
const 获取单位X = jass.GetUnitX as (this: void, unit: any) => number;
const 获取单位Y = jass.GetUnitY as (this: void, unit: any) => number;
const 获取技能目标X = jass.GetSpellTargetX as (this: void) => number;
const 获取技能目标Y = jass.GetSpellTargetY as (this: void) => number;
const 获取技能目标单位 = jass.GetSpellTargetUnit as (this: void) => any;
const 获取单位拥有者 = jass.GetOwningPlayer as (this: void, unit: any) => any;
const 获取单位状态 = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const 设置技能可用 = jass.SetPlayerAbilityAvailable as (this: void, player: any, skillId: number, available: boolean) => void;
const 设置动作 = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const 设置动作名 = jass.SetUnitAnimation as (this: void, unit: any, name: string) => void;
const 设置单位飞行高度 = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const 获取单位飞行高度 = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const 获取单位默认飞行高度 = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const 设置单位移动速度 = jass.SetUnitMoveSpeed as (this: void, unit: any, speed: number) => void;
const 获取单位默认移动速度 = jass.GetUnitDefaultMoveSpeed as (this: void, unit: any) => number;
const 设置时间流速 = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const 添加技能 = jass.UnitAddAbility as (this: void, unit: any, skillId: number) => boolean;
const 移除技能 = jass.UnitRemoveAbility as (this: void, unit: any, skillId: number) => boolean;
const 判断敌人 = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const 判断类型 = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const 计算反正切 = jass.Atan2 as (this: void, y: number, x: number) => number;
const 计算平方根 = jass.SquareRoot as (this: void, value: number) => number;
const 弧度转角度 = jass.bj_RADTODEG as number;
const 古树类型 = jass.UNIT_TYPE_ANCIENT as any;
const 机械类型 = jass.UNIT_TYPE_MECHANICAL as any;
const 最大魔法状态 = jass.UNIT_STATE_MAX_MANA as any;
const 当前魔法状态 = jass.UNIT_STATE_MANA as any;
const 攻击类型 = jass.ATTACK_TYPE_NORMAL as any;
const 物理伤害类型 = jass.DAMAGE_TYPE_NORMAL as any;
const 魔法伤害类型 = jass.DAMAGE_TYPE_MAGIC as any;

const 配置 = 克劳德单位技能配置.R;
const 单位类型ID = stringToFourCCSafe(克劳德单位技能配置.单位ID);
const 初段技能ID = stringToFourCCSafe(配置.初段技能ID);
const 二段技能ID = stringToFourCCSafe(配置.二段技能ID);
const 三段技能ID = stringToFourCCSafe(配置.三段技能ID);
const 暂停来源 = "克劳德-R-自身";

function 播放R音效(this: void, caster: any, key: string): void {
  const sound = jglobals[key];
  if (sound != null) PlaySoundOnUnitBJ(sound, 100, caster);
}

interface 克劳德R状态 {
  施法者: any;
  目标单位: any;
  目标X: number;
  目标Y: number;
  终结目标: any;
  终结目标X: number;
  终结目标Y: number;
  方向角: number;
  接近距离: number;
  进行中: boolean;
  阶段: 0 | 1 | 2;
  等待输入: boolean;
  连击次数: number;
  位移ID: number;
  技能实例ID?: number;
  连击目标: any[];
  三段下降Tick: number;
  三段下降回调ID: number;
}

const 状态表: Record<number, 克劳德R状态 | undefined> = {};

function 获取或创建R状态(this: void, unit: any): 克劳德R状态 {
  const id = 获取句柄ID(unit);
  let state = 状态表[id];
  if (state == null) {
    state = {
      施法者: unit, 目标单位: null, 目标X: 0, 目标Y: 0, 终结目标: null, 终结目标X: 0, 终结目标Y: 0, 方向角: 0,
      进行中: false, 阶段: 0, 等待输入: false, 连击次数: 0, 位移ID: 0, 接近距离: 0,
      连击目标: [], 三段下降Tick: 0, 三段下降回调ID: 0,
    };
    状态表[id] = state;
  }
  return state;
}

function 目标合法(this: void, caster: any, target: any): boolean {
  return target != null && target !== 0 && target !== caster && 单位存活(target)
    && 判断敌人(target, 获取单位拥有者(caster))
    && !判断类型(target, 古树类型)
    && !判断类型(target, 机械类型);
}

function 清理R壳(this: void, caster: any): void {
  设置技能可用(获取单位拥有者(caster), 初段技能ID, true);
  移除技能(caster, 二段技能ID);
  移除技能(caster, 三段技能ID);
}

function 清理R状态(this: void, state: 克劳德R状态, 恢复目标: boolean = true): void {
  const caster = state.施法者;
  debugLogForce(模块名, "清理R状态", "施法者", caster == null || caster === 0 ? "nil" : 获取句柄ID(caster), "阶段", state.阶段, "位移ID", state.位移ID, "连击次数", state.连击次数);
  if (state.位移ID !== 0) {
    停止位移(state.位移ID, "中断");
    state.位移ID = 0;
  }
  if (caster != null && caster !== 0) {
    销毁单位坐标跟随特效(caster, 配置.初段冲锋叠加特效键);
  }
  if (state.三段下降回调ID !== 0) {
    removePeriodicCallback(state.三段下降回调ID);
    state.三段下降回调ID = 0;
  }
  if (caster != null && caster !== 0) {
    移除单位暂停(caster, 暂停来源);
    清理R壳(caster);
    设置时间流速(caster, 1);
    const 当前飞行高度 = 获取单位飞行高度(caster);
    const 默认飞行高度 = 获取单位默认飞行高度(caster);
    确保单位可设置飞行高度(caster);
    设置单位飞行高度(caster, 默认飞行高度, 0);
    debugLogForce(模块名, "清理R状态 恢复施法者飞行高度", "施法者", 获取句柄ID(caster), "原高度", 当前飞行高度, "默认高度", 默认飞行高度);
  }
  if (恢复目标) {
    for (const target of state.连击目标) {
      if (目标合法(caster, target)) {
        设置单位飞行高度(target, 获取单位默认飞行高度(target), 0);
        设置时间流速(target, 1);
        设置动作(target, 0);
      }
    }
  }
  state.进行中 = false;
  state.等待输入 = false;
  state.阶段 = 0;
  state.连击次数 = 0;
  state.连击目标 = [];
  state.三段下降Tick = 0;
  state.技能实例ID = undefined;
  if (caster != null && caster !== 0) {
    const id = 获取句柄ID(caster);
    if (状态表[id] === state) delete 状态表[id];
  }
}

function 记录R目标(this: void, state: 克劳德R状态, target: any): void {
  const id = 获取句柄ID(target);
  for (const oldTarget of state.连击目标) {
    if (获取句柄ID(oldTarget) === id) return;
  }
  state.连击目标.push(target);
}

function 创建R表现单位(this: void, caster: any, unitTypeText: string, x: number, y: number, z: number, lifeSec: number, deathAnimation: boolean = false): void {
  const unitTypeId = stringToFourCCSafe(unitTypeText);
  const visual = 创建单位并登记排泄安全(获取单位拥有者(caster), unitTypeId, x, y, 0);
  if (visual == null || visual === 0) return;
  设置单位飞行高度(visual, z, 0);
  if (deathAnimation) 设置动作名(visual, "Death");
  addDelayedCallback(lifeSec * 1000, R清理表现单位 as unknown as (this: void, variable?: any) => void, visual);
}

function R清理表现单位(this: void, variable?: any): void {
  const visual = variable as any;
  if (visual != null && visual !== 0) 立即移除单位并取消排泄登记(visual);
}

function R播放初段目标表现(this: void, state: 克劳德R状态, target: any): void {
  const caster = state.施法者;
  const x = 获取单位X(target);
  const y = 获取单位Y(target);
  const z = 获取单位飞行高度(target);
  确保单位可设置飞行高度(target);
  创建点特效({ 模型路径: 配置.初段斩杀模型, X: x, Y: y, Z: z + 100, 缩放: 配置.初段斩杀缩放, 持续秒: 2 });
  创建点特效({ 模型路径: 配置.初段雷霆模型, X: x, Y: y, Z: z, 缩放: 配置.初段雷霆缩放, 持续秒: 1 });
  设置动作名(target, "Death");
  施加眩晕(caster, target, 配置.初段控制秒, "克劳德-R-初段硬直", "技能");
}

function R二段窗口超时(this: void, state: 克劳德R状态): void {
  debugLogForce(模块名, "R二段窗口超时", "进行中", state?.进行中, "等待输入", state?.等待输入, "阶段", state?.阶段, "连击次数", state?.连击次数);
  if (state == null || !state.进行中 || state.阶段 !== 1) return;
  if (state.连击次数 <= 0) {
    清理R状态(state);
    return;
  }
  addDelayedCallback(配置.二段连击收尾超时秒 * 1000, R二段连击收尾超时 as unknown as (this: void, variable?: any) => void, state);
}

function R二段连击收尾超时(this: void, state: 克劳德R状态): void {
  debugLogForce(模块名, "R二段连击收尾超时", "进行中", state?.进行中, "阶段", state?.阶段, "连击次数", state?.连击次数);
  if (state != null && state.进行中 && state.阶段 === 1 && state.连击次数 < 配置.二段最大次数) 清理R状态(state);
}

function R三段窗口超时(this: void, state: 克劳德R状态): void {
  debugLogForce(模块名, "R三段窗口超时", "进行中", state?.进行中, "等待输入", state?.等待输入, "阶段", state?.阶段);
  if (state != null && state.进行中 && state.等待输入 && state.阶段 === 2) 清理R状态(state);
}

function R接近结束(this: void, caster: any, _reason: string, _moveId: number): void {
  const state = 状态表[获取句柄ID(caster)];
  debugLogForce(模块名, "R接近结束", "施法者", 获取句柄ID(caster), "原因", _reason, "状态存在", state != null, "进行中", state?.进行中);
  if (state == null || !state.进行中) return;
  state.位移ID = 0;
  销毁单位坐标跟随特效(caster, 配置.初段冲锋叠加特效键);
  addDelayedCallback(配置.第一刀延迟秒 * 1000, R第一刀 as unknown as (this: void, variable?: any) => void, state);
}

function R接近启动(this: void, state: 克劳德R状态): void {
  if (!state.进行中 || !单位存活(state.施法者)) {
    debugLogForce(模块名, "R接近启动 前置不满足 清理", "进行中", state.进行中, "施法者存活", 单位存活(state.施法者));
    清理R状态(state);
    return;
  }
  确保单位可设置飞行高度(state.施法者);
  设置动作(state.施法者, 配置.初段动作索引);
  创建单位坐标跟随特效(
    state.施法者,
    配置.初段冲锋叠加特效模型,
    配置.初段冲锋叠加特效键,
    配置.初段冲锋叠加特效缩放,
    配置.初段冲锋叠加特效高度,
    undefined,
    undefined,
    state.方向角,
  );
  state.位移ID = 开始冲锋(state.施法者, {
    角度: state.方向角,
    距离: state.接近距离,
    持续时间: 配置.接近持续秒,
    检查地形: true,
    朝向跟随位移: true,
    暂停单位: false,
    禁用碰撞: true,
    动画序号: 0,
    结束回调: R接近结束,
  });
  debugLogForce(模块名, "R接近启动 冲锋创建", "施法者", 获取句柄ID(state.施法者), "位移ID", state.位移ID, "方向角", state.方向角, "接近距离", state.接近距离);
  if (state.位移ID === 0) R接近结束(state.施法者, "中断", 0);
}

function R结算一刀(this: void, state: 克劳德R状态): void {
  const caster = state.施法者;
  const targets = 获取范围敌军(caster, 获取单位X(caster), 获取单位Y(caster), 配置.初段范围);
  const validTargets: any[] = [];
  for (const target of targets) {
    if (!目标合法(caster, target)) continue;
    validTargets.push(target);
    记录R目标(state, target);
    R播放初段目标表现(state, target);
    创建点特效({ 模型路径: 配置.斩刀光模型, X: 获取单位X(target), Y: 获取单位Y(target), Z: 获取单位飞行高度(target), 面向角度: state.方向角, 缩放: 2, 持续秒: 0.8 });
  }
  debugLogForce(模块名, "R结算一刀 范围结算", "范围敌军", validTargets.length);
  if (validTargets.length === 0) return;
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: validTargets,
    伤害: 读取单位攻击力(caster) * 配置.初段伤害倍率,
    伤害类型: 物理伤害类型,
    attack: true,
    ranged: false,
    attackType: 攻击类型,
    来源类型: "单位技能",
    技能ID: 初段技能ID,
    技能实例ID: state.技能实例ID,
    标签: "克劳德-R-初段范围斩击",
  });
}

function R第二刀(this: void, variable?: any): void {
  const state = variable as 克劳德R状态 | undefined;
  if (state == null || !state.进行中 || !单位存活(state.施法者)) {
    debugLogForce(模块名, "R第二刀 前置不满足", "状态存在", state != null, "进行中", state?.进行中, "施法者存活", state?.施法者 == null ? false : 单位存活(state.施法者));
    if (state != null) 清理R状态(state);
    return;
  }
  debugLogForce(模块名, "R第二刀 结算", "施法者", 获取句柄ID(state.施法者));
  R结算一刀(state);
  播放R音效(state.施法者, 配置.初段第二刀音效键);
  设置动作(state.施法者, 配置.初段第二刀动作索引);
  state.阶段 = 1;
  state.等待输入 = true;
  移除单位暂停(state.施法者, 暂停来源);
  设置时间流速(state.施法者, 1);
  设置技能可用(获取单位拥有者(state.施法者), 初段技能ID, false);
  添加技能(state.施法者, 二段技能ID);
  debugLogForce(模块名, "R第二刀 完成 等待二段输入");
  addDelayedCallback(配置.二段窗口秒 * 1000, R二段窗口超时 as unknown as (this: void, variable?: any) => void, state);
}

function R第一刀(this: void, variable?: any): void {
  const state = variable as 克劳德R状态 | undefined;
  if (state == null || !state.进行中 || !单位存活(state.施法者)) {
    debugLogForce(模块名, "R第一刀 前置不满足", "状态存在", state != null, "进行中", state?.进行中, "施法者存活", state?.施法者 == null ? false : 单位存活(state.施法者));
    if (state != null) 清理R状态(state);
    return;
  }
  debugLogForce(模块名, "R第一刀 结算", "施法者", 获取句柄ID(state.施法者));
  设置动作(state.施法者, 配置.初段动作索引);
  设置时间流速(state.施法者, 配置.动作时间流速);
  R结算一刀(state);
  播放R音效(state.施法者, 配置.初段第一刀音效键);
  addDelayedCallback(配置.第二刀延迟秒 * 1000, R第二刀 as unknown as (this: void, variable?: any) => void, state);
}

function 消耗R魔法(this: void, caster: any, fixedCost: number, ratio: number): boolean {
  const maxMana = 获取单位状态(caster, 最大魔法状态) || 0;
  const cost = fixedCost + maxMana * ratio;
  const currentMana = 获取单位状态(caster, 当前魔法状态) || 0;
  debugLogForce(模块名, "R魔耗判断", "施法者", 获取句柄ID(caster), "固定", fixedCost, "比例", ratio, "总需求", cost, "当前蓝", currentMana);
  if (cost <= 0 || currentMana < cost) {
    debugLogForce(模块名, "R魔耗不足 返回false", "总需求", cost, "当前蓝", currentMana);
    return false;
  }
  减少魔法值(caster, cost, false, false);
  return true;
}

interface 克劳德R二段结算上下文 {
  状态: 克劳德R状态;
  连击次数: number;
  目标列表: any[];
}

function R二段命中(this: void, variable?: any): void {
  const context = variable as 克劳德R二段结算上下文 | undefined;
  if (context == null) return;
  const state = context.状态;
  if (!state.进行中 || !单位存活(state.施法者)) return;
  const caster = state.施法者;
  确保单位可设置飞行高度(caster);
  设置动作(caster, 配置.二段命中动作索引);
  设置单位飞行高度(caster, 获取单位飞行高度(caster) + 65, 0);
  const validTargets: any[] = [];
  for (const target of context.目标列表) {
    if (!目标合法(caster, target)) continue;
    validTargets.push(target);
    记录R目标(state, target);
    R播放初段目标表现(state, target);
    设置时间流速(target, 10);
    设置单位飞行高度(target, 获取单位飞行高度(target) + 65, 0);
  }
  debugLogForce(模块名, "R二段命中", "施法者", 获取句柄ID(caster), "连击次数", context.连击次数, "目标数", validTargets.length);
  if (validTargets.length === 0) return;
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: validTargets,
    伤害: 读取单位攻击力(caster) * 配置.二段伤害倍率,
    伤害类型: 物理伤害类型,
    attack: true,
    ranged: false,
    attackType: 攻击类型,
    来源类型: "单位技能",
    技能ID: 初段技能ID,
    技能实例ID: state.技能实例ID,
    标签: "克劳德-R-旋风斩",
  });
}

function 释放R初段(this: void, state: 克劳德R状态, caster: any, skillInstanceId?: number): void {
  debugLogForce(模块名, "释放R初段 进入", "施法者", caster == null ? "nil" : 获取句柄ID(caster), "已在进行", state.进行中, "技能实例ID", skillInstanceId);
  if (state.进行中) return;
  state.施法者 = caster;
  state.进行中 = true;
  state.阶段 = 0;
  state.等待输入 = false;
  state.连击次数 = 0;
  state.连击目标 = [];
  state.三段下降Tick = 0;
  state.三段下降回调ID = 0;
  state.技能实例ID = skillInstanceId;
  state.目标单位 = 获取技能目标单位();
  state.目标X = 获取技能目标X();
  state.目标Y = 获取技能目标Y();
  const dx = state.目标X - 获取单位X(caster);
  const dy = state.目标Y - 获取单位Y(caster);
  state.方向角 = 计算反正切(dy, dx) * 弧度转角度;
  const distance = 计算平方根(dx * dx + dy * dy);
  state.接近距离 = distance > 配置.接近距离 ? 配置.接近距离 : distance;
  if (目标合法(caster, state.目标单位)) {
    state.目标X = 获取单位X(state.目标单位);
    state.目标Y = 获取单位Y(state.目标单位);
  } else {
    state.目标单位 = null;
  }
  debugLogForce(模块名, "释放R初段 正常路径", "目标单位", state.目标单位 == null ? "nil" : 获取句柄ID(state.目标单位), "目标X", state.目标X, "目标Y", state.目标Y, "方向角", state.方向角, "接近距离", state.接近距离);
  添加单位暂停(caster, 暂停来源);
  设置动作(caster, 配置.初段动作索引);
  设置时间流速(caster, 配置.动作时间流速);
  addDelayedCallback(10, R接近启动 as unknown as (this: void, variable?: any) => void, state);
}

function 释放R二段(this: void, state: 克劳德R状态, caster: any): void {
  debugLogForce(模块名, "释放R二段 进入", "施法者", 获取句柄ID(caster), "进行中", state.进行中, "等待输入", state.等待输入, "阶段", state.阶段, "连击次数", state.连击次数);
  if (!state.进行中 || !state.等待输入 || state.阶段 !== 1) return;
  if (!消耗R魔法(caster, 配置.二段代码追加固定魔耗, 配置.二段最大魔法消耗比例)) return;
  state.连击次数 += 1;
  if (state.连击次数 === 1) 播放R音效(caster, 配置.二段音效键);
  const x = 获取单位X(caster);
  const y = 获取单位Y(caster);
  const targets = 获取范围敌军(caster, x, y, 配置.二段范围);
  const validTargets: any[] = [];
  for (const target of targets) {
    if (目标合法(caster, target)) validTargets.push(target);
  }
  if (state.连击次数 > 3) {
    创建R表现单位(caster, 配置.二段旋风单位ID, x, y, 获取单位飞行高度(caster) + 配置.二段特效高度, 配置.二段旋风持续秒);
  }
  创建R表现单位(caster, 配置.二段能量单位ID, x, y, 获取单位飞行高度(caster) + 配置.二段特效高度, 配置.二段能量持续秒, true);
  设置时间流速(caster, 配置.二段动作时间流速);
  addDelayedCallback(250, R二段命中 as unknown as (this: void, variable?: any) => void, {
    状态: state,
    连击次数: state.连击次数,
    目标列表: validTargets,
  } as 克劳德R二段结算上下文);
  if (state.连击次数 >= 配置.二段最大次数) {
    state.阶段 = 2;
    设置时间流速(caster, 1);
    设置单位移动速度(caster, 获取单位默认移动速度(caster));
    移除技能(caster, 二段技能ID);
    添加技能(caster, 三段技能ID);
    设置技能可用(获取单位拥有者(caster), 三段技能ID, true);
    state.等待输入 = true;
    debugLogForce(模块名, "释放R二段 达到最大次数 进入阶段2", "连击次数", state.连击次数);
    addDelayedCallback(配置.三段窗口秒 * 1000, R三段窗口超时 as unknown as (this: void, variable?: any) => void, state);
    return;
  }
  state.等待输入 = true;
}

function R三段下降Tick(this: void, state: 克劳德R状态): void {
  if (!state.进行中 || state.阶段 !== 2 || !单位存活(state.施法者)) {
    if (state.三段下降回调ID !== 0) removePeriodicCallback(state.三段下降回调ID);
    state.三段下降回调ID = 0;
    if (state.进行中) 清理R状态(state);
    return;
  }
  state.三段下降Tick += 1;
  for (const target of state.连击目标) {
    if (目标合法(state.施法者, target)) 设置单位飞行高度(target, 获取单位飞行高度(target) - 配置.三段每Tick下降高度, 0);
  }
  if (state.三段下降Tick < 配置.三段下降Tick数) return;
  removePeriodicCallback(state.三段下降回调ID);
  state.三段下降回调ID = 0;
  R三段伤害结算(state);
}

function R三段下降Tick包装(this: void): void {
  for (const key in 状态表) {
    const state = 状态表[Number(key)];
    if (state != null && state.三段下降回调ID !== 0) R三段下降Tick(state);
  }
}

function R三段表现开始(this: void, variable?: any): void {
  const state = variable as 克劳德R状态 | undefined;
  if (state == null || !state.进行中 || state.阶段 !== 2 || !单位存活(state.施法者)) {
    if (state != null) 清理R状态(state);
    return;
  }
  const caster = state.施法者;
  设置时间流速(caster, 1);
  设置动作(caster, 配置.终结动作索引);
  播放R音效(caster, 配置.三段音效键);
  addDelayedCallback(配置.三段特效延迟秒 * 1000, R三段冲击开始 as unknown as (this: void, variable?: any) => void, state);
}

function R三段冲击开始(this: void, variable?: any): void {
  const state = variable as 克劳德R状态 | undefined;
  if (state == null || !state.进行中 || state.阶段 !== 2 || !单位存活(state.施法者)) {
    if (state != null) 清理R状态(state);
    return;
  }
  const caster = state.施法者;
  移除单位暂停(caster, 暂停来源);
  设置单位移动速度(caster, 获取单位默认移动速度(caster));
  设置技能可用(获取单位拥有者(caster), 初段技能ID, true);
  移除技能(caster, 三段技能ID);
  设置单位飞行高度(caster, 获取单位默认飞行高度(caster), 0);
  const target = state.终结目标;
  const targetX = target != null && target !== 0 ? 获取单位X(target) : state.终结目标X;
  const targetY = target != null && target !== 0 ? 获取单位Y(target) : state.终结目标Y;
  const casterHeight = 获取单位飞行高度(caster);
  创建点特效({ 模型路径: 配置.三段冲击模型, X: targetX, Y: targetY, Z: casterHeight - 350, 缩放: 配置.三段冲击缩放, 持续秒: 2 });
  创建点特效({ 模型路径: 配置.三段践踏模型, X: targetX, Y: targetY, Z: casterHeight, 缩放: 配置.三段践踏缩放, 持续秒: 1 });
  创建点特效({ 模型路径: 配置.三段爆炸模型, X: targetX, Y: targetY, Z: casterHeight, 持续秒: 1 });
  state.三段下降Tick = 0;
  state.三段下降回调ID = addPeriodicCallback(配置.三段下降间隔秒 * 1000, R三段下降Tick包装);
}

function R三段目标恢复(this: void, variable?: any): void {
  const target = variable as any;
  if (target == null || target === 0 || !单位存活(target)) return;
  设置单位飞行高度(target, 获取单位默认飞行高度(target), 0);
  设置时间流速(target, 1);
  设置动作(target, 0);
}

function R三段目标倒地冻结(this: void, variable?: any): void {
  const target = variable as any;
  if (target == null || target === 0 || !单位存活(target)) return;
  设置时间流速(target, 0);
  addDelayedCallback(配置.三段倒地恢复秒 * 1000, R三段目标恢复 as unknown as (this: void, variable?: any) => void, target);
}

function R三段目标死亡动作(this: void, variable?: any): void {
  const target = variable as any;
  if (target == null || target === 0 || !单位存活(target)) return;
  设置时间流速(target, 配置.三段目标动作速度);
  设置动作名(target, "Death");
  addDelayedCallback(450, R三段目标倒地冻结 as unknown as (this: void, variable?: any) => void, target);
}

function R三段伤害结算(this: void, state: 克劳德R状态): void {
  const caster = state.施法者;
  设置技能可用(获取单位拥有者(caster), 初段技能ID, true);
  移除技能(caster, 二段技能ID);
  移除技能(caster, 三段技能ID);
  const validTargets: any[] = [];
  for (const target of state.连击目标) {
    if (!目标合法(caster, target)) continue;
    validTargets.push(target);
    设置单位飞行高度(target, 获取单位默认飞行高度(target), 0);
    施加眩晕(caster, target, 配置.三段目标控制秒, "克劳德-R-终结控制", "技能");
    addDelayedCallback(配置.三段死亡动作延迟秒 * 1000, R三段目标死亡动作 as unknown as (this: void, variable?: any) => void, target);
  }
  if (validTargets.length > 0) {
    造成批量AOE技能伤害({ 来源: caster, 目标列表: validTargets, 伤害: 读取单位攻击力(caster) * 配置.三段伤害倍率, 伤害类型: 魔法伤害类型, attack: true, ranged: false, attackType: 攻击类型, 来源类型: "单位技能", 技能ID: 初段技能ID, 技能实例ID: state.技能实例ID, 标签: "克劳德-R-终结下劈" });
  }
  清理R状态(state, false);
}

function 释放R三段(this: void, state: 克劳德R状态, caster: any): void {
  debugLogForce(模块名, "释放R三段 进入", "施法者", 获取句柄ID(caster), "进行中", state.进行中, "等待输入", state.等待输入, "阶段", state.阶段);
  if (!state.进行中 || !state.等待输入 || state.阶段 !== 2) return;
  const target = 获取技能目标单位();
  debugLogForce(模块名, "释放R三段 目标", "目标", target == null ? "nil" : 获取句柄ID(target), "目标合法", 目标合法(caster, target));
  if (!目标合法(caster, target)) {
    清理R状态(state);
    return;
  }
  if (!消耗R魔法(caster, 配置.三段代码追加固定魔耗, 配置.三段最大魔法消耗比例)) return;
  state.等待输入 = false;
  state.终结目标 = target;
  state.终结目标X = 获取单位X(target);
  state.终结目标Y = 获取单位Y(target);
  添加单位暂停(caster, 暂停来源);
  addDelayedCallback(10, R三段表现开始 as unknown as (this: void, variable?: any) => void, state);
}

function R初段可释放(this: void, state: 克劳德R状态, _caster: any): boolean {
  return !state.进行中;
}

function R二段可释放(this: void, state: 克劳德R状态, _caster: any): boolean {
  return state.进行中 && state.等待输入 && state.阶段 === 1;
}

function R三段可释放(this: void, state: 克劳德R状态, _caster: any): boolean {
  return state.进行中 && state.等待输入 && state.阶段 === 2;
}

function 克劳德R死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0 || 获取单位类型ID(dyingUnit) !== 单位类型ID) return;
  const state = 状态表[获取句柄ID(dyingUnit)];
  debugLogForce(模块名, "克劳德R死亡清理", "死亡单位", 获取句柄ID(dyingUnit), "状态存在", state != null);
  if (state != null) 清理R状态(state);
}

注册单位技能壳监听({
  名称: "克劳德-画龙点睛一段",
  单位类型ID,
  技能ID: 初段技能ID,
  获取或创建上下文: 获取或创建R状态,
  可释放: R初段可释放,
  释放技能: 释放R初段,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 10,
});
注册单位技能壳监听({
  名称: "克劳德-画龙点睛二段",
  单位类型ID,
  技能ID: 二段技能ID,
  获取或创建上下文: 获取或创建R状态,
  可释放: R二段可释放,
  释放技能: 释放R二段,
  创建独立技能实例: false,
});
注册单位技能壳监听({
  名称: "克劳德-画龙点睛三段",
  单位类型ID,
  技能ID: 三段技能ID,
  获取或创建上下文: 获取或创建R状态,
  可释放: R三段可释放,
  释放技能: 释放R三段,
  创建独立技能实例: false,
});
registerDeathListener(克劳德R死亡清理);

export {};
