/** @noSelfInFile */

import {
  创建世界坐标进度UI,
  更新世界坐标进度UI,
  设置世界坐标进度UI显示,
  销毁世界坐标进度UI,
  type 世界坐标进度UI,
} from "../../../../09．表现系统/15．世界坐标进度UI";
import { 祖地双灵卫副本配置 } from "./01．祖地双灵卫副本配置";
import {
  祖地双灵卫副本状态,
  祖地双灵卫试炼是否全部完成,
  type 祖地双灵卫试炼状态,
  type 祖地双灵卫试炼类型,
} from "./02．祖地双灵卫副本状态";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (
    this: void,
    callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void,
  ) => void;
};
const { registerAppliedFinalHealListener } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerAppliedFinalHealListener: (
    this: void,
    callback: (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => void,
  ) => void;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs?: number) => void;
};

const Player = jass.Player as (this: void, playerId: number) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitPathing = jass.SetUnitPathing as (this: void, unit: any, enabled: boolean) => void;
const PauseUnit = jass.PauseUnit as (this: void, unit: any, paused: boolean) => void;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const SetUnitStateJapi = japi.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const DzSetUnitModel = japi.DzSetUnitModel as ((this: void, unit: any, model: string) => void) | undefined;
const DzSetUnitName = japi.DzSetUnitName as ((this: void, unit: any, name: string) => void) | undefined;

const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const 试炼刷新间隔毫秒 = 100;
const 玩家最小ID = 0;
const 玩家最大ID = 5;

type 祖地双灵卫试炼全部完成回调 = (this: void) => void;

const 试炼全部完成回调列表: 祖地双灵卫试炼全部完成回调[] = [];
let 试炼事件已注册 = false;
let 试炼周期ID = 0;

function 是有效玩家ID(this: void, playerId: number): boolean {
  return playerId >= 玩家最小ID && playerId <= 玩家最大ID;
}

function 获取来源玩家ID(this: void, source: any): number {
  if (source == null || source === 0) return -1;
  const owner = GetOwningPlayer(source);
  if (owner == null) return -1;
  const playerId = GetPlayerId(owner);
  return 是有效玩家ID(playerId) ? playerId : -1;
}

function 设置试炼靶生命(this: void, unit: any, maximum: number, current: number): void {
  if (unit == null || unit === 0) return;
  SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, maximum);
  SetUnitState(unit, UNIT_STATE_LIFE, current);
}

function 创建试炼靶(this: void, ownerId: number, x: number, y: number, facing: number, maximum: number, current: number): any {
  const unitTypeId = stringToFourCCSafe(祖地双灵卫副本配置.试炼.靶单位ID);
  if (unitTypeId === 0) return null;
  const unit = 创建单位并登记排泄安全(Player(ownerId), unitTypeId, x, y, facing);
  if (unit == null || unit === 0) return null;
  if (DzSetUnitModel != null) DzSetUnitModel(unit, 祖地双灵卫副本配置.试炼.靶模型);
  SetUnitPathing(unit, false);
  PauseUnit(unit, true);
  设置试炼靶生命(unit, maximum, current);
  return unit;
}

function 设置试炼靶名称(this: void, unit: any, name: string): void {
  if (unit != null && unit !== 0 && DzSetUnitName != null) DzSetUnitName(unit, name);
}

function 创建试炼进度UI(
  this: void,
  x: number,
  y: number,
  maximum: number,
  current: number,
  title: string,
  type: "危险" | "自然" | "奥术",
  suffix: string,
): 世界坐标进度UI | null {
  return 创建世界坐标进度UI({
    X: x,
    Y: y,
    Z: 300,
    最大值: maximum,
    当前值: current,
    标题: title,
    数值后缀: suffix,
    类型: type,
    平滑过渡秒: 0.1,
    初始显示: true,
    雾中可见: false,
  });
}

function 重置试炼状态值(this: void, state: 祖地双灵卫试炼状态): void {
  state.锁定玩家ID = -1;
  state.开始时间毫秒 = 0;
  state.累计数值 = 0;
}

function 广播埃德里安(this: void, text: string): void {
  const unit = 祖地双灵卫副本状态.埃德里安单位;
  if (unit != null && unit !== 0) 广播单位提示(unit, text, 4200);
}

function 重建持续伤害靶(this: void): void {
  const state = 祖地双灵卫副本状态.试炼.持续伤害;
  if (state.目标单位 != null && state.目标单位 !== 0) RemoveUnit(state.目标单位);
  const cfg = 祖地双灵卫副本配置.试炼;
  state.目标单位 = 创建试炼靶(
    cfg.伤害靶玩家ID,
    cfg.持续伤害.X,
    cfg.持续伤害.Y,
    cfg.持续伤害.朝向,
    cfg.持续伤害.最大生命,
    cfg.持续伤害.最大生命,
  );
  设置试炼靶名称(state.目标单位, "持续输出试炼靶");
}

function 重建单次伤害靶(this: void): void {
  const state = 祖地双灵卫副本状态.试炼.单次伤害;
  if (state.目标单位 != null && state.目标单位 !== 0) RemoveUnit(state.目标单位);
  const cfg = 祖地双灵卫副本配置.试炼;
  state.目标单位 = 创建试炼靶(
    cfg.伤害靶玩家ID,
    cfg.单次伤害.X,
    cfg.单次伤害.Y,
    cfg.单次伤害.朝向,
    cfg.单次伤害.最大生命,
    cfg.单次伤害.最大生命,
  );
  设置试炼靶名称(state.目标单位, "爆发伤害试炼靶");
}

function 重建治疗靶(this: void): void {
  const state = 祖地双灵卫副本状态.试炼.治疗;
  if (state.目标单位 != null && state.目标单位 !== 0) RemoveUnit(state.目标单位);
  const cfg = 祖地双灵卫副本配置.试炼;
  state.目标单位 = 创建试炼靶(
    cfg.治疗靶玩家ID,
    cfg.治疗.X,
    cfg.治疗.Y,
    cfg.治疗.朝向,
    cfg.治疗.最大生命,
    cfg.治疗.初始生命,
  );
  设置试炼靶名称(state.目标单位, "治疗试炼靶");
}

function 重置持续伤害试炼(this: void): void {
  const state = 祖地双灵卫副本状态.试炼.持续伤害;
  if (state.已完成) return;
  重置试炼状态值(state);
  const cfg = 祖地双灵卫副本配置.试炼.持续伤害;
  重建持续伤害靶();
  if (state.进度UI != null) state.进度UI.标题 = "持续输出 0 DPS";
  更新世界坐标进度UI(state.进度UI as 世界坐标进度UI | null, cfg.持续秒, true);
}

function 重置单次伤害试炼(this: void): void {
  const state = 祖地双灵卫副本状态.试炼.单次伤害;
  if (state.已完成) return;
  重置试炼状态值(state);
  重建单次伤害靶();
  更新世界坐标进度UI(state.进度UI as 世界坐标进度UI | null, 0, true);
}

function 重置治疗试炼(this: void): void {
  const state = 祖地双灵卫副本状态.试炼.治疗;
  if (state.已完成) return;
  重置试炼状态值(state);
  const cfg = 祖地双灵卫副本配置.试炼.治疗;
  重建治疗靶();
  更新世界坐标进度UI(state.进度UI as 世界坐标进度UI | null, cfg.持续秒, true);
}

function 派发试炼全部完成(this: void): void {
  if (祖地双灵卫副本状态.试炼全部完成已派发 || !祖地双灵卫试炼是否全部完成()) return;
  祖地双灵卫副本状态.试炼全部完成已派发 = true;
  for (let i = 0; i < 试炼全部完成回调列表.length; i++) {
    试炼全部完成回调列表[i]();
  }
}

function 完成试炼(this: void, type: 祖地双灵卫试炼类型): void {
  const state = 祖地双灵卫副本状态.试炼[type];
  if (state.已完成) return;
  state.已完成 = true;
  state.锁定玩家ID = -1;
  state.开始时间毫秒 = 0;
  if (state.目标单位 != null && state.目标单位 !== 0) RemoveUnit(state.目标单位);
  state.目标单位 = null;
  销毁世界坐标进度UI(state.进度UI as 世界坐标进度UI | null);
  state.进度UI = null;
  if (type === "持续伤害") 广播埃德里安("二十息间力量未衰，节奏也没有乱。很好，这一项通过了。");
  else if (type === "单次伤害") 广播埃德里安("这一击足以破开祖地的旧甲。不错，这一项通过了。");
  else 广播埃德里安("危急之时仍能稳住同伴的性命。很好，这一项通过了。");
  派发试炼全部完成();
}

function 处理持续伤害(this: void, attacker: any, applied: number): void {
  const state = 祖地双灵卫副本状态.试炼.持续伤害;
  if (state.已完成 || !(applied > 0)) return;
  const playerId = 获取来源玩家ID(attacker);
  if (playerId < 0) return;
  if (state.锁定玩家ID >= 0 && state.锁定玩家ID !== playerId) {
    广播埃德里安("试炼只认可一人的力量。有人插手，持续输出试炼重新开始。");
    重置持续伤害试炼();
    return;
  }
  if (state.锁定玩家ID < 0) {
    state.锁定玩家ID = playerId;
    state.开始时间毫秒 = getServerTime();
  }
  state.累计数值 += applied;
}

function 处理单次伤害(this: void, attacker: any, applied: number): void {
  const state = 祖地双灵卫副本状态.试炼.单次伤害;
  if (state.已完成 || !(applied > 0)) return;
  const playerId = 获取来源玩家ID(attacker);
  if (playerId < 0) return;
  if (state.锁定玩家ID >= 0 && state.锁定玩家ID !== playerId) {
    广播埃德里安("试炼只认可一人的力量。有人插手，爆发伤害试炼重新开始。");
    重置单次伤害试炼();
    return;
  }
  if (state.锁定玩家ID < 0) state.锁定玩家ID = playerId;
  if (applied > state.累计数值) state.累计数值 = applied;
  const requirement = 祖地双灵卫副本配置.试炼.单次伤害.单次伤害要求;
  更新世界坐标进度UI(state.进度UI as 世界坐标进度UI | null, state.累计数值 > requirement ? requirement : state.累计数值);
  if (applied > requirement) 完成试炼("单次伤害");
}

function on祖地双灵卫试炼最终伤害(this: void, target: any, attacker: any, applied: number, _snapshot: any): void {
  if (!祖地双灵卫副本状态.试炼已创建) return;
  if (target === 祖地双灵卫副本状态.试炼.持续伤害.目标单位) {
    处理持续伤害(attacker, applied);
    return;
  }
  if (target === 祖地双灵卫副本状态.试炼.单次伤害.目标单位) 处理单次伤害(attacker, applied);
}

function on祖地双灵卫试炼最终治疗(this: void, source: any, target: any, amount: number, _isItemHeal: boolean): void {
  if (!祖地双灵卫副本状态.试炼已创建 || target !== 祖地双灵卫副本状态.试炼.治疗.目标单位 || !(amount > 0)) return;
  const state = 祖地双灵卫副本状态.试炼.治疗;
  if (state.已完成) return;
  const playerId = 获取来源玩家ID(source);
  if (playerId < 0) return;
  if (state.锁定玩家ID >= 0 && state.锁定玩家ID !== playerId) {
    广播埃德里安("试炼只认可一人的力量。有人插手，治疗试炼重新开始。");
    重置治疗试炼();
    return;
  }
  if (state.锁定玩家ID < 0) {
    state.锁定玩家ID = playerId;
    state.开始时间毫秒 = getServerTime();
  }
  const cfg = 祖地双灵卫副本配置.试炼.治疗;
  const currentLife = GetUnitState(state.目标单位, UNIT_STATE_LIFE);
  if (currentLife >= cfg.最大生命) 完成试炼("治疗");
}

function 更新持续伤害试炼(this: void, now: number): void {
  const state = 祖地双灵卫副本状态.试炼.持续伤害;
  if (state.已完成 || state.开始时间毫秒 <= 0) return;
  const cfg = 祖地双灵卫副本配置.试炼.持续伤害;
  const elapsed = now - state.开始时间毫秒;
  let remaining = cfg.持续秒 - elapsed / 1000;
  if (remaining < 0) remaining = 0;
  if (state.进度UI != null) {
    const elapsedSeconds = elapsed > 0 ? elapsed / 1000 : 0.1;
    const currentDps = jass.R2I(state.累计数值 / elapsedSeconds) as number;
    state.进度UI.标题 = "持续输出 " + tostring(currentDps) + " DPS";
  }
  更新世界坐标进度UI(state.进度UI as 世界坐标进度UI | null, remaining, true);
  if (elapsed < cfg.持续秒 * 1000) return;
  const requirement = cfg.每秒伤害要求 * cfg.持续秒;
  if (state.累计数值 >= requirement) {
    state.累计数值 = requirement;
    完成试炼("持续伤害");
    return;
  }
  广播埃德里安("持续输出没有达到要求。调整呼吸，再来一次。");
  重置持续伤害试炼();
}

function 更新治疗试炼(this: void, now: number): void {
  const state = 祖地双灵卫副本状态.试炼.治疗;
  if (state.已完成 || state.开始时间毫秒 <= 0) return;
  const cfg = 祖地双灵卫副本配置.试炼.治疗;
  const currentLife = GetUnitState(state.目标单位, UNIT_STATE_LIFE);
  if (currentLife >= cfg.最大生命) {
    完成试炼("治疗");
    return;
  }
  let remaining = cfg.持续秒 - (now - state.开始时间毫秒) / 1000;
  if (remaining < 0) remaining = 0;
  更新世界坐标进度UI(state.进度UI as 世界坐标进度UI | null, remaining, true);
  if (remaining <= 0) {
    广播埃德里安("治疗慢了一步。把握好时机，重新开始。");
    重置治疗试炼();
  }
}

function on祖地双灵卫试炼周期(this: void): void {
  if (!祖地双灵卫副本状态.试炼已创建) return;
  const now = getServerTime();
  更新持续伤害试炼(now);
  更新治疗试炼(now);
}

function 清理试炼项(this: void, state: 祖地双灵卫试炼状态): void {
  销毁世界坐标进度UI(state.进度UI as 世界坐标进度UI | null);
  state.进度UI = null;
  if (state.目标单位 != null && state.目标单位 !== 0) RemoveUnit(state.目标单位);
  state.目标单位 = null;
  state.已完成 = false;
  重置试炼状态值(state);
}

export function register祖地双灵卫试炼全部完成Listener(this: void, callback: 祖地双灵卫试炼全部完成回调): void {
  if (typeof callback !== "function") return;
  试炼全部完成回调列表.push(callback);
}

export function 创建祖地双灵卫试炼(this: void): boolean {
  if (祖地双灵卫副本状态.试炼已创建) return true;
  const cfg = 祖地双灵卫副本配置.试炼;
  const 持续伤害状态 = 祖地双灵卫副本状态.试炼.持续伤害;
  const 单次伤害状态 = 祖地双灵卫副本状态.试炼.单次伤害;
  const 治疗状态 = 祖地双灵卫副本状态.试炼.治疗;

  持续伤害状态.目标单位 = 创建试炼靶(cfg.伤害靶玩家ID, cfg.持续伤害.X, cfg.持续伤害.Y, cfg.持续伤害.朝向, cfg.持续伤害.最大生命, cfg.持续伤害.最大生命);
  单次伤害状态.目标单位 = 创建试炼靶(cfg.伤害靶玩家ID, cfg.单次伤害.X, cfg.单次伤害.Y, cfg.单次伤害.朝向, cfg.单次伤害.最大生命, cfg.单次伤害.最大生命);
  治疗状态.目标单位 = 创建试炼靶(cfg.治疗靶玩家ID, cfg.治疗.X, cfg.治疗.Y, cfg.治疗.朝向, cfg.治疗.最大生命, cfg.治疗.初始生命);
  设置试炼靶名称(持续伤害状态.目标单位, "持续输出试炼靶");
  设置试炼靶名称(单次伤害状态.目标单位, "爆发伤害试炼靶");
  设置试炼靶名称(治疗状态.目标单位, "治疗试炼靶");

  持续伤害状态.进度UI = 创建试炼进度UI(cfg.持续伤害.X, cfg.持续伤害.Y, cfg.持续伤害.持续秒, cfg.持续伤害.持续秒, "持续输出 0 DPS", "危险", "秒");
  单次伤害状态.进度UI = 创建试炼进度UI(cfg.单次伤害.X, cfg.单次伤害.Y, cfg.单次伤害.单次伤害要求, 0, "单次伤害", "奥术", "");
  治疗状态.进度UI = 创建试炼进度UI(cfg.治疗.X, cfg.治疗.Y, cfg.治疗.持续秒, cfg.治疗.持续秒, "限时治疗", "自然", "秒");

  const created = 持续伤害状态.目标单位 != null
    && 单次伤害状态.目标单位 != null
    && 治疗状态.目标单位 != null
    && 持续伤害状态.进度UI != null
    && 单次伤害状态.进度UI != null
    && 治疗状态.进度UI != null;
  if (!created) {
    清理祖地双灵卫试炼();
    return false;
  }

  祖地双灵卫副本状态.试炼已创建 = true;
  祖地双灵卫副本状态.试炼全部完成已派发 = false;
  if (试炼周期ID === 0) 试炼周期ID = addPeriodicCallback(试炼刷新间隔毫秒, on祖地双灵卫试炼周期);
  return true;
}

export function 清理祖地双灵卫试炼(this: void): void {
  if (试炼周期ID !== 0) {
    removePeriodicCallback(试炼周期ID);
    试炼周期ID = 0;
  }
  清理试炼项(祖地双灵卫副本状态.试炼.持续伤害);
  清理试炼项(祖地双灵卫副本状态.试炼.单次伤害);
  清理试炼项(祖地双灵卫副本状态.试炼.治疗);
  祖地双灵卫副本状态.试炼已创建 = false;
  祖地双灵卫副本状态.试炼全部完成已派发 = false;
}

export function init祖地双灵卫试炼(this: void): void {
  if (试炼事件已注册) return;
  试炼事件已注册 = true;
  registerAppliedFinalDamageListener(on祖地双灵卫试炼最终伤害);
  registerAppliedFinalHealListener(on祖地双灵卫试炼最终治疗);
}
