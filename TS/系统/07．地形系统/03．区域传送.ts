/** @noSelfInFile */
/**
 * 区域传送：
 * - 开局按 `区域传送配置` 批量创建 Region 并注册进入事件
 * - 单位进入 Region 时，根据配置表把单位瞬移到目标点、移动镜头、显示文字
 * - 只对非中立敌对玩家生效，传送后立刻下达 stop 命令防止继续走回去
 */
const jass = require("jass.common") as Record<string, unknown>;
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
import 区域传送配置, { 剧情动态传送配置表 } from "./02．区域传送配置";
import type { RegionConfig, 剧情动态传送配置 } from "./02．区域传送配置";
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.index") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const regionEventCenter = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  registerEnterRegionTrigger: (this: void, trigger: any, region: any, filter?: any) => (this: void) => void;
};

export interface 剧情玩家组传送配置 {
  入口中心X: number;
  入口中心Y: number;
  入口半径: number;
  目标X: number;
  目标Y: number;
  目标面向?: number;
  镜头平移时长?: number;
  条件: (this: void) => boolean;
  读取玩家英雄组: (this: void) => any;
  允许进入单位?: (this: void, unit: any) => boolean;
  完成?: (this: void, 触发单位?: any) => void;
}

interface 剧情玩家组传送状态 {
  配置: 剧情玩家组传送配置;
  区域: any;
  矩形: any;
  触发器: any;
  取消监听: (this: void) => void;
  已触发: boolean;
}

// 运行时：Region -> 配置行 的映射，用于在回调里从 Region 反查到表格配置
const regionMap = new Map<number, RegionConfig>();
let 区域传送已初始化 = false;
const 单位区域传送冷却: Record<number, number> = {};
const 区域传送连触发保护Ms = 500;
const 剧情玩家组传送状态表: Record<number, 剧情玩家组传送状态 | undefined> = {};
let 当前剧情玩家组传送状态: 剧情玩家组传送状态 | undefined;

// 简易调试输出：把关键信息打到玩家 0 屏幕上，便于排查区域是否创建/触发
// function dbg(msg: string): void {
//   if (typeof (jass as any).Player !== "function" || typeof (jass as any).DisplayTimedTextToPlayer !== "function") return;
//   const p0 = (jass as any).Player(0);
//   (jass as any).DisplayTimedTextToPlayer(p0, 0, 0, 15, msg);
// }
function dbg(_msg: string): void {}

function getStoryProgress(): number {
  const raw = YDUserDataGet("string", "剧情进度", "整数", "integer");
  const numeric = raw == null ? 0 : Number(raw);
  return isFinite(numeric) ? numeric : 0;
}

// 解析并判断区域传送的 condition。
// 当前支持：
// - "" 或 "always"：无条件允许
// - zhuxian≥N / zhuxian≤N / zhuxian>N / zhuxian<N / zhuxian=N
// 通过动态读取 `YDUserData("剧情进度","整数")` 与旧 JASS 对齐。
function checkRegionCondition(cond: string, _unit: any): boolean {
  if (!cond || cond === "always") return true;
  const text = cond.trim();

  // 剧情动态配置支持多个进度值的“或”条件，例如 zhuxian=47||zhuxian=48。
  const alternatives = text.split("||");
  if (alternatives.length > 1) {
    for (let i = 0; i < alternatives.length; i++) {
      const alternative = alternatives[i].trim();
      if (alternative !== "" && checkRegionCondition(alternative, _unit)) return true;
    }
    return false;
  }

  const current = getStoryProgress();
  const evalByPrefix = (prefix: string, matcher: (current: number, target: number) => boolean): boolean | null => {
    if (text.indexOf(prefix) !== 0) return null;
    const target = Number(text.substring(prefix.length).trim());
    if (!isFinite(target)) return true;
    return matcher(current, target);
  };

  const gte = evalByPrefix("zhuxian≥", (a, b) => a >= b);
  if (gte != null) return gte;
  const lte = evalByPrefix("zhuxian≤", (a, b) => a <= b);
  if (lte != null) return lte;
  const gteAscii = evalByPrefix("zhuxian>=", (a, b) => a >= b);
  if (gteAscii != null) return gteAscii;
  const lteAscii = evalByPrefix("zhuxian<=", (a, b) => a <= b);
  if (lteAscii != null) return lteAscii;
  const gt = evalByPrefix("zhuxian>", (a, b) => a > b);
  if (gt != null) return gt;
  const lt = evalByPrefix("zhuxian<", (a, b) => a < b);
  if (lt != null) return lt;
  const eq = evalByPrefix("zhuxian=", (a, b) => a === b);
  if (eq != null) return eq;

  if (text.indexOf("zhuxian") === 0) {
    // 无法识别的 zhuxian 条件，保守放行，避免把旧表意外锁死。
    return true;
  }

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
  let r = (jass as any).GetRandomInt(1, totalWeight);

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
  const n = (jass as any).GetUnitName(unit);
  if (n != null) unitName = tostring(n);
  const formatText = (raw?: string): string | undefined => {
    if (!raw) return undefined;
    return raw.split("{unit}").join(unitName);
  };

  if (chosen.action === "KillUnit") {
    (jass as any).KillUnit(unit);
    const msg = formatText(chosen.text);
    if (msg && owner != null) {
      (jass as any).DisplayTimedTextToPlayer(owner, 0, 0, 8, msg);
    }
  } else if (chosen.action === "Teleport") {
    if (chosen.x != null && chosen.y != null) {
      (jass as any).SetUnitPosition(unit, chosen.x, chosen.y);
    }
    const msg = formatText(undefined);
    if (msg && owner != null) {
      (jass as any).DisplayTimedTextToPlayer(owner, 0, 0, 8, msg);
    }
  }
}

function isAliveHero(this: void, unit: any): boolean {
  return unit != null &&
    unit !== 0 &&
    (jass as any).IsUnitType(unit, (jass as any).UNIT_TYPE_HERO) === true &&
    (jass as any).IsUnitType(unit, (jass as any).UNIT_TYPE_DEAD) !== true;
}

function isRegionTeleportCoolingDown(this: void, unit: any): boolean {
  const id = (jass as any).GetHandleId(unit);
  const now = getServerTime();
  const last = 单位区域传送冷却[id] || 0;
  if (last > 0 && now - last < 区域传送连触发保护Ms) return true;
  单位区域传送冷却[id] = now;
  return false;
}

function onRegionEnter(this: void): void {
  const unit = (jass as any).GetTriggerUnit();
  const region = (jass as any).GetTriggeringRegion();
  // dbg("单位进入区域，region=" + (region != null ? "(handle)" : "null"));
  if (unit == null || region == null) return;
  if (!isAliveHero(unit)) return;
  // 前置条件：不处理中立敌对单位
  const owner = (jass as any).GetOwningPlayer(unit);
  if (
    owner != null &&
    (jass as any).PLAYER_NEUTRAL_AGGRESSIVE != null
  ) {
    const neutralAgg = (jass as any).Player(
      (jass as any).PLAYER_NEUTRAL_AGGRESSIVE
    );
    if (owner === neutralAgg) return;
  }
  const cfg = regionMap.get((jass as any).GetHandleId(region));
  // dbg("从 Map 读取配置: " + (cfg != null ? "成功 区域ID=" + cfg.id : "失败"));
  if (cfg == null) return;
  // 先检查配置里的前置 condition（目前仅 always/空，复杂语法预留）
  if (!checkRegionCondition(cfg.condition, unit)) return;
  if (isRegionTeleportCoolingDown(unit)) return;

  // 若 teleportX/Y 都为 0 且存在 rule，则走自定义 rule 流程，否则走普通固定传送
  const useRule = cfg.teleportX === 0 && cfg.teleportY === 0 && typeof cfg.rule === "string" && cfg.rule.length > 0;
  if (useRule) {
    runRegionRule(cfg.rule as string, unit, owner);
    return;
  }
  // dbg("准备传送至: " + cfg.teleportX + "," + cfg.teleportY);
  (jass as any).SetUnitPosition(unit, cfg.teleportX, cfg.teleportY);
  (jass as any).IssueImmediateOrder(unit, "stop");
  // dbg("传送完成");
  const player = owner;
  if (player != null) {
    StarOther_PanCameraToTimedForPlayer(player, cfg.teleportX, cfg.teleportY, cfg.cameraTime);
    (jass as any).DisplayTimedTextToPlayer(
      player,
      0,
      0,
      8,
      cfg.text
    );
  }
}

function isValidRegionRect(this: void, cfg: RegionConfig): boolean {
  return cfg.left < cfg.right && cfg.bottom < cfg.top;
}

// 实际初始化逻辑：创建所有启用的 Region 并注册同一个进入触发
function initRegionTeleport(): void {
  if (区域传送已初始化) return;
  区域传送已初始化 = true;

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
    if (!isValidRegionRect(cfg)) continue;

    const region = (jass as any).CreateRegion();
    // dbg("已创建区域: " + cfg.id);

    const rect = (jass as any).Rect(cfg.left, cfg.bottom, cfg.right, cfg.top);
    (jass as any).RegionAddRect(region, rect);
    (jass as any).RemoveRect(rect);
    regionEventCenter.registerEnterRegionTrigger(trig, region, null);
    // dbg("已注册区域: " + cfg.id);
    regionMap.set((jass as any).GetHandleId(region), cfg);
  }

  (jass as any).TriggerAddAction(trig, onRegionEnter);
}

function onInitRegionTeleportDelayed(this: void): void {
  initRegionTeleport();
}

function 剧情传送句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 剧情传送单位可进入(this: void, unit: any): boolean {
  if (!剧情传送句柄有效(unit)) return false;
  if ((jass as any).IsUnitType(unit, (jass as any).UNIT_TYPE_HERO) !== true) return false;
  if ((jass as any).IsUnitType(unit, (jass as any).UNIT_TYPE_DEAD) === true) return false;
  const owner = (jass as any).GetOwningPlayer(unit);
  const neutralAggressive = (jass as any).Player((jass as any).PLAYER_NEUTRAL_AGGRESSIVE);
  return owner == null || owner !== neutralAggressive;
}

function 空剧情传送清理(this: void): void {}

export interface 剧情配置传送覆盖 {
  条件?: (this: void) => boolean;
  读取玩家英雄组: (this: void) => any;
  允许进入单位?: (this: void, unit: any) => boolean;
  完成?: (this: void, 触发单位?: any) => void;
}

/** 读取地形系统集中维护的剧情动态传送配置。 */
export function 读取剧情传送配置(this: void, 配置ID: string): 剧情动态传送配置 | undefined {
  return 剧情动态传送配置表[配置ID];
}

function on移动剧情玩家组(this: void): void {
  const 状态 = 当前剧情玩家组传送状态;
  if (状态 == null) return;
  const unit = (jass as any).GetEnumUnit();
  if (!剧情传送单位可进入(unit)) return;
  (jass as any).SetUnitPosition(unit, 状态.配置.目标X, 状态.配置.目标Y);
  if (状态.配置.目标面向 != null) {
    (jass as any).SetUnitFacing(unit, 状态.配置.目标面向);
  }
  (jass as any).IssueImmediateOrder(unit, "stop");
  const 镜头平移时长 = 状态.配置.镜头平移时长;
  if (镜头平移时长 != null && 镜头平移时长 > 0) {
    StarOther_PanCameraToTimedForPlayer((jass as any).GetOwningPlayer(unit), 状态.配置.目标X, 状态.配置.目标Y, 镜头平移时长);
  }
}

function 清理剧情玩家组传送状态(this: void, 状态: 剧情玩家组传送状态): void {
  const triggerId = Number((jass as any).GetHandleId(状态.触发器));
  if (状态.取消监听 != null) 状态.取消监听();
  if (剧情传送句柄有效(状态.触发器)) (jass as any).DestroyTrigger(状态.触发器);
  if (剧情传送句柄有效(状态.矩形)) (jass as any).RemoveRect(状态.矩形);
  if (剧情传送句柄有效(状态.区域)) (jass as any).RemoveRegion(状态.区域);
  if (triggerId > 0) 剧情玩家组传送状态表[triggerId] = undefined;
}

function on剧情玩家组传送进入(this: void): void {
  const trigger = (jass as any).GetTriggeringTrigger();
  const triggerId = Number((jass as any).GetHandleId(trigger));
  const 状态 = 剧情玩家组传送状态表[triggerId];
  if (状态 == null || 状态.已触发) return;
  if (!状态.配置.条件()) return;

  const enteringUnit = (jass as any).GetTriggerUnit();
  if (!剧情传送单位可进入(enteringUnit)) return;
  if (状态.配置.允许进入单位 != null && !状态.配置.允许进入单位(enteringUnit)) return;
  const 玩家英雄组 = 状态.配置.读取玩家英雄组();
  if (!剧情传送句柄有效(玩家英雄组)) return;

  状态.已触发 = true;
  清理剧情玩家组传送状态(状态);
  当前剧情玩家组传送状态 = 状态;
  (jass as any).ForGroup(玩家英雄组, on移动剧情玩家组);
  当前剧情玩家组传送状态 = undefined;
  if (状态.配置.完成 != null) 状态.配置.完成(enteringUnit);
}

/**
 * 按剧情动作动态注册一次性玩家英雄组传送。
 * 区域、触发器和监听都由地形系统统一创建与销毁；条件不满足时不会传送。
 */
export function 注册剧情玩家组传送(this: void, 配置: 剧情玩家组传送配置): (this: void) => void {
  if (配置 == null || 配置.入口半径 <= 0 || !配置.条件 || !配置.读取玩家英雄组) return 空剧情传送清理;

  const region = (jass as any).CreateRegion();
  const rect = (jass as any).Rect(
    配置.入口中心X - 配置.入口半径,
    配置.入口中心Y - 配置.入口半径,
    配置.入口中心X + 配置.入口半径,
    配置.入口中心Y + 配置.入口半径,
  );
  const trigger = (jass as any).CreateTrigger();
  if (!剧情传送句柄有效(region) || !剧情传送句柄有效(rect) || !剧情传送句柄有效(trigger)) {
    if (剧情传送句柄有效(rect)) (jass as any).RemoveRect(rect);
    if (剧情传送句柄有效(region)) (jass as any).RemoveRegion(region);
    if (剧情传送句柄有效(trigger)) (jass as any).DestroyTrigger(trigger);
    return 空剧情传送清理;
  }

  (jass as any).RegionAddRect(region, rect);
  (jass as any).TriggerAddAction(trigger, on剧情玩家组传送进入);
  const 状态: 剧情玩家组传送状态 = {
    配置,
    区域: region,
    矩形: rect,
    触发器: trigger,
    取消监听: regionEventCenter.registerEnterRegionTrigger(trigger, region, null),
    已触发: false,
  };
  const triggerId = Number((jass as any).GetHandleId(trigger));
  剧情玩家组传送状态表[triggerId] = 状态;

  return function 清理已注册剧情玩家组传送(this: void): void {
    if (!状态.已触发) 清理剧情玩家组传送状态(状态);
  };
}

/**
 * 按地形系统配置表中的 ID 注册剧情玩家组传送。
 * 剧情侧只提供玩家组和生命周期回调，不再重复维护坐标、范围和进度条件。
 */
export function 注册剧情配置传送(
  配置ID: string,
  覆盖: 剧情配置传送覆盖,
): (this: void) => void {
  const 配置 = 读取剧情传送配置(配置ID);
  if (配置 == null || !配置.enabled || 覆盖 == null || !覆盖.读取玩家英雄组) {
    return 空剧情传送清理;
  }

  return 注册剧情玩家组传送({
    入口中心X: 配置.入口中心X,
    入口中心Y: 配置.入口中心Y,
    入口半径: 配置.入口半径,
    目标X: 配置.目标X,
    目标Y: 配置.目标Y,
    目标面向: 配置.目标面向,
    镜头平移时长: 配置.镜头平移时长,
    条件: 覆盖.条件 ?? (() => checkRegionCondition(配置.condition, undefined)),
    读取玩家英雄组: 覆盖.读取玩家英雄组,
    允许进入单位: 覆盖.允许进入单位,
    完成: 覆盖.完成,
  });
}

/** 在游戏初始化时调用（建议用 0.00 秒计时器或地图初始化事件） */
export function init区域传送(): void {
  addDelayedCallback(0, onInitRegionTeleportDelayed);
}
