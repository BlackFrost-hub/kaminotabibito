/** @noSelfInFile */
/**
 * 激活传送点系统（按《激活传送点配置》）：
 * - **enabled: false**：该条不启用，不创建单位、不注册任何触发器（与配置中其它字段无关）。
 * - **有 teleportX + teleportY + UnitID（四位 rawcode）**：进入游戏后在坐标处 CreateUnit，再对该单位注册接近检测；
 * - **仅有 UnitID 且为地图已创建的 gg_unit_***：依次尝试 jass.globals → jass.common → globalThis 上的同名键，注册接近检测；
 * - 首次有**已注册玩家英雄**进入范围：将传送点单位交给玩家 7、若有 reveal 则 **SetFogStateRect(Player(0), FOG_OF_WAR_VISIBLE, rect, true)**（单份矩形雾，不创建多份修饰器）、**仅玩家 1～4** 显示提示文本；**DestroyTrigger** 排泄事件，不保留检测。
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
const { 获取矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  获取矩形区域: (this: void, 名称: string) => any;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
import 激活传送点配置, { PointConfig } from "./04．激活传送点配置";
const { Sound3DII_Mp3PlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_Mp3PlayReuse: (this: void, path: string, player?: any) => void;
};
const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};
const unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (
    this: void,
    trigger: any,
    unit: any,
    range: number,
    filter?: any,
    once?: boolean
  ) => () => void;
};

const ACTIVATION_SOUND = "Sound\\Interface\\SecretFound.wav";
const activationPointTriggerKeyByHid: Record<number, string> = {};
const activationPointTriggerFiredByKey: Record<string, boolean> = {};
const activationPointTriggerWatchUnitByKey: Record<string, any> = {};
const activationPointTriggerHandleByKey: Record<string, any> = {};
const activationPointTriggerUnregisterByKey: Record<string, (() => void) | undefined> = {};

const ACTIVATION_RANGE = 300;
/** 有坐标时 CreateUnit 的所属玩家：中立被动（common.j 的 PLAYER_NEUTRAL_PASSIVE，一般为 15） */
function neutralPassivePlayer(): any {
  const pid =
    (jass as any).PLAYER_NEUTRAL_PASSIVE != null ? (jass as any).PLAYER_NEUTRAL_PASSIVE : 15;
  return (jass as any).Player(pid);
}

/** 预置 gg_unit_*：与 JASS 全局对齐时可能在 globals、common 或 Lua _G（globalThis）之一 */
function resolveGgUnitByKey(unitKey: string): any {
  const gg = g as any;
  const jc = jass as any;
  const G = globalThis as any;
  const a = gg[unitKey];
  if (a != null && a !== 0) return a;
  const b = jc[unitKey];
  if (b != null && b !== 0) return b;
  const c = G[unitKey];
  if (c != null && c !== 0) return c;
  return null;
}

function onInitActivationPointsDelayed(this: void): void {
  initActivationPointsInternal();
}

function parseCoord(v: string | number | undefined): number | null {
  if (v === undefined || v === null) return null;
  if (typeof v === "number" && isFinite(v)) return v;
  if (typeof v === "string") {
    const n = parseFloat(v);
    return isFinite(n) ? n : null;
  }
  return null;
}

/**
 * 解析要监视的「传送点实体」单位：有坐标则新建；否则用 gg_unit_*（多源解析）。
 */
function resolveWatchUnit(cfg: PointConfig): any {
  const tx = parseCoord(cfg.teleportX as string | number | undefined);
  const ty = parseCoord(cfg.teleportY as string | number | undefined);
  const hasXY = tx != null && ty != null;

  if (hasXY && cfg.UnitID != null && cfg.UnitID.length >= 4) {
    const four = stringToFourCC(cfg.UnitID.substring(0, 4));
    if (four === 0) return null;
    const passive = neutralPassivePlayer();
    if (passive == null) return null;
    const face =
      typeof (jass as any).bj_UNIT_FACING === "number" ? (jass as any).bj_UNIT_FACING : 270;
    const u = (jass as any).CreateUnit(passive, four, tx, ty, face);
    return u != null && u !== 0 ? u : null;
  }

  if (cfg.UnitID != null && cfg.UnitID.indexOf("gg_") === 0) {
    return resolveGgUnitByKey(cfg.UnitID);
  }

  return null;
}

function runActivationEffects(cfg: PointConfig, watchUnit: any): void {
  if (
    cfg.UnitID != null &&
    watchUnit != null &&
    watchUnit !== 0
  ) {
    const p6 = (jass as any).Player(6);
    if (p6) (jass as any).SetUnitOwner(watchUnit, p6, true);
  }

  if (cfg.reveal != null) {
    const revealRect = 获取矩形区域(cfg.reveal);
    if (revealRect) {
      const mode = (jass as any).FOG_OF_WAR_VISIBLE;
      (jass as any).SetFogStateRect((jass as any).Player(0), mode, revealRect, true);
    }
  }

  if (
    cfg.text != null &&
    true
  ) {
    for (let i = 0; i < 4; i++) {
      (jass as any).DisplayTimedTextToPlayer((jass as any).Player(i), 0, 0, 8, cfg.text);
    }
  }

  const localPlayer = (jass as any).GetLocalPlayer();
  for (let i = 0; i < 4; i++) {
    if (localPlayer === (jass as any).Player(i)) {
      Sound3DII_Mp3PlayReuse(ACTIVATION_SOUND);
      break;
    }
  }
}

function onActivationPointEnter(): void {
  const trig = (jass as any).GetTriggeringTrigger();
  if (trig == null || trig === 0) return;
  const trigHid = (jass as any).GetHandleId(trig) as number;
  const key = activationPointTriggerKeyByHid[trigHid];
  if (!key) return;
  if (activationPointTriggerFiredByKey[key] === true) return;
  const enterer = (jass as any).GetTriggerUnit();
  if (enterer == null || enterer === 0) return;
  if (!是玩家英雄组单位(enterer)) return;
  const cfg = 激活传送点配置[key];
  const watchUnit = activationPointTriggerWatchUnitByKey[key];
  if (!cfg || watchUnit == null || watchUnit === 0) return;
  activationPointTriggerFiredByKey[key] = true;
  runActivationEffects(cfg, watchUnit);
  const unregister = activationPointTriggerUnregisterByKey[key];
  if (typeof unregister === "function") unregister();
  const handle = activationPointTriggerHandleByKey[key];
  if (handle != null && handle !== 0) {
    delete activationPointTriggerKeyByHid[(jass as any).GetHandleId(handle) as number];
    (jass as any).DestroyTrigger(handle);
  }
  delete activationPointTriggerHandleByKey[key];
  delete activationPointTriggerWatchUnitByKey[key];
  delete activationPointTriggerUnregisterByKey[key];
}

function registerOnePoint(cfg: PointConfig, key: string): void {
  const watchUnit = resolveWatchUnit(cfg);
  if (watchUnit == null || watchUnit === 0) {
    return;
  }

  const trig = (jass as any).CreateTrigger();
  const unregister = unitSpecificEventCenter.registerUnitInRangeTrigger(
    trig,
    watchUnit,
    ACTIVATION_RANGE,
    null,
    false
  );

  activationPointTriggerKeyByHid[(jass as any).GetHandleId(trig) as number] = key;
  activationPointTriggerFiredByKey[key] = false;
  activationPointTriggerWatchUnitByKey[key] = watchUnit;
  activationPointTriggerHandleByKey[key] = trig;
  activationPointTriggerUnregisterByKey[key] = unregister;
  (jass as any).TriggerAddAction(trig, onActivationPointEnter);
}

function initActivationPointsInternal(): void {
  for (const key in 激活传送点配置) {
    const cfg = 激活传送点配置[key];
    // enabled === false：不创建单位、不挂 TriggerRegisterUnitInRange
    if (!cfg || cfg.enabled === false) continue;
    registerOnePoint(cfg, key);
  }
}

/** 在地图初始化时调用（建议用 0.00 秒计时器） */
export function init激活传送点(): void {
  addDelayedCallback(0, onInitActivationPointsDelayed);
}
