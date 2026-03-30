/**
 * 激活传送点系统（按《激活传送点配置》）：
 * - **enabled: false**：该条不启用，不创建单位、不注册任何触发器（与配置中其它字段无关）。
 * - **有 teleportX + teleportY + UnitID（四位 rawcode）**：进入游戏后在坐标处 CreateUnit，再对该单位注册接近检测；
 * - **仅有 UnitID 且为地图已创建的 gg_unit_***：直接取 jass.globals 上的单位引用，注册接近检测；
 * - 首次有**任意单位**进入范围：将传送点单位交给玩家 7、若有 reveal 则 **SetFogStateRect(Player(0), FOG_OF_WAR_VISIBLE, rect, true)**（单份矩形雾，不创建多份修饰器）、**仅玩家 1～4** 显示提示文本；**DestroyTrigger** 排泄事件，不保留检测。
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
import 激活传送点配置, { PointConfig } from "./04．激活传送点配置";
const { Sound3DII_Mp3Play } = require("系统.00．核心系统.音效函数") as {
  Sound3DII_Mp3Play: (path: string, player?: any) => void;
};

const ACTIVATION_SOUND = "Sound\\Interface\\SecretFound.wav";

/** 设为 false 可关闭：开局 1 秒后检测 `jass.globals.gg_unit_htow_0030` 是否存在（验证是否被 KillUnit / 未预置） */
const DEBUG_GG_UNIT_HTOW_0030 = true;
const DEBUG_GG_UNIT_HTOW_KEY = "gg_unit_htow_0030";

/** 接近传送点多少距离算激活（与地图尺度一致） */
const ACTIVATION_RANGE = 300;
/** 有坐标时 CreateUnit 的所属玩家：中立被动（common.j 的 PLAYER_NEUTRAL_PASSIVE，一般为 15） */
function neutralPassivePlayer(): any {
  if (typeof (jass as any).Player !== "function") return null;
  const pid =
    (jass as any).PLAYER_NEUTRAL_PASSIVE != null ? (jass as any).PLAYER_NEUTRAL_PASSIVE : 15;
  return (jass as any).Player(pid);
}

function dbg(_msg: string): void {}

/** 游戏 1 秒后向玩家 0～3 各打一行字，检查 globals 上该 gg_unit 句柄 */
function scheduleDebugGgUnitHtow0030(): void {
  if (!DEBUG_GG_UNIT_HTOW_0030) return;
  if (typeof (jass as any).CreateTimer !== "function" || typeof (jass as any).TimerStart !== "function") return;
  const tm = (jass as any).CreateTimer();
  (jass as any).TimerStart(tm, 1.0, false, () => {
    if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(tm);
    const gg = g as any;
    const u = gg[DEBUG_GG_UNIT_HTOW_KEY];
    let msg: string;
    if (u == null || u === 0) {
      msg =
        "[激活传送点调试] 1s时 " +
        DEBUG_GG_UNIT_HTOW_KEY +
        " = nil/0（未预置或已移除；若地图里有 call KillUnit 则此处必为无效）";
    } else {
      let tail = "";
      if (typeof (jass as any).GetUnitTypeId === "function") {
        tail = " typeId=" + (jass as any).GetUnitTypeId(u);
      }
      if (typeof (jass as any).GetUnitState === "function" && (jass as any).UNIT_STATE_LIFE != null) {
        tail =
          tail +
          " life=" +
          (jass as any).GetUnitState(u, (jass as any).UNIT_STATE_LIFE);
      }
      msg = "[激活传送点调试] 1s时 " + DEBUG_GG_UNIT_HTOW_KEY + " 句柄有效" + tail;
    }
    if (typeof (jass as any).DisplayTimedTextToPlayer === "function" && typeof (jass as any).Player === "function") {
      for (let pi = 0; pi < 4; pi++) {
        (jass as any).DisplayTimedTextToPlayer((jass as any).Player(pi), 0, 0, 14, msg);
      }
    }
    const pr = (globalThis as any).print;
    if (typeof pr === "function") pr(msg);
  });
}

function stringToFourCC(s: string): number {
  if (s == null || s.length < 4) return 0;
  const b1 = s.charCodeAt(0);
  const b2 = s.charCodeAt(1);
  const b3 = s.charCodeAt(2);
  const b4 = s.charCodeAt(3);
  return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
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
 * 解析要监视的「传送点实体」单位：有坐标则新建；否则用 globals 里已存在的 gg_unit。
 */
function resolveWatchUnit(cfg: PointConfig): any {
  const gg = g as any;
  const tx = parseCoord(cfg.teleportX as string | number | undefined);
  const ty = parseCoord(cfg.teleportY as string | number | undefined);
  const hasXY = tx != null && ty != null;

  if (hasXY && cfg.UnitID != null && cfg.UnitID.length >= 4) {
    const four = stringToFourCC(cfg.UnitID.substring(0, 4));
    if (four === 0) return null;
    const passive = neutralPassivePlayer();
    if (passive == null || typeof (jass as any).CreateUnit !== "function") return null;
    const face =
      typeof (jass as any).bj_UNIT_FACING === "number" ? (jass as any).bj_UNIT_FACING : 270;
    const u = (jass as any).CreateUnit(passive, four, tx, ty, face);
    return u != null && u !== 0 ? u : null;
  }

  if (cfg.UnitID != null && cfg.UnitID.indexOf("gg_") === 0) {
    const u = gg[cfg.UnitID];
    return u != null && u !== 0 ? u : null;
  }

  return null;
}

function runActivationEffects(cfg: PointConfig, watchUnit: any): void {
  const gg = g as any;

  if (
    cfg.UnitID != null &&
    typeof (jass as any).SetUnitOwner === "function" &&
    typeof (jass as any).Player === "function" &&
    watchUnit != null &&
    watchUnit !== 0
  ) {
    const p6 = (jass as any).Player(6);
    if (p6) (jass as any).SetUnitOwner(watchUnit, p6, true);
  }

  if (cfg.reveal != null && typeof (jass as any).SetFogStateRect === "function" && typeof (jass as any).Player === "function") {
    const revealRect = gg[cfg.reveal];
    if (revealRect) {
      const mode = (jass as any).FOG_OF_WAR_VISIBLE;
      (jass as any).SetFogStateRect((jass as any).Player(0), mode, revealRect, true);
    }
  }

  if (
    cfg.text != null &&
    typeof (jass as any).DisplayTimedTextToPlayer === "function" &&
    typeof (jass as any).Player === "function"
  ) {
    for (let i = 0; i < 4; i++) {
      (jass as any).DisplayTimedTextToPlayer((jass as any).Player(i), 0, 0, 8, cfg.text);
    }
  }

  if (typeof (jass as any).GetLocalPlayer === "function" && typeof (jass as any).Player === "function") {
    const localPlayer = (jass as any).GetLocalPlayer();
    for (let i = 0; i < 4; i++) {
      if (localPlayer === (jass as any).Player(i)) {
        Sound3DII_Mp3Play(ACTIVATION_SOUND);
        break;
      }
    }
  }
}

function registerOnePoint(cfg: PointConfig, key: string): void {
  if (typeof (jass as any).CreateTrigger !== "function" || typeof (jass as any).TriggerAddAction !== "function") return;
  if (typeof (jass as any).TriggerRegisterUnitInRange !== "function") {
    dbg("缺少 TriggerRegisterUnitInRange");
    return;
  }

  const watchUnit = resolveWatchUnit(cfg);
  if (watchUnit == null || watchUnit === 0) {
    dbg("跳过：无有效监视单位 " + key);
    return;
  }

  const trig = (jass as any).CreateTrigger();
  (jass as any).TriggerRegisterUnitInRange(trig, watchUnit, ACTIVATION_RANGE, null as any);

  let fired = false;
  (jass as any).TriggerAddAction(trig, () => {
    if (fired) return;
    const enterer = typeof (jass as any).GetTriggerUnit === "function" ? (jass as any).GetTriggerUnit() : null;
    if (enterer == null || enterer === 0) return;
    fired = true;
    runActivationEffects(cfg, watchUnit);
    if (typeof (jass as any).DestroyTrigger === "function") {
      (jass as any).DestroyTrigger(trig);
    }
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
  if (typeof (jass as any).CreateTimer === "function" && typeof (jass as any).TimerStart === "function") {
    const t = (jass as any).CreateTimer();
    (jass as any).TimerStart(t, 0.0, false, () => {
      if (typeof (jass as any).DestroyTimer === "function") {
        (jass as any).DestroyTimer(t);
      }
      initActivationPointsInternal();
    });
  } else {
    initActivationPointsInternal();
  }
}
