/** @noSelfInFile */

const jass = require("jass.common") as any;

const { withTimer, stopTimer } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器") as {
  withTimer: (this: void, delaySec: number, callback: (this: void) => void, periodic?: boolean, name?: string) => any;
  stopTimer: (this: void, timer: any) => void;
};

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animationName: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, animationIndex: number) => void;
const AddUnitAnimationProperties = jass.AddUnitAnimationProperties as
  | ((this: void, unit: any, animationProperties: string, add: boolean) => void)
  | undefined;

const UNIT_ALIVE_LIFE = 0.405;

export interface 单位动画守护参数 {
  单位: any;
  动画编号?: number;
  动画名?: string;
  附加动画属性?: string;
  间隔秒?: number;
  立即播放?: boolean;
  死亡时清理?: boolean;
  调试名?: string;
}

export interface 单位动画守护句柄 {
  readonly ID: number;
  readonly 单位: any;
}

interface 单位动画守护实例 {
  ID: number;
  单位: any;
  计时器: any;
  参数: 单位动画守护参数;
  已停止: boolean;
}

const 动画守护实例表: { [id: number]: 单位动画守护实例 | undefined } = {};
let 下一个动画守护ID = 1;
let 已注册死亡监听 = false;

function 单位存活(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (GetUnitTypeId(unit) === 0) return false;
  if (IsUnitType(unit, jass.UNIT_TYPE_DEAD)) return false;
  return GetUnitState(unit, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

function 播放守护动画(this: void, 实例: 单位动画守护实例): void {
  const 参数 = 实例.参数;
  if (参数.附加动画属性 != null && 参数.附加动画属性 !== "" && typeof AddUnitAnimationProperties === "function") {
    AddUnitAnimationProperties(实例.单位, 参数.附加动画属性, true);
  }

  if (参数.动画编号 != null) {
    SetUnitAnimationByIndex(实例.单位, 参数.动画编号);
    return;
  }

  if (参数.动画名 != null && 参数.动画名 !== "") {
    SetUnitAnimation(实例.单位, 参数.动画名);
  }
}

function 停止实例(this: void, 实例: 单位动画守护实例): void {
  if (实例.已停止) return;
  实例.已停止 = true;
  stopTimer(实例.计时器);
  delete 动画守护实例表[实例.ID];
}

function on动画守护Tick(this: void, 实例: 单位动画守护实例): void {
  if (实例.已停止) return;
  if (!单位存活(实例.单位)) {
    停止实例(实例);
    return;
  }
  播放守护动画(实例);
}

function on单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const 死亡单位ID = GetHandleId(dyingUnit);
  for (const key in 动画守护实例表) {
    const 实例 = 动画守护实例表[key as any];
    if (实例 == null || 实例.已停止) continue;
    if (GetHandleId(实例.单位) === 死亡单位ID) {
      停止实例(实例);
    }
  }
}

function 确保死亡监听(this: void): void {
  if (已注册死亡监听) return;
  已注册死亡监听 = true;
  registerDeathListener(on单位死亡);
}

export function 创建单位动画守护(参数: 单位动画守护参数): 单位动画守护句柄 | null {
  if (!单位存活(参数.单位)) return null;
  if (参数.动画编号 == null && (参数.动画名 == null || 参数.动画名 === "")) return null;

  if (参数.死亡时清理 !== false) 确保死亡监听();

  const ID = 下一个动画守护ID++;
  const 间隔秒 = 参数.间隔秒 != null && 参数.间隔秒 > 0 ? 参数.间隔秒 : 0.5;
  const 实例: 单位动画守护实例 = {
    ID,
    单位: 参数.单位,
    计时器: null,
    参数,
    已停止: false,
  };

  动画守护实例表[ID] = 实例;
  if (参数.立即播放 !== false) 播放守护动画(实例);
  实例.计时器 = withTimer(间隔秒, () => on动画守护Tick(实例), true, 参数.调试名 ?? "单位动画守护");

  return { ID, 单位: 参数.单位 };
}

export function 停止单位动画守护(句柄: 单位动画守护句柄 | number | null | undefined): void {
  if (句柄 == null) return;
  const ID = typeof 句柄 === "number" ? 句柄 : 句柄.ID;
  const 实例 = 动画守护实例表[ID];
  if (实例 == null) return;
  停止实例(实例);
}

export {};
