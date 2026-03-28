/**
 * 激活传送点系统：
 * - 根据《激活传送点配置》在地图上创建一次性 Region
 * - 单位首次进入时：删除用于检测的 Rect，可选地：
 *   - 把配置里指定的单位交给玩家7（绿色，Player(6)）
 *   - 为玩家1（红色，Player(0)）在指定 Rect 开视野
 *   - 向所有玩家显示提示文字
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
import 激活传送点配置, { PointConfig } from "./激活传送点配置";

interface RuntimeEntry {
  cfg: PointConfig;
  rect: any;
  triggered: boolean;
}

// Region -> 配置 + Rect 的映射
const regionMap = new Map<any, RuntimeEntry>();

// function dbg(msg: string): void {
//   if (typeof (jass as any).Player !== "function" || typeof (jass as any).DisplayTimedTextToPlayer !== "function") return;
//   (jass as any).DisplayTimedTextToPlayer((jass as any).Player(0), 0, 0, 10, "[激活传送点] " + msg);
// }
function dbg(_msg: string): void {}

function initActivationPointsInternal(): void {
  if (
    typeof (jass as any).CreateTrigger !== "function" ||
    typeof (jass as any).CreateRegion !== "function" ||
    typeof (jass as any).Rect !== "function"
  ) {
    // dbg("缺少基础 API，初始化终止");
    return;
  }

  let enabledCount = 0;

  for (const key in 激活传送点配置) {
    const cfg = 激活传送点配置[key];
    if (!cfg || !cfg.enabled) continue;
    enabledCount++;

    const region = (jass as any).CreateRegion();
    const rect = (jass as any).Rect(cfg.left, cfg.bottom, cfg.right, cfg.top);
    if (typeof (jass as any).RegionAddRect === "function") {
      (jass as any).RegionAddRect(region, rect);
    }

    const trig = (jass as any).CreateTrigger();
    if (typeof (jass as any).TriggerRegisterEnterRegion === "function") {
      (jass as any).TriggerRegisterEnterRegion(trig, region, null);
    }

    // 每个激活点独立触发与清理，触发后销毁 trigger + region + rect
    if (typeof (jass as any).TriggerAddAction === "function") {
      let fired = false;
      (jass as any).TriggerAddAction(trig, () => {
        if (fired) return;
        fired = true;

        const unit =
          typeof (jass as any).GetTriggerUnit === "function"
            ? (jass as any).GetTriggerUnit()
            : null;
        if (!unit) return;

        // 删除检测用 Rect，防止重复触发
        if (rect && typeof (jass as any).RemoveRect === "function") {
          (jass as any).RemoveRect(rect);
        }

        // 如果有 UnitID：把对应单位交给玩家7（绿色，Player(6)）
        if (
          cfg.UnitID &&
          typeof (jass as any).SetUnitOwner === "function" &&
          typeof (jass as any).Player === "function"
        ) {
          const u = (g as any)[cfg.UnitID];
          const p6 = (jass as any).Player(6);
          if (u && p6) {
            (jass as any).SetUnitOwner(u, p6, true);
          }
        }

        // 如果有 reveal：给玩家0在指定 Rect 开视野
        if (
          cfg.reveal &&
          typeof (jass as any).CreateFogModifierRect === "function" &&
          typeof (jass as any).FogModifierStart === "function" &&
          typeof (jass as any).Player === "function"
        ) {
          const revealRect = (g as any)[cfg.reveal];
          if (revealRect) {
            const mode = (jass as any).FOG_OF_WAR_VISIBLE;
            const fog = (jass as any).CreateFogModifierRect(
              (jass as any).Player(0),
              mode,
              revealRect,
              true,
              false,
            );
            (jass as any).FogModifierStart(fog);
          }
        }

        // 如果有 text：对所有玩家显示提示
        if (
          cfg.text &&
          typeof (jass as any).DisplayTimedTextToPlayer === "function" &&
          typeof (jass as any).Player === "function"
        ) {
          for (let i = 0; i < 12; i++) {
            (jass as any).DisplayTimedTextToPlayer(
              (jass as any).Player(i),
              0,
              0,
              8,
              cfg.text,
            );
          }
        }

        // 触发结束后销毁 Trigger 与 Region
        if (typeof (jass as any).DestroyTrigger === "function") {
          (jass as any).DestroyTrigger(trig);
        }
        if (typeof (jass as any).RemoveRegion === "function") {
          (jass as any).RemoveRegion(region);
        }
      });
    }
  }

  // dbg("已注册激活传送点: " + tostring(enabledCount));
}

/** 在地图初始化时调用（建议用 0.00 秒计时器） */
export function init激活传送点(): void {
  if (
    typeof (jass as any).CreateTimer === "function" &&
    typeof (jass as any).TimerStart === "function"
  ) {
    const t = (jass as any).CreateTimer();
    (jass as any).TimerStart(t, 0.00, false, (): void => {
      if (typeof (jass as any).DestroyTimer === "function") {
        (jass as any).DestroyTimer(t);
      }
      initActivationPointsInternal();
    });
  } else {
    initActivationPointsInternal();
  }
}

