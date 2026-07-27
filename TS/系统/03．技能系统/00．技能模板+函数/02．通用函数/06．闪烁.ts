/** @noSelfInFile */
/**
 * 技能通用函数 - 闪烁/瞬移便捷封装
 *
 * 说明：
 * 1. 这是技能侧快捷模板，不修改底层位移系统。
 * 2. 支持开始特效、结束特效、闪烁耗时、闪烁期间隐藏单位、结束后重新选中单位。
 * 3. 重新选中是本地玩家表现：默认让单位拥有者重新选中该单位。
 */

import { 尝试阻止自身位移技能, 执行战斗自身传送到坐标 } from "./20．位移技能限制";

const jass = require("jass.common") as any;

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};

const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWETimerDestroyEffect: (duration: number, effect: any) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};

const AddSpecialEffect = jass["AddSpecialEffect"] as (model: string, x: number, y: number) => any;
const GetUnitX = jass["GetUnitX"] as (u: any) => number;
const GetUnitY = jass["GetUnitY"] as (u: any) => number;
const GetUnitFacing = jass["GetUnitFacing"] as (u: any) => number;
const GetOwningPlayer = jass["GetOwningPlayer"] as (u: any) => any;
const GetLocalPlayer = jass["GetLocalPlayer"] as () => any;
const ClearSelection = jass["ClearSelection"] as () => void;
const SelectUnit = jass["SelectUnit"] as (u: any, flag: boolean) => void;
const ShowUnit = jass["ShowUnit"] as (u: any, flag: boolean) => void;
const IsUnitPaused = jass["IsUnitPaused"] as (u: any) => boolean;
const SetUnitFacing = jass["SetUnitFacing"] as (u: any, angle: number) => void;
const GetUnitState = jass["GetUnitState"] as (u: any, state: any) => number;

const TICK_INTERVAL = 0.01;
const UNIT_ALIVE_LIFE = 0.405;
const 闪烁暂停来源 = "技能闪烁";

export interface 闪烁参数 {
  目标X: number;
  目标Y: number;
  持续时间: number;
  朝向?: number;
  开始特效?: string;
  结束特效?: string;
  特效生命周期?: number;
  闪烁期间暂停单位?: boolean;
  结束后选中单位?: boolean;
}

interface 闪烁实例 {
  ID: number;
  单位: any;
  目标X: number;
  目标Y: number;
  剩余时间: number;
  朝向?: number;
  结束特效?: string;
  特效生命周期: number;
  闪烁期间暂停单位: boolean;
  结束后选中单位: boolean;
  单位原本已暂停: boolean;
}

const 活动闪烁列表: 闪烁实例[] = [];
const 闪烁映射: Record<number, 闪烁实例 | undefined> = {};
let 下一个闪烁ID = 1;
let 已注册闪烁Tick = false;

function 单位存活(unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitState(unit, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

function 播放闪烁特效(模型: string | undefined, x: number, y: number, 生命周期: number): void {
  if (模型 == null || 模型 === "") return;
  const effect = AddSpecialEffect(模型, x, y);
  if (effect == null || effect === 0) return;
  YDWETimerDestroyEffect(生命周期, effect);
}

function 本地为单位拥有者重新选中单位(单位: any): void {
  const 拥有者 = GetOwningPlayer(单位);
  if (GetLocalPlayer() === 拥有者) {
    ClearSelection();
    SelectUnit(单位, true);
  }
}

function 结束闪烁实例(实例: 闪烁实例, 是否完成: boolean): void {
  delete 闪烁映射[实例.ID];

  const idx = 活动闪烁列表.indexOf(实例);
  if (idx >= 0) {
    活动闪烁列表.splice(idx, 1);
  }

  if (是否完成 && 单位存活(实例.单位)) {
    const 已完成位移 = 执行战斗自身传送到坐标(实例.单位, 实例.目标X, 实例.目标Y);
    if (已完成位移 && 实例.朝向 != null) SetUnitFacing(实例.单位, 实例.朝向);
    ShowUnit(实例.单位, true);
    if (实例.闪烁期间暂停单位 && !实例.单位原本已暂停) {
      移除单位暂停(实例.单位, 闪烁暂停来源);
    }
    if (已完成位移) 播放闪烁特效(实例.结束特效, 实例.目标X, 实例.目标Y, 实例.特效生命周期);
    if (已完成位移 && 实例.结束后选中单位) {
      本地为单位拥有者重新选中单位(实例.单位);
    }
  } else if (实例.闪烁期间暂停单位 && 单位存活(实例.单位) && !实例.单位原本已暂停) {
    移除单位暂停(实例.单位, 闪烁暂停来源);
    ShowUnit(实例.单位, true);
  }

  if (活动闪烁列表.length === 0 && 已注册闪烁Tick) {
    已注册闪烁Tick = false;
    offTick10ms(on闪烁Tick);
  }
}

function on闪烁Tick(): void {
  let i = 0;
  while (i < 活动闪烁列表.length) {
    const 实例 = 活动闪烁列表[i];
    if (!单位存活(实例.单位)) {
      结束闪烁实例(实例, false);
      continue;
    }

    实例.剩余时间 -= TICK_INTERVAL;
    if (实例.剩余时间 <= 0) {
      结束闪烁实例(实例, true);
      continue;
    }

    i += 1;
  }
}

function 注册闪烁Tick(): void {
  if (已注册闪烁Tick) return;
  已注册闪烁Tick = true;
  onTick10ms(on闪烁Tick);
}

export function 开始闪烁(单位: any, 参数: 闪烁参数): number {
  if (!单位存活(单位)) return 0;
  if (尝试阻止自身位移技能(单位)) return 0;

  const 持续时间 = 参数.持续时间 > 0 ? 参数.持续时间 : 0;
  const 特效生命周期 = 参数.特效生命周期 != null && 参数.特效生命周期 > 0
    ? 参数.特效生命周期
    : 1.0;
  const 闪烁期间暂停单位 = 参数.闪烁期间暂停单位 !== false;
  const 结束后选中单位 = 参数.结束后选中单位 !== false;

  const 当前X = GetUnitX(单位);
  const 当前Y = GetUnitY(单位);

  播放闪烁特效(参数.开始特效, 当前X, 当前Y, 特效生命周期);

  const 原本已暂停 = IsUnitPaused(单位);
  if (闪烁期间暂停单位 && !原本已暂停) {
    添加单位暂停(单位, 闪烁暂停来源);
  }

  ShowUnit(单位, false);

  if (持续时间 <= 0) {
    const 已完成位移 = 执行战斗自身传送到坐标(单位, 参数.目标X, 参数.目标Y);
    if (已完成位移 && 参数.朝向 != null) SetUnitFacing(单位, 参数.朝向);
    else if (已完成位移) SetUnitFacing(单位, GetUnitFacing(单位));
    ShowUnit(单位, true);
    if (闪烁期间暂停单位 && !原本已暂停) {
      移除单位暂停(单位, 闪烁暂停来源);
    }
    if (已完成位移) 播放闪烁特效(参数.结束特效, 参数.目标X, 参数.目标Y, 特效生命周期);
    if (已完成位移 && 结束后选中单位) {
      本地为单位拥有者重新选中单位(单位);
    }
    return 0;
  }

  const id = 下一个闪烁ID;
  下一个闪烁ID += 1;

  const 实例: 闪烁实例 = {
    ID: id,
    单位,
    目标X: 参数.目标X,
    目标Y: 参数.目标Y,
    剩余时间: 持续时间,
    朝向: 参数.朝向,
    结束特效: 参数.结束特效,
    特效生命周期,
    闪烁期间暂停单位,
    结束后选中单位,
    单位原本已暂停: 原本已暂停,
  };

  活动闪烁列表.push(实例);
  闪烁映射[id] = 实例;
  注册闪烁Tick();
  return id;
}

export function 停止闪烁(id: number): void {
  const 实例 = 闪烁映射[id];
  if (!实例) return;
  结束闪烁实例(实例, false);
}
