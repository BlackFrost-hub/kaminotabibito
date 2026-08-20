/** @noSelfInFile */

import { 克劳德单位技能配置 } from "./00．配置";
import { 标记凶斩命中 } from "./00A．联动状态";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean) => number;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, 参数: any) => number;
};
const { 开始冲锋, 开始击退, 停止位移 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, 参数: any) => number;
  开始击退: (this: void, unit: any, 参数: any) => number;
  停止位移: (this: void, id: number, reason?: string) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { CreateFloatTextAtPoint } = require("lib.扩展函数.封装函数.03．漂浮文字.03．创建漂浮文字") as {
  CreateFloatTextAtPoint: (this: void, x: number, y: number, text: string, options?: any) => any;
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
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块名: string, ...参数: any[]) => void;
};
const 模块名 = "克劳德-E";
const jglobals = require("jass.globals") as any;
const { PlaySoundOnUnitBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, unit: any) => void;
};
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};

const 获取句柄ID = jass.GetHandleId as (this: void, handle: any) => number;
const 获取单位类型ID = jass.GetUnitTypeId as (this: void, unit: any) => number;
const 获取单位X = jass.GetUnitX as (this: void, unit: any) => number;
const 获取单位Y = jass.GetUnitY as (this: void, unit: any) => number;
const 获取单位面向 = jass.GetUnitFacing as (this: void, unit: any) => number;
const 设置单位X = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const 设置单位Y = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const 获取单位飞行高度 = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const 设置单位飞行高度 = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const 获取单位默认飞行高度 = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const 判断地形可行走 = jass.IsTerrainPathable as (this: void, x: number, y: number, pathingType: any) => boolean;
const 可行走路径类型 = jass.PATHING_TYPE_WALKABILITY as any;
const 获取技能目标X = jass.GetSpellTargetX as (this: void) => number;
const 获取技能目标Y = jass.GetSpellTargetY as (this: void) => number;
const 获取单位拥有者 = jass.GetOwningPlayer as (this: void, unit: any) => any;
const 获取单位状态 = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const 设置技能可用 = jass.SetPlayerAbilityAvailable as (this: void, player: any, skillId: number, available: boolean) => void;
const 设置动作 = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const 设置动作名 = jass.SetUnitAnimation as (this: void, unit: any, name: string) => void;
const 设置时间流速 = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const 添加技能 = jass.UnitAddAbility as (this: void, unit: any, skillId: number) => boolean;
const 移除技能 = jass.UnitRemoveAbility as (this: void, unit: any, skillId: number) => boolean;
const 判断敌人 = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const 判断类型 = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const 计算反正切 = jass.Atan2 as (this: void, y: number, x: number) => number;
const 计算余弦 = jass.Cos as (this: void, radians: number) => number;
const 计算正弦 = jass.Sin as (this: void, radians: number) => number;
const 弧度转角度 = jass.bj_RADTODEG as number;
const 角度转弧度 = jass.bj_DEGTORAD as number;
const 古树类型 = jass.UNIT_TYPE_ANCIENT as any;
const 机械类型 = jass.UNIT_TYPE_MECHANICAL as any;
const 最大魔法状态 = jass.UNIT_STATE_MAX_MANA as any;
const 当前魔法状态 = jass.UNIT_STATE_MANA as any;
const 攻击类型 = jass.ATTACK_TYPE_NORMAL as any;
const 物理伤害类型 = jass.DAMAGE_TYPE_NORMAL as any;
const 魔法伤害类型 = jass.DAMAGE_TYPE_MAGIC as any;

const 配置 = 克劳德单位技能配置.E;
const 单位类型ID = stringToFourCCSafe(克劳德单位技能配置.单位ID);
const 技能ID = stringToFourCCSafe(配置.技能ID);
const 二段技能ID = stringToFourCCSafe(配置.二段技能ID);
const 三段技能ID = stringToFourCCSafe(配置.三段技能ID);
const 暂停来源 = "克劳德-E-自身";

function 播放E音效(this: void, caster: any, key: string): void {
  const sound = jglobals[key];
  if (sound != null) PlaySoundOnUnitBJ(sound, 100, caster);
}

interface 克劳德E状态 {
  施法者: any;
  进行中: boolean;
  阶段: 0 | 1 | 2;
  等待输入: boolean;
  方向角: number;
  目标X: number;
  目标Y: number;
  技能实例ID?: number;
  位移ID: number;
  斩击回调ID: number;
  窗口回调ID: number;
  斩击次数: number;
  命中目标: any[];
}

interface 强化击退记录 {
  施法者: any;
  目标: any;
  方向角: number;
  Tick: number;
}

const 状态表: Record<number, 克劳德E状态 | undefined> = {};
const 强化击退表: Record<number, 强化击退记录 | undefined> = {};
let 下一个强化击退ID = 0;
let 强化击退驱动ID = 0;

function 获取或创建E状态(this: void, unit: any): 克劳德E状态 {
  const id = 获取句柄ID(unit);
  let state = 状态表[id];
  if (state == null) {
    state = {
      施法者: unit, 进行中: false, 阶段: 0, 等待输入: false, 方向角: 0,
      目标X: 0, 目标Y: 0,
      位移ID: 0, 斩击回调ID: 0, 窗口回调ID: 0, 斩击次数: 0, 命中目标: [],
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

function 目标未记录(this: void, state: 克劳德E状态, target: any): boolean {
  const id = 获取句柄ID(target);
  for (const old of state.命中目标) {
    if (获取句柄ID(old) === id) return false;
  }
  return true;
}

function 清理E壳(this: void, caster: any): void {
  设置技能可用(获取单位拥有者(caster), 技能ID, true);
  移除技能(caster, 二段技能ID);
  移除技能(caster, 三段技能ID);
}

function 清理E状态(this: void, state: 克劳德E状态): void {
  const caster = state.施法者;
  debugLogForce(模块名, "清理E状态", "施法者", caster == null || caster === 0 ? "nil" : 获取句柄ID(caster), "阶段", state.阶段, "位移ID", state.位移ID, "斩击回调ID", state.斩击回调ID, "窗口回调ID", state.窗口回调ID, "斩击次数", state.斩击次数);
  if (state.位移ID !== 0) {
    停止位移(state.位移ID, "中断");
    state.位移ID = 0;
  }
  if (state.斩击回调ID !== 0) {
    removeDelayedCallback(state.斩击回调ID);
    state.斩击回调ID = 0;
  }
  if (state.窗口回调ID !== 0) {
    removeDelayedCallback(state.窗口回调ID);
    state.窗口回调ID = 0;
  }
  if (caster != null && caster !== 0) {
    移除单位暂停(caster, 暂停来源);
    清理E壳(caster);
    设置时间流速(caster, 1);
  }
  state.进行中 = false;
  state.等待输入 = false;
  state.阶段 = 0;
  state.斩击次数 = 0;
  state.命中目标 = [];
  if (caster != null && caster !== 0) {
    const id = 获取句柄ID(caster);
    if (状态表[id] === state) delete 状态表[id];
  }
}

function E窗口结算(this: void, state: 克劳德E状态): void {
  debugLogForce(模块名, "E窗口结算 进入", "进行中", state?.进行中, "阶段", state?.阶段, "施法者存活", state?.施法者 == null ? false : 单位存活(state.施法者));
  if (state == null || !state.进行中) return;
  state.窗口回调ID = 0;
  if (!单位存活(state.施法者)) {
    清理E状态(state);
    return;
  }
  if (state.阶段 !== 2) {
    debugLogForce(模块名, "E窗口结算 非强化阶段 清理", "阶段", state.阶段);
    清理E状态(state);
    return;
  }
  添加单位暂停(state.施法者, 暂停来源);
  设置动作(state.施法者, 配置.强化动作序号);
  设置时间流速(state.施法者, 配置.动作时间流速);
  state.斩击回调ID = addDelayedCallback(配置.强化延迟秒 * 1000, E强化结算 as unknown as (this: void, variable?: any) => void, state);
}

function 清理E强化击飞表现(this: void, variable?: any): void {
  const visual = variable as any;
  if (visual != null && visual !== 0) 立即移除单位并取消排泄登记(visual);
}

function 创建E强化击飞表现(this: void, caster: any, direction: number): void {
  const visual = 创建单位并登记排泄安全(
    获取单位拥有者(caster),
    stringToFourCCSafe(配置.强化击飞单位ID),
    获取单位X(caster),
    获取单位Y(caster),
    direction + 180,
  );
  if (visual != null && visual !== 0) {
    addDelayedCallback(配置.强化特效持续秒 * 1000, 清理E强化击飞表现 as unknown as (this: void, variable?: any) => void, visual);
  }
}

function E冲锋过滤(this: void, caster: any, target: any): boolean {
  if (!目标合法(caster, target)) return false;
  let 差值 = 获取单位面向(caster) - 计算反正切(获取单位Y(target) - 获取单位Y(caster), 获取单位X(target) - 获取单位X(caster)) * 弧度转角度;
  while (差值 > 180) 差值 -= 360;
  while (差值 < -180) 差值 += 360;
  return 差值 <= 配置.冲锋前方角度 && 差值 >= -配置.冲锋前方角度;
}

function E冲锋命中过滤(this: void, movingUnit: any, target: any, _moveId: number): boolean {
  return E冲锋过滤(movingUnit, target);
}

function E冲锋结束(this: void, caster: any, _reason: string, _moveId: number): void {
  const state = 状态表[获取句柄ID(caster)];
  debugLogForce(模块名, "E冲锋结束", "施法者", 获取句柄ID(caster), "原因", _reason, "状态存在", state != null, "进行中", state?.进行中);
  if (state == null || !state.进行中) return;
  state.位移ID = 0;
  播放E音效(caster, 配置.普通音效键);
  state.斩击回调ID = addDelayedCallback(10, E执行斩击 as unknown as (this: void, variable?: any) => void, state);
}

function E冲锋启动(this: void, state: 克劳德E状态): void {
  if (!state.进行中 || !单位存活(state.施法者)) {
    debugLogForce(模块名, "E冲锋启动 前置不满足 清理", "进行中", state.进行中, "施法者存活", 单位存活(state.施法者));
    清理E状态(state);
    return;
  }
  const dx = state.目标X - 获取单位X(state.施法者);
  const dy = state.目标Y - 获取单位Y(state.施法者);
  const 目标距离 = jass.SquareRoot(dx * dx + dy * dy) as number;
  const 冲锋距离 = 目标距离 > 0 && 目标距离 < 配置.冲锋距离 ? 目标距离 : 配置.冲锋距离;
  state.位移ID = 开始冲锋(state.施法者, {
    角度: state.方向角,
    距离: 冲锋距离,
    持续时间: 配置.冲锋持续秒,
    检查地形: true,
    朝向跟随位移: true,
    暂停单位: true,
    禁用碰撞: true,
    命中半径: 配置.冲锋命中半径,
    只命中敌人: true,
    命中后结束: true,
    命中过滤: E冲锋命中过滤,
    结束回调: E冲锋结束,
    位移特效: 配置.普通刀光模型,
    动画序号: 0,
  });
  debugLogForce(模块名, "E冲锋启动 冲锋创建", "施法者", 获取句柄ID(state.施法者), "位移ID", state.位移ID, "方向角", state.方向角, "距离", 冲锋距离, "目标距离", 目标距离);
  if (state.位移ID === 0) E冲锋结束(state.施法者, "中断", 0);
}

function E结算当前斩击(this: void, state: 克劳德E状态): void {
  const caster = state.施法者;
  const 当前方向角 = state.方向角;
  const centerX = 获取单位X(caster) + 计算余弦(当前方向角 * 角度转弧度) * 配置.斩击中心偏移;
  const centerY = 获取单位Y(caster) + 计算正弦(当前方向角 * 角度转弧度) * 配置.斩击中心偏移;
  const targets = 获取范围敌军(caster, centerX, centerY, 配置.斩击范围);
  const validTargets: any[] = [];
  for (const target of targets) {
    if (!目标合法(caster, target)) continue;
    validTargets.push(target);
    if (目标未记录(state, target)) state.命中目标.push(target);
    施加眩晕(caster, target, 配置.斩击控制秒, "克劳德-E-劈砍硬直", "技能");
    创建点特效({ 模型路径: 配置.命中刀光模型, X: 获取单位X(target), Y: 获取单位Y(target), Z: 50, 面向角度: GetRandomDirectionDeg(), 缩放: 配置.命中刀光缩放, 持续秒: 配置.命中刀光持续秒, 红: 255, 绿: 80, 蓝: 0, 透明度: 255 });
  }
  if (validTargets.length > 0) {
    造成批量AOE技能伤害({
      来源: caster,
      目标列表: validTargets,
      伤害: 读取单位攻击力(caster) * 配置.斩击伤害倍率[state.斩击次数 - 1],
      伤害类型: 物理伤害类型,
      attack: true,
      ranged: false,
      attackType: 攻击类型,
      来源类型: "单位技能",
      技能ID,
      技能实例ID: state.技能实例ID,
      标签: `克劳德-E-${state.斩击次数}斩`,
    });
  }
  创建点特效({ 模型路径: 配置.普通刀光模型, X: centerX, Y: centerY, Z: 50, 面向角度: 当前方向角, 缩放: 配置.普通刀光缩放, 持续秒: 配置.普通刀光持续秒 });
  const textX = 获取单位X(caster) + 计算余弦(当前方向角 * 角度转弧度) * 配置.斩击文字偏移;
  const textY = 获取单位Y(caster) + 计算正弦(当前方向角 * 角度转弧度) * 配置.斩击文字偏移;
  CreateFloatTextAtPoint(textX, textY, 配置.斩击文字[state.斩击次数 - 1], { height: 配置.斩击文字Z高度, size: 配置.斩击文字字号[state.斩击次数 - 1], red: 255, green: 214, blue: 0, alpha: 255, duration: 配置.斩击文字持续秒, speedX: 0, speedY: 0 });
}

function E执行斩击(this: void, variable?: any): void {
  const state = variable as 克劳德E状态 | undefined;
  if (state == null || !state.进行中 || !单位存活(state.施法者)) {
    debugLogForce(模块名, "E执行斩击 前置不满足", "状态存在", state != null, "进行中", state?.进行中, "施法者存活", state?.施法者 == null ? false : 单位存活(state.施法者));
    if (state != null) 清理E状态(state);
    return;
  }
  state.斩击回调ID = 0;
  state.斩击次数 += 1;
  debugLogForce(模块名, "E执行斩击", "施法者", 获取句柄ID(state.施法者), "第", state.斩击次数, "斩");
  设置动作(state.施法者, 配置.斩击动作序号[state.斩击次数 - 1]);
  设置时间流速(state.施法者, 2);
  E结算当前斩击(state);
  if (state.斩击次数 < 3) {
    state.斩击回调ID = addDelayedCallback(配置.斩击间隔秒 * 1000, E执行斩击 as unknown as (this: void, variable?: any) => void, state);
    return;
  }
  state.等待输入 = true;
  移除单位暂停(state.施法者, 暂停来源);
  设置时间流速(state.施法者, 1);
  设置技能可用(获取单位拥有者(state.施法者), 技能ID, false);
  添加技能(state.施法者, 二段技能ID);
  debugLogForce(模块名, "E三斩完成 等待二段输入");
  state.窗口回调ID = addDelayedCallback(配置.二段窗口秒 * 1000, E窗口结算 as unknown as (this: void, variable?: any) => void, state);
}

function E强化结束(this: void, target: any, reason: string, moveId: number): void {
  const record = 强化击退表[moveId];
  delete 强化击退表[moveId];
  if (record == null || !单位存活(target)) return;
  移除单位暂停(target, `克劳德-E-强化追击-${moveId}`);
  设置单位飞行高度(target, 获取单位默认飞行高度(target), 0);
  if (reason === "撞墙") 施加眩晕(record.施法者, target, 配置.撞墙眩晕秒, "克劳德-E-撞墙眩晕", "技能");
}

function E强化追击Tick(this: void): void {
  for (const key in 强化击退表) {
    const moveId = Number(key);
    const record = 强化击退表[moveId];
    if (record == null) continue;
    if (!单位存活(record.目标) || !单位存活(record.施法者)) {
      E强化结束(record.目标, "中断", moveId);
      continue;
    }
    设置动作名(record.目标, "Death");
    const x = 获取单位X(record.目标) + 计算余弦(record.方向角 * 角度转弧度) * 配置.强化追击每Tick距离;
    const y = 获取单位Y(record.目标) + 计算正弦(record.方向角 * 角度转弧度) * 配置.强化追击每Tick距离;
    if (判断地形可行走(x, y, 可行走路径类型)) {
      E强化结束(record.目标, "撞墙", moveId);
      continue;
    }
    设置单位X(record.目标, x);
    设置单位Y(record.目标, y);
    设置单位飞行高度(record.目标, 获取单位飞行高度(record.目标) + 配置.强化追击每Tick高度, 0);
    record.Tick += 1;
    if (record.Tick >= 配置.强化追击Tick数) E强化结束(record.目标, "完成", moveId);
  }
  if (Object.keys(强化击退表).length === 0 && 强化击退驱动ID > 0) {
    removePeriodicCallback(强化击退驱动ID);
    强化击退驱动ID = 0;
  }
}

interface E强化追击延迟参数 {
  施法者: any;
  目标: any;
  方向角: number;
}

interface E强化伤害参数 {
  施法者: any;
  目标列表: any[];
  技能实例ID?: number;
}

function E强化追击延迟启动(this: void, variable?: any): void {
  const 参数 = variable as E强化追击延迟参数 | undefined;
  if (参数 == null || !单位存活(参数.施法者) || !单位存活(参数.目标)) return;
  启动E强化追击(参数.施法者, 参数.目标, 参数.方向角);
}

function 启动E强化追击(this: void, caster: any, target: any, direction: number): void {
  下一个强化击退ID += 1;
  const moveId = 下一个强化击退ID;
  强化击退表[moveId] = { 施法者: caster, 目标: target, 方向角: direction, Tick: 0 };
  确保单位可设置飞行高度(target);
  添加单位暂停(target, `克劳德-E-强化追击-${moveId}`);
  if (强化击退驱动ID === 0) 强化击退驱动ID = addPeriodicCallback(配置.强化追击间隔秒 * 1000, E强化追击Tick);
}

function E强化伤害结算(this: void, variable?: any): void {
  const 参数 = variable as E强化伤害参数 | undefined;
  if (参数 == null || !单位存活(参数.施法者)) return;
  const validTargets: any[] = [];
  for (const target of 参数.目标列表) {
    if (!目标合法(参数.施法者, target)) continue;
    validTargets.push(target);
    标记凶斩命中(参数.施法者, target, 配置.凶斩联动标记持续秒);
  }
  if (validTargets.length === 0) return;
  造成批量AOE技能伤害({
    来源: 参数.施法者,
    目标列表: validTargets,
    伤害: 读取单位攻击力(参数.施法者) * 配置.强化伤害倍率,
    伤害类型: 魔法伤害类型,
    attack: true,
    ranged: false,
    attackType: 攻击类型,
    来源类型: "单位技能",
    技能ID,
    技能实例ID: 参数.技能实例ID,
    标签: "克劳德-E-强化击飞",
  });
}

function E强化结算(this: void, state: 克劳德E状态): void {
  debugLogForce(模块名, "E强化结算 进入", "施法者", 获取句柄ID(state.施法者), "进行中", state.进行中, "阶段", state.阶段, "命中目标数", state.命中目标.length);
  if (!state.进行中 || state.阶段 !== 2) return;
  state.斩击回调ID = 0;
  const caster = state.施法者;
  播放E音效(caster, 配置.强化音效键);
  创建E强化击飞表现(caster, state.方向角);
  const validTargets: any[] = [];
  for (const target of state.命中目标) {
    if (!目标合法(caster, target)) continue;
    validTargets.push(target);
    addDelayedCallback(80, E强化追击延迟启动 as unknown as (this: void, variable?: any) => void, { 施法者: caster, 目标: target, 方向角: state.方向角 } as E强化追击延迟参数);
  }
  debugLogForce(模块名, "E强化结算 结算", "合法目标", validTargets.length, "强化伤害", 读取单位攻击力(caster) * 配置.强化伤害倍率);
  if (validTargets.length > 0) {
    addDelayedCallback(配置.强化伤害延迟秒 * 1000, E强化伤害结算 as unknown as (this: void, variable?: any) => void, {
      施法者: caster,
      目标列表: validTargets,
      技能实例ID: state.技能实例ID,
    } as E强化伤害参数);
  }
  清理E状态(state);
}

function 消耗E强化魔法(this: void, caster: any): boolean {
  const maxMana = 获取单位状态(caster, 最大魔法状态) || 0;
  const cost = maxMana * 配置.强化追加魔耗比例;
  const currentMana = 获取单位状态(caster, 当前魔法状态) || 0;
  debugLogForce(模块名, "E强化魔耗判断", "施法者", 获取句柄ID(caster), "总需求", cost, "当前蓝", currentMana);
  if (cost <= 0 || currentMana < cost) {
    debugLogForce(模块名, "E强化魔耗不足 返回false", "总需求", cost, "当前蓝", currentMana);
    return false;
  }
  减少魔法值(caster, cost, false, false);
  return true;
}

function 释放E初段(this: void, state: 克劳德E状态, caster: any, skillInstanceId?: number): void {
  debugLogForce(模块名, "释放E初段 进入", "施法者", caster == null ? "nil" : 获取句柄ID(caster), "已在进行", state.进行中, "技能实例ID", skillInstanceId);
  if (state.进行中) return;
  state.施法者 = caster;
  state.进行中 = true;
  state.阶段 = 0;
  state.等待输入 = false;
  state.技能实例ID = skillInstanceId;
  state.斩击次数 = 0;
  state.命中目标 = [];
  state.目标X = 获取技能目标X();
  state.目标Y = 获取技能目标Y();
  state.方向角 = 计算反正切(获取技能目标Y() - 获取单位Y(caster), 获取技能目标X() - 获取单位X(caster)) * 弧度转角度;
  debugLogForce(模块名, "释放E初段 正常路径", "方向角", state.方向角);
  添加单位暂停(caster, 暂停来源);
  设置动作(caster, 配置.斩击动作序号[0]);
  设置时间流速(caster, 配置.动作时间流速);
  addDelayedCallback(20, E冲锋启动 as unknown as (this: void, variable?: any) => void, state);
}

function 释放E二段(this: void, state: 克劳德E状态, caster: any): void {
  debugLogForce(模块名, "释放E二段 进入", "施法者", 获取句柄ID(caster), "进行中", state.进行中, "等待输入", state.等待输入, "阶段", state.阶段);
  if (!state.进行中 || !state.等待输入 || state.阶段 !== 0 || !消耗E强化魔法(caster)) return;
  state.阶段 = 2;
  state.等待输入 = false;
  debugLogForce(模块名, "释放E二段 成功进入强化阶段 等待窗口结算");
  移除技能(caster, 二段技能ID);
  移除技能(caster, 三段技能ID);
}

function E初段可释放(this: void, state: 克劳德E状态, _caster: any): boolean {
  return !state.进行中;
}

function E二段可释放(this: void, state: 克劳德E状态, _caster: any): boolean {
  return state.进行中 && state.等待输入 && state.阶段 === 0;
}

function 克劳德E死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0 || 获取单位类型ID(dyingUnit) !== 单位类型ID) return;
  const state = 状态表[获取句柄ID(dyingUnit)];
  debugLogForce(模块名, "克劳德E死亡清理", "死亡单位", 获取句柄ID(dyingUnit), "状态存在", state != null);
  if (state != null) 清理E状态(state);
}

注册单位技能壳监听({
  名称: "克劳德-凶斩",
  单位类型ID,
  技能ID,
  获取或创建上下文: 获取或创建E状态,
  可释放: E初段可释放,
  释放技能: 释放E初段,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 5,
});
注册单位技能壳监听({
  名称: "克劳德-凶斩二段",
  单位类型ID,
  技能ID: 二段技能ID,
  获取或创建上下文: 获取或创建E状态,
  可释放: E二段可释放,
  释放技能: 释放E二段,
  创建独立技能实例: false,
});
registerDeathListener(克劳德E死亡清理);

export {};
