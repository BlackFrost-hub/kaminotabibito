/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetLocalPlayer = jass.GetLocalPlayer as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitX = jass.SetUnitX as (unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (unit: any, y: number) => void;

const DzFrameGetUnitMessage = japi.DzFrameGetUnitMessage as () => number;
const DzSimpleMessageFrameAddMessage = japi.DzSimpleMessageFrameAddMessage as (
  frame: number,
  text: string,
  color: number,
  duration: number,
  permanent: boolean
) => void;

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const { getBuffIdsOnUnit } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffIdsOnUnit: (this: void, unit: any) => string[];
};

const buffTableMod = require("系统.05．Buff系统.01．Buff表") as {
  buffs: Record<string, { 禁止位移?: boolean } | undefined>;
};

const { Buff数据表 } = require("系统.05．Buff系统.02．Buff数据表.00．Buff数据表") as {
  Buff数据表: Record<string, { 禁止位移?: boolean } | undefined>;
};

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};

const 位移封锁提示文本 = "当前无法使用位移技能";
const 位移封锁提示颜色 = 0xFFFFFF00;
const 位移封锁提示持续时间 = 1.2;
const 位移封锁提示间隔Ms = 800;

const 位移封锁提示冷却: Record<number, number | undefined> = {};
let 原生位移封锁Buff缓存: number[] | undefined = undefined;
const 战斗自身位移监听列表: Array<(this: void, unit: any, 起点X: number, 起点Y: number, 终点X: number, 终点Y: number) => void> = [];

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 获取原生位移封锁Buff合集(this: void): number[] {
  if (原生位移封锁Buff缓存 != null) return 原生位移封锁Buff缓存;

  const result: number[] = [];
  for (const rawId in Buff数据表) {
    const meta = Buff数据表[rawId];
    if (meta == null || meta.禁止位移 !== true) continue;
    const buffId = stringToFourCCSafe(rawId);
    if (buffId !== 0) result.push(buffId);
  }
  原生位移封锁Buff缓存 = result;
  return result;
}

function 单位拥有原生位移封锁Buff(this: void, unit: any): boolean {
  const list = 获取原生位移封锁Buff合集();
  for (let i = 0; i < list.length; i++) {
    if (GetUnitAbilityLevel(unit, list[i]) > 0) return true;
  }
  return false;
}

function 单位拥有Buff表位移封锁Buff(this: void, unit: any): boolean {
  const ids = getBuffIdsOnUnit(unit);
  for (let i = 0; i < ids.length; i++) {
    const meta = buffTableMod.buffs[ids[i]];
    if (meta == null) continue;
    if (meta.禁止位移 === true) return true;
  }
  return false;
}

export function 单位是否被位移封锁控制(unit: any): boolean {
  if (!单位有效(unit)) return false;
  return 单位拥有原生位移封锁Buff(unit) || 单位拥有Buff表位移封锁Buff(unit);
}

export function 提示无法使用位移技能(unit: any): void {
  if (!单位有效(unit)) return;
  if (GetLocalPlayer() !== GetOwningPlayer(unit)) return;

  const handleId = GetHandleId(unit) || 0;
  const now = getServerTime();
  const 下次提示时间 = 位移封锁提示冷却[handleId] ?? 0;
  if (now < 下次提示时间) return;
  位移封锁提示冷却[handleId] = now + 位移封锁提示间隔Ms;

  DzSimpleMessageFrameAddMessage(
    DzFrameGetUnitMessage(),
    位移封锁提示文本,
    位移封锁提示颜色,
    位移封锁提示持续时间,
    false
  );
}

export function 尝试阻止自身位移技能(unit: any): boolean {
  if (!单位是否被位移封锁控制(unit)) return false;
  提示无法使用位移技能(unit);
  return true;
}

export function 注册战斗自身位移完成监听(
  listener: (this: void, unit: any, 起点X: number, 起点Y: number, 终点X: number, 终点Y: number) => void,
): void {
  战斗自身位移监听列表.push(listener);
}

function 通知战斗自身位移完成(this: void, unit: any, 起点X: number, 起点Y: number, 终点X: number, 终点Y: number): void {
  for (let i = 0; i < 战斗自身位移监听列表.length; i++) {
    战斗自身位移监听列表[i](unit, 起点X, 起点Y, 终点X, 终点Y);
  }
}

export function 执行战斗自身位移到坐标(unit: any, x: number, y: number): boolean {
  if (!单位有效(unit)) return false;
  if (尝试阻止自身位移技能(unit)) return false;
  const 起点X = jass.GetUnitX(unit) as number;
  const 起点Y = jass.GetUnitY(unit) as number;
  SetUnitX(unit, x);
  SetUnitY(unit, y);
  通知战斗自身位移完成(unit, 起点X, 起点Y, x, y);
  return true;
}

export function 执行战斗自身传送到坐标(unit: any, x: number, y: number): boolean {
  if (!单位有效(unit)) return false;
  if (尝试阻止自身位移技能(unit)) return false;
  const 起点X = jass.GetUnitX(unit) as number;
  const 起点Y = jass.GetUnitY(unit) as number;
  SetUnitPosition(unit, x, y);
  通知战斗自身位移完成(unit, 起点X, 起点Y, x, y);
  return true;
}
