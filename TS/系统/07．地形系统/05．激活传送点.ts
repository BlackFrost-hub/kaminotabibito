/**
 * 激活传送点系统（按《激活传送点配置》）：
 * - **enabled: false**：该条不启用，不创建单位、不注册任何触发器（与配置中其它字段无关）。
 * - **有 teleportX + teleportY + UnitID（四位 rawcode）**：进入游戏后在坐标处 CreateUnit，再对该单位注册接近检测；
 * - **仅有 UnitID 且为地图已创建的 gg_unit_***：依次尝试 jass.globals → jass.common → globalThis 上的同名键，注册接近检测；
 * - 首次有**任意单位**进入范围：将传送点单位交给玩家 7、若有 reveal 则 **SetFogStateRect(Player(0), FOG_OF_WAR_VISIBLE, rect, true)**（单份矩形雾，不创建多份修饰器）、**仅玩家 1～4** 显示提示文本；**DestroyTrigger** 排泄事件，不保留检测。
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
const { stringToFourCC, withTimer } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
  withTimer: (delaySec: number, callback: () => void) => void;
};
import 激活传送点配置, { PointConfig } from "./04．激活传送点配置";
const { Sound3DII_Mp3Play } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
  Sound3DII_Mp3Play: (path: string, player?: any) => void;
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

/**
 * 设为 true：开局 0s / 1s 各打一行，对比 g / jass.common / globalThis 上 `gg_unit_htow_0030`。
 * 若三处长期全 nil/0：先在编辑器保存地图（生成 war3map 里 gg_unit_*），再打包/runmap；否则 Lua 读不到预置单位。
 */
const DEBUG_GG_UNIT_HTOW_0030 = false;
const DEBUG_GG_UNIT_HTOW_KEY = "gg_unit_htow_0030";

/** 接近传送点多少距离算激活（与地图尺度一致） */
const ACTIVATION_RANGE = 300;
/** 有坐标时 CreateUnit 的所属玩家：中立被动（common.j 的 PLAYER_NEUTRAL_PASSIVE，一般为 15） */
function neutralPassivePlayer(): any {
  const pid =
    (jass as any).PLAYER_NEUTRAL_PASSIVE != null ? (jass as any).PLAYER_NEUTRAL_PASSIVE : 15;
  return (jass as any).Player(pid);
}

function dbg(_msg: string): void {}

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

function formatGgUnitProbe(u: any): string {
  if (u == null || u === 0) return "nil/0";
  let tail = "";
  tail = " typeId=" + (jass as any).GetUnitTypeId(u);
  if ((jass as any).UNIT_STATE_LIFE != null) {
    tail = tail + " life=" + (jass as any).GetUnitState(u, (jass as any).UNIT_STATE_LIFE);
  }
  return "ok" + tail;
}

/** 开局 0s、1s 各一行：对比三处来源（用于排查间歇 nil） */
function scheduleDebugGgUnitHtow0030(): void {
  if (!DEBUG_GG_UNIT_HTOW_0030) return;
  const key = DEBUG_GG_UNIT_HTOW_KEY;
  const runSnapshot = (label: string): void => {
    const gg = g as any;
    const jc = jass as any;
    const G = globalThis as any;
    const vg = gg[key];
    const vj = jc[key];
    const vG = G[key];
    const msg =
      "[激活传送点调试] " +
      label +
      " " +
      key +
      " | g=" +
      formatGgUnitProbe(vg) +
      " | jass.common=" +
      formatGgUnitProbe(vj) +
      " | globalThis=" +
      formatGgUnitProbe(vG);
    for (let pi = 0; pi < 4; pi++) {
      (jass as any).DisplayTimedTextToPlayer((jass as any).Player(pi), 0, 0, 14, msg);
    }
    const pr = (globalThis as any).print;
    pr(msg);
  };
  withTimer(0.0, () => {
    runSnapshot("0s");
  });
  withTimer(1.0, () => {
    runSnapshot("1s");
  });
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
  const gg = g as any;

  if (
    cfg.UnitID != null &&
    watchUnit != null &&
    watchUnit !== 0
  ) {
    const p6 = (jass as any).Player(6);
    if (p6) (jass as any).SetUnitOwner(watchUnit, p6, true);
  }

  if (cfg.reveal != null) {
    const revealRect = gg[cfg.reveal];
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
      Sound3DII_Mp3Play(ACTIVATION_SOUND);
      break;
    }
  }
}

function registerOnePoint(cfg: PointConfig, key: string): void {
  const watchUnit = resolveWatchUnit(cfg);
  if (watchUnit == null || watchUnit === 0) {
    dbg("跳过：无有效监视单位 " + key);
    return;
  }

  const trig = (jass as any).CreateTrigger();
  const unregister = unitSpecificEventCenter.registerUnitInRangeTrigger(
    trig,
    watchUnit,
    ACTIVATION_RANGE,
    null,
    true
  );

  let fired = false;
  (jass as any).TriggerAddAction(trig, () => {
    if (fired) return;
    const enterer = (jass as any).GetTriggerUnit();
    if (enterer == null || enterer === 0) return;
    fired = true;
    runActivationEffects(cfg, watchUnit);
    unregister();
    (jass as any).DestroyTrigger(trig);
  });
}

function initActivationPointsInternal(): void {
  let count = 0;
  for (const key in 激活传送点配置) {
    const cfg = 激活传送点配置[key];
    // enabled === false：不创建单位、不挂 TriggerRegisterUnitInRange
    if (!cfg || cfg.enabled === false) continue;
    registerOnePoint(cfg, key);
    count++;
  }
  dbg("已注册激活传送点(接近检测): " + count);
}

/** 在地图初始化时调用（建议用 0.00 秒计时器） */
export function init激活传送点(): void {
  scheduleDebugGgUnitHtow0030();
  withTimer(0.0, () => {
    initActivationPointsInternal();
  });
}
