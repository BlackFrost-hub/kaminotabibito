/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 单位是否暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  单位是否暂停: (this: void, unit: any) => boolean;
};
// PlaySoundOnUnitBJ / PlaySoundAtPointBJ 是 Blizzard.j 函数，从 BJ 函数库取（jass.common 取到的是 nil）
const { PlaySoundOnUnitBJ, PlaySoundAtPointBJ } = require("lib.扩展函数.BJ函数.14．音效函数") as {
  PlaySoundOnUnitBJ: (this: void, soundHandle: any, volumePercent: number, whichUnit: any) => void;
  PlaySoundAtPointBJ: (this: void, soundHandle: any, volumePercent: number, x: number, y: number, z: number) => void;
};

const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const Cos = jass.Cos as (this: void, value: number) => number;
const Sin = jass.Sin as (this: void, value: number) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (this: void, unit: any, enabled: boolean) => void;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
let 飞刀碰撞枚举组: any = null;

function 枚举飞刀碰撞敌人(this: void, source: any, x: number, y: number, radius: number): any[] {
  const result: any[] = [];
  if (飞刀碰撞枚举组 == null || 飞刀碰撞枚举组 === 0) 飞刀碰撞枚举组 = jass.CreateGroup();
  jass.GroupClear(飞刀碰撞枚举组);
  jass.GroupEnumUnitsInRange(飞刀碰撞枚举组, x, y, radius, null);
  while (true) {
    const unit = jass.FirstOfGroup(飞刀碰撞枚举组);
    if (unit == null || unit === 0) break;
    jass.GroupRemoveUnit(飞刀碰撞枚举组, unit);
    if (!单位存活(unit)) continue;
    if (jass.IsUnitType(unit, UNIT_TYPE_STRUCTURE)) continue;
    if (jass.IsUnitType(unit, UNIT_TYPE_MECHANICAL)) continue;
    if (jass.IsUnitType(unit, UNIT_TYPE_ANCIENT)) continue;
    if (!jass.IsUnitEnemy(unit, GetOwningPlayer(source))) continue;
    result.push(unit);
  }
  return result;
}

interface 咲夜周期任务 {
  ID: number;
  间隔毫秒: number;
  已累计毫秒: number;
  回调: (this: void, variable?: any) => void;
  变量?: any;
}

const 咲夜周期任务表: Record<number, 咲夜周期任务 | undefined> = {};
let 咲夜周期任务自增ID = 0;
let 咲夜周期任务数量 = 0;
let 咲夜周期驱动ID = 0;
const 咲夜周期驱动间隔毫秒 = 10;

function 推进咲夜周期任务(this: void): void {
  const ids: number[] = [];
  for (const key in 咲夜周期任务表) {
    const task = 咲夜周期任务表[key as unknown as number];
    if (task != null) ids.push(task.ID);
  }
  for (let i = 0; i < ids.length; i++) {
    const task = 咲夜周期任务表[ids[i]];
    if (task == null) continue;
    task.已累计毫秒 += 咲夜周期驱动间隔毫秒;
    if (task.已累计毫秒 < task.间隔毫秒) continue;
    task.已累计毫秒 -= task.间隔毫秒;
    task.回调(task.变量);
  }
}

export function 注册咲夜周期任务(
  this: void,
  intervalMs: number,
  callback: (this: void, variable?: any) => void,
  variable?: any,
): number {
  咲夜周期任务自增ID += 1;
  const id = 咲夜周期任务自增ID;
  咲夜周期任务表[id] = {
    ID: id,
    间隔毫秒: Math.max(咲夜周期驱动间隔毫秒, Math.round(intervalMs)),
    已累计毫秒: 0,
    回调: callback,
    变量: variable,
  };
  咲夜周期任务数量 += 1;
  if (咲夜周期驱动ID === 0) {
    咲夜周期驱动ID = addPeriodicCallback(咲夜周期驱动间隔毫秒, 推进咲夜周期任务);
  }
  return id;
}

export function 移除咲夜周期任务(this: void, id: number): void {
  if (id === 0 || 咲夜周期任务表[id] == null) return;
  delete 咲夜周期任务表[id];
  咲夜周期任务数量 -= 1;
  if (咲夜周期任务数量 <= 0 && 咲夜周期驱动ID !== 0) {
    removePeriodicCallback(咲夜周期驱动ID);
    咲夜周期驱动ID = 0;
    咲夜周期任务数量 = 0;
  }
}

export function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

export function 两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return jass.Atan2(y2 - y1, x2 - x1) / bj_DEGTORAD;
}

export function 极坐标X(this: void, x: number, distance: number, angle: number): number {
  return x + distance * Cos(angle * bj_DEGTORAD);
}

export function 极坐标Y(this: void, y: number, distance: number, angle: number): number {
  return y + distance * Sin(angle * bj_DEGTORAD);
}

export function 创建咲夜单位壳(this: void, caster: any, unitTypeId: number, x: number, y: number, facing: number): any {
  const shell = 创建单位并登记排泄安全(GetOwningPlayer(caster), unitTypeId, x, y, facing);
  if (shell == null || shell === 0) return null;
  SetUnitPathing(shell, false);
  SetUnitFlyHeight(shell, GetUnitDefaultFlyHeight(shell) + GetUnitFlyHeight(caster), 0);
  return shell;
}

export function 安全移除单位壳(this: void, unit: any): void {
  if (unit != null && unit !== 0) RemoveUnit(unit);
}

export function 播放咲夜单位音效(this: void, globalName: string, unit: any): void {
  const sound = (jglobals as any)[globalName];
  if (sound != null && sound !== 0 && unit != null && unit !== 0) PlaySoundOnUnitBJ(sound, 100, unit);
}

export function 播放咲夜坐标音效(this: void, globalName: string, x: number, y: number): void {
  const sound = (jglobals as any)[globalName];
  if (sound == null || sound === 0) return;
  // Blizzard.j 签名为坐标（非 location）；z 固定 0 对齐源
  PlaySoundAtPointBJ(sound, 100, x, y, 0);
}

interface 硬直恢复参数 {
  单位: any;
  来源: string;
}

const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};

function 恢复短硬直(this: void, variable?: any): void {
  const params = variable as 硬直恢复参数 | undefined;
  if (params == null) return;
  移除单位暂停(params.单位, params.来源);
}

export function 施加短硬直并播放动作(this: void, unit: any, source: string, seconds: number, animation?: string): void {
  添加单位暂停(unit, source);
  if (animation != null && animation !== "") jass.SetUnitAnimation(unit, animation);
  addDelayedCallback(Math.max(1, Math.round(seconds * 1000)), 恢复短硬直, { 单位: unit, 来源: source } as 硬直恢复参数);
}

export type 直线飞刀命中结果 = "结束" | "反弹" | "继续";

export interface 咲夜飞刀控制器 {
  单位: any;
  主人: any;
  取角度: (this: void) => number;
  设置角度: (this: void, value: number) => void;
  取每Tick位移: (this: void) => number;
  设置每Tick位移: (this: void, value: number) => void;
  取已飞行距离: (this: void) => number;
  设置已飞行距离: (this: void, value: number) => void;
  取最大距离: (this: void) => number;
  设置最大距离: (this: void, value: number) => void;
  结束: (this: void) => void;
}

const 咲夜飞刀登记表: Record<number, 咲夜飞刀控制器 | undefined> = {};

export function 登记咲夜飞刀(this: void, controller: 咲夜飞刀控制器): void {
  if (controller.单位 == null || controller.单位 === 0 || controller.主人 == null || controller.主人 === 0) return;
  咲夜飞刀登记表[jass.GetHandleId(controller.单位) as number] = controller;
}

export function 注销咲夜飞刀(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  delete 咲夜飞刀登记表[jass.GetHandleId(unit) as number];
}

export function 获取咲夜现存飞刀(this: void, owner: any, centerX?: number, centerY?: number, radius?: number): 咲夜飞刀控制器[] {
  const result: 咲夜飞刀控制器[] = [];
  const radiusSq = radius == null ? -1 : radius * radius;
  for (const key in 咲夜飞刀登记表) {
    const controller = 咲夜飞刀登记表[key as unknown as number];
    if (controller == null || controller.主人 !== owner) continue;
    if (!单位存活(controller.单位)) {
      delete 咲夜飞刀登记表[key as unknown as number];
      continue;
    }
    if (radiusSq >= 0 && centerX != null && centerY != null) {
      const dx = GetUnitX(controller.单位) - centerX;
      const dy = GetUnitY(controller.单位) - centerY;
      if (dx * dx + dy * dy > radiusSq) continue;
    }
    result.push(controller);
  }
  return result;
}

export interface 直线飞刀参数 {
  施法者: any;
  单位类型ID: number;
  X: number;
  Y: number;
  角度: number;
  周期毫秒: number;
  每Tick位移: number;
  最大距离: number;
  命中半径: number;
  命中去重?: boolean;
  命中回调: (this: void, target: any, state: 直线飞刀状态) => 直线飞刀命中结果;
  结束回调?: (this: void, state: 直线飞刀状态) => void;
}

export interface 直线飞刀状态 {
  参数: 直线飞刀参数;
  单位: any;
  角度: number;
  已飞行距离: number;
  周期ID: number;
  已结束: boolean;
  已命中: Record<number, boolean | undefined>;
  自定义数据?: any;
}

function 结束直线飞刀(this: void, state: 直线飞刀状态): void {
  if (state.已结束) return;
  state.已结束 = true;
  if (state.周期ID !== 0) 移除咲夜周期任务(state.周期ID);
  state.周期ID = 0;
  注销咲夜飞刀(state.单位);
  安全移除单位壳(state.单位);
  if (state.参数.结束回调 != null) state.参数.结束回调(state);
}

function 推进直线飞刀(this: void, variable?: any): void {
  const state = variable as 直线飞刀状态 | undefined;
  if (state == null || state.已结束) return;
  const shell = state.单位;
  if (!单位存活(shell) || !单位存活(state.参数.施法者)) {
    结束直线飞刀(state);
    return;
  }
  if (单位是否暂停(shell)) return;

  const nextX = 极坐标X(GetUnitX(shell), state.参数.每Tick位移, state.角度);
  const nextY = 极坐标Y(GetUnitY(shell), state.参数.每Tick位移, state.角度);
  SetUnitX(shell, nextX);
  SetUnitY(shell, nextY);
  state.已飞行距离 += state.参数.每Tick位移;

  const targets = 枚举飞刀碰撞敌人(state.参数.施法者, nextX, nextY, state.参数.命中半径);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    const targetId = jass.GetHandleId(target) as number;
    if (state.参数.命中去重 === true && state.已命中[targetId]) continue;
    state.已命中[targetId] = true;
    const result = state.参数.命中回调(target, state);
    if (result === "结束") {
      结束直线飞刀(state);
      return;
    }
    if (result === "反弹") {
      state.角度 = (state.角度 + 180) % 360;
      SetUnitFacing(shell, state.角度);
      break;
    }
  }

  if (state.已飞行距离 >= state.参数.最大距离) 结束直线飞刀(state);
}

export function 创建直线飞刀(this: void, params: 直线飞刀参数): 直线飞刀状态 | null {
  const shell = 创建咲夜单位壳(params.施法者, params.单位类型ID, params.X, params.Y, params.角度);
  if (shell == null || shell === 0) return null;
  const state: 直线飞刀状态 = {
    参数: params,
    单位: shell,
    角度: params.角度,
    已飞行距离: 0,
    周期ID: 0,
    已结束: false,
    已命中: {},
  };
  登记咲夜飞刀({
    单位: shell,
    主人: params.施法者,
    取角度: function 取直线飞刀角度(this: void): number { return state.角度; },
    设置角度: function 设置直线飞刀角度(this: void, value: number): void {
      state.角度 = value;
      SetUnitFacing(state.单位, value);
    },
    取每Tick位移: function 取直线飞刀每Tick位移(this: void): number { return state.参数.每Tick位移; },
    设置每Tick位移: function 设置直线飞刀每Tick位移(this: void, value: number): void { state.参数.每Tick位移 = value; },
    取已飞行距离: function 取直线飞刀已飞距离(this: void): number { return state.已飞行距离; },
    设置已飞行距离: function 设置直线飞刀已飞距离(this: void, value: number): void { state.已飞行距离 = value; },
    取最大距离: function 取直线飞刀最大距离(this: void): number { return state.参数.最大距离; },
    设置最大距离: function 设置直线飞刀最大距离(this: void, value: number): void { state.参数.最大距离 = value; },
    结束: function 结束已登记直线飞刀(this: void): void { 结束直线飞刀(state); },
  });
  state.周期ID = 注册咲夜周期任务(params.周期毫秒, 推进直线飞刀, state);
  return state;
}

export {};
