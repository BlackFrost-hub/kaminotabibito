/**
 * 区域传送：
 * - 开局按 `区域传送配置` 批量创建 Region 并注册进入事件
 * - 单位进入 Region 时，根据配置表把单位瞬移到目标点、移动镜头、显示文字
 * - 只对非中立敌对玩家生效，传送后立刻下达 stop 命令防止继续走回去
 */
const jass = require("jass.common") as Record<string, unknown>;
const { withTimer } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  withTimer: (delaySec: number, callback: () => void) => void;
};
import 区域传送配置 from "./02．区域传送配置";
import type { RegionConfig } from "./02．区域传送配置";
import { panCameraToTimedForPlayer } from "./01．镜头系统";

// 运行时：Region -> 配置行 的映射，用于在回调里从 Region 反查到表格配置
const regionMap = new Map<any, RegionConfig>();

// 简易调试输出：把关键信息打到玩家 0 屏幕上，便于排查区域是否创建/触发
// function dbg(msg: string): void {
//   if (typeof (jass as any).Player !== "function" || typeof (jass as any).DisplayTimedTextToPlayer !== "function") return;
//   const p0 = (jass as any).Player(0);
//   (jass as any).DisplayTimedTextToPlayer(p0, 0, 0, 15, msg);
// }
function dbg(_msg: string): void {}

// 解析并判断区域传送的 condition；目前仅支持：
// - "" 或 "always"：无条件允许
// 其它复杂条件（如 "zhuxian≤2"）预留，暂时一律视为允许，后续再按剧情/存档系统接入
function checkRegionCondition(cond: string, _unit: any): boolean {
  if (!cond || cond === "always") return true;
  // TODO: 在接入剧情/进度系统后，根据约定语法真正解析 condition
  return true;
}

// 执行 rule 字符串，例如：
// "40%KillUnit:提示文本;20%传送:14783,-14913;20%传送:19009,-11590;20%传送:21077,-16342"
// 注意：只有当 teleportX/teleportY 均为 0 且 rule 非空时才会进入这里
function runRegionRule(rule: string, unit: any, owner: any): void {
  if (!rule) return;
  const parts = rule.split(";");
  interface Item { weight: number; action: "KillUnit" | "Teleport"; text?: string; x?: number; y?: number; }
  const items: Item[] = [];
  let totalWeight = 0;

  for (const raw of parts) {
    const s = raw.trim();
    if (!s) continue;
    // 形如 "40%KillUnit:xxx" 或 "20%传送:14783,-14913"
    const percentIdx = s.indexOf("%");
    if (percentIdx <= 0) continue;
    const weightStr = s.substring(0, percentIdx).trim();
    const rest = s.substring(percentIdx + 1).trim();
    const weight = Number(weightStr);
    if (!weight || !isFinite(weight) || weight <= 0) continue;

    const colonIdx = rest.indexOf(":");
    const actionName = (colonIdx >= 0 ? rest.substring(0, colonIdx) : rest).trim();
    const param = colonIdx >= 0 ? rest.substring(colonIdx + 1).trim() : "";

    if (actionName === "KillUnit") {
      items.push({ weight, action: "KillUnit", text: param });
      totalWeight += weight;
    } else if (actionName === "传送" || actionName.toLowerCase() === "teleport") {
      const coords = param.split(",");
      if (coords.length >= 2) {
        const x = Number(coords[0]);
        const y = Number(coords[1]);
        if (isFinite(x) && isFinite(y)) {
          items.push({ weight, action: "Teleport", x, y });
          totalWeight += weight;
        }
      }
    }
  }

  if (items.length === 0 || totalWeight <= 0) return;

  // 用 JASS 的随机整数避免 Lua math.random 细节问题
  let r: number;
  if (typeof (jass as any).GetRandomInt === "function") {
    r = (jass as any).GetRandomInt(1, totalWeight);
  } else {
    const m = (math as any);
    r = typeof m.random === "function" ? m.random(1, totalWeight) : 1;
  }

  let chosen: Item | undefined;
  for (const it of items) {
    if (r <= it.weight) {
      chosen = it;
      break;
    }
    r -= it.weight;
  }
  if (!chosen) chosen = items[items.length - 1];

  // 获取单位名称，用于替换提示里的 {unit}
  let unitName = "单位";
  if (typeof (jass as any).GetUnitName === "function") {
    const n = (jass as any).GetUnitName(unit);
    if (n != null) unitName = tostring(n);
  }
  const formatText = (raw?: string): string | undefined => {
    if (!raw) return undefined;
    return raw.split("{unit}").join(unitName);
  };

  if (chosen.action === "KillUnit") {
    if (typeof (jass as any).KillUnit === "function") {
      (jass as any).KillUnit(unit);
    }
    const msg = formatText(chosen.text);
    if (msg && owner != null && typeof (jass as any).DisplayTimedTextToPlayer === "function") {
      (jass as any).DisplayTimedTextToPlayer(owner, 0, 0, 8, msg);
    }
  } else if (chosen.action === "Teleport") {
    if (typeof (jass as any).SetUnitPosition === "function" && chosen.x != null && chosen.y != null) {
      (jass as any).SetUnitPosition(unit, chosen.x, chosen.y);
    }
    const msg = formatText(undefined);
    if (msg && owner != null && typeof (jass as any).DisplayTimedTextToPlayer === "function") {
      (jass as any).DisplayTimedTextToPlayer(owner, 0, 0, 8, msg);
    }
  }
}

// 实际初始化逻辑：创建所有启用的 Region 并注册同一个进入触发
function initRegionTeleport(): void {
  if (typeof (jass as any).CreateTrigger !== "function") return;
  const trig = (jass as any).CreateTrigger();

  let total = 0;
  let enabledCount = 0;
  // 先扫一遍，只做统计（调试输出已注释）
  for (const k in 区域传送配置) {
    total++;
    const cfg = (区域传送配置 as Record<string, RegionConfig>)[k];
    const enabled = cfg != null && cfg.enabled;
    if (enabled) enabledCount++;
    // dbg("配置[" + k + "] 区域ID=" + (cfg != null ? cfg.id : "?") + " 是否启用=" + (enabled ? "true" : "false"));
  }
  // dbg("【区域传送】共 " + total + " 个配置，启用 " + enabledCount + " 个");

  // 实际创建 Region 并注册进入事件
  for (const k in 区域传送配置) {
    const cfg = (区域传送配置 as Record<string, RegionConfig>)[k];
    if (cfg == null || !cfg.enabled) continue;

    if (typeof (jass as any).CreateRegion !== "function") continue;
    const region = (jass as any).CreateRegion();
    // dbg("已创建区域: " + cfg.id);

    if (typeof (jass as any).Rect !== "function") continue;
    const rect = (jass as any).Rect(cfg.left, cfg.bottom, cfg.right, cfg.top);
    if (typeof (jass as any).RegionAddRect === "function") {
      (jass as any).RegionAddRect(region, rect);
    }
    if (typeof (jass as any).TriggerRegisterEnterRegion === "function") {
      (jass as any).TriggerRegisterEnterRegion(trig, region, null);
    }
    // dbg("已注册区域: " + cfg.id);
    regionMap.set(region, cfg);
  }

  const onEnter = (): void => {
    const unit =
      typeof (jass as any).GetTriggerUnit === "function"
        ? (jass as any).GetTriggerUnit()
        : null;
    const region =
      typeof (jass as any).GetTriggeringRegion === "function"
        ? (jass as any).GetTriggeringRegion()
        : null;
    // dbg("单位进入区域，region=" + (region != null ? "(handle)" : "null"));
    if (unit == null || region == null) return;
    // 前置条件：不处理中立敌对单位
    const owner =
      typeof (jass as any).GetOwningPlayer === "function"
        ? (jass as any).GetOwningPlayer(unit)
        : null;
    if (
      owner != null &&
      typeof (jass as any).Player === "function" &&
      (jass as any).PLAYER_NEUTRAL_AGGRESSIVE != null
    ) {
      const neutralAgg = (jass as any).Player(
        (jass as any).PLAYER_NEUTRAL_AGGRESSIVE
      );
      if (owner === neutralAgg) return;
    }
    const cfg = regionMap.get(region);
    // dbg("从 Map 读取配置: " + (cfg != null ? "成功 区域ID=" + cfg.id : "失败"));
    if (cfg == null) return;

    // 先检查配置里的前置 condition（目前仅 always/空，复杂语法预留）
    if (!checkRegionCondition(cfg.condition, unit)) return;

    // 若 teleportX/Y 都为 0 且存在 rule，则走自定义 rule 流程，否则走普通固定传送
    const useRule = cfg.teleportX === 0 && cfg.teleportY === 0 && typeof cfg.rule === "string" && cfg.rule.length > 0;
    if (useRule) {
      runRegionRule(cfg.rule as string, unit, owner);
      return;
    }
    // dbg("准备传送至: " + cfg.teleportX + "," + cfg.teleportY);
    if (typeof (jass as any).SetUnitPosition === "function") {
      (jass as any).SetUnitPosition(unit, cfg.teleportX, cfg.teleportY);
    }
    if (typeof (jass as any).IssueImmediateOrder === "function") {
      (jass as any).IssueImmediateOrder(unit, "stop");
    }
    // dbg("传送完成");
    const player = owner;
    if (player != null) {
      panCameraToTimedForPlayer(player, cfg.teleportX, cfg.teleportY, cfg.cameraTime);
      if (typeof (jass as any).DisplayTimedTextToPlayer === "function") {
        (jass as any).DisplayTimedTextToPlayer(
          player,
          0,
          0,
          8,
          cfg.text
        );
      }
    }
  };

  if (typeof (jass as any).TriggerAddAction === "function") {
    (jass as any).TriggerAddAction(trig, onEnter);
  }
}

/** 在游戏初始化时调用（建议用 0.00 秒计时器或地图初始化事件） */
export function init区域传送(): void {
  // dbg("【区域传送】初始化开始");
  withTimer(0.00, () => {
    initRegionTeleport();
  });
}
