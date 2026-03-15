/**
 * 【通用 DOT 框架】持续伤害/减益（如反恢复、燃烧、中毒等）统一在此注册与驱动。
 *
 * 设计说明（给后续维护或 AI 参考）：
 * - 每种 DOT 通过 registerDotType(config) 注册，配置里包含：解析装备 Buff、取“最强”参数、算每秒伤害、伤害类型、特效模型等。
 * - 覆盖规则：新效果×新持续 > 当前效果×当前剩余 才覆盖；同一次或自己 DOT 触发的伤害不会重复施加（通过 ignoredTargetByType 忽略）。
 * - 共用一套计时器：tickTimer 每 TICK 秒减 remaining；dotTimer 每 1 秒按条目的 amount 造成伤害并播特效；effectRecycleTimer 统一回收特效，无单次计时器泄漏。
 * - 若某 DOT 需要“附加效果”（如 10 秒内减 50 攻），可在 config 里提供 onApply/onTick/onEnd 回调，在施加/每跳/结束时执行。
 *
 * 当前仅注册一种：反恢复（装备 Buff:dmg:AntiHeal200%;time3，精神伤害，持续 3 秒，每秒 regenHP×200%）。
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
const damageEventModule = require("系统.伤害.伤害事件") as { setNextDamageTypeOverride: (n: number) => void; registerDamageCallback: (cb: (u: any, d: number, t: number, f: boolean, l: boolean) => void, interval?: number) => void };

const TICK = 0.25;
/** 伤害类型位：2048=技能 256=精神，用于 Lua 造成的伤害在事件里显示正确文案 */
const DAMAGE_TYPE_SKILL = 2048;
const DAMAGE_TYPE_MIND = 256;

// ========== 通用 DOT 类型配置与注册 ==========
/** 单种 DOT 的配置：解析 Buff、取装备最强、算伤害、伤害类型、特效、可选附加效果回调 */
export interface DotTypeConfig {
  /** 唯一 id，如 "antiHeal"、"burn"、"poison"，用于状态与忽略表 */
  id: string;
  /** 从装备 Buff 字符串解析参数，如 "Buff:dmg:AntiHeal200%;time3" -> { duration, ... }，非本类返回 null */
  parseBuff: (buffStr: string) => { duration: number; [key: string]: any } | null;
  /** 从来源单位 6 格装备中取本类最强一条（用于覆盖比较），返回与 parseBuff 相同结构 */
  getBestFromUnit: (unit: any) => { duration: number; [key: string]: any } | null;
  /** 根据解析结果与目标单位计算「每秒伤害量」 */
  computeAmount: (target: any, parsed: any) => number;
  /** JASS 伤害类型常量，如 DAMAGE_TYPE_MIND、DAMAGE_TYPE_FIRE */
  damageType: any;
  /** 挂点特效模型路径，如 "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl" */
  effectModel: string;
  /** 特效挂载后保留秒数，到期后统一回收 */
  effectDuration: number;
  /** 可选：施加时调用，可做“10 秒内减少 50 攻击力”等附加效果 */
  onApply?: (target: any, state: any) => void;
  /** 可选：每跳伤害时调用 */
  onTick?: (target: any, state: any) => void;
  /** 可选：持续结束或被覆盖时调用，用于移除附加效果 */
  onEnd?: (target: any, state: any) => void;
}

const dotTypes: DotTypeConfig[] = [];

/** 注册一种 DOT，后续伤害回调会按配置解析装备并施加/覆盖 */
export function registerDotType(config: DotTypeConfig): void {
  dotTypes.push(config);
}

/** 单目标某种 DOT 的状态：每秒伤害量、剩余秒数（供覆盖比较与 getUnitXxx 查询） */
export interface DotState { effect: number; remaining: number; [key: string]: any }

/** 按类型、再按目标存状态。stateByType[typeId][target] = { effect, remaining, ... } */
const stateByType: Record<string, Record<any, DotState>> = {};
/** 每 1 秒执行一次的伤害条：typeId、来源、目标、每跳伤害、剩余跳数、特效用模型与时长 */
interface DotTickEntry { typeId: string; source: any; target: any; amount: number; ticksLeft: number; effectModel: string; effectDuration: number }
const dotTicks: DotTickEntry[] = [];
/** 刚被我们「某类型」伤害打到的单位，下一帧伤害回调里跳过对该类型施加，避免 DOT 触发的伤害再次叠 DOT */
const ignoredTargetByType: Record<string, Record<any, boolean>> = {};
let tickTimer: any = undefined;
let dotTimer: any = undefined;

/** 特效回收：每 0.2s 检查，到期 DestroyEffect；只用一个周期计时器，不创建单次计时器 */
const EFFECT_RECYCLE_INTERVAL = 0.2;
const effectRecycleList: { eff: any; ticksLeft: number }[] = [];
let effectRecycleTimer: any = undefined;

const itemsData = (require("系统.装备.装备数据") as { items?: Record<string, { Buff?: string }>; default?: Record<string, { Buff?: string }> }).items
  ?? (require("系统.装备.装备数据") as { default?: Record<string, { Buff?: string }> }).default
  ?? {};

function fourCCToString(fourcc: number): string {
  const c1 = string.char(fourcc % 256);
  const c2 = string.char(Math.floor(fourcc / 256) % 256);
  const c3 = string.char(Math.floor(fourcc / 65536) % 256);
  const c4 = string.char(Math.floor(fourcc / 16777216) % 256);
  return c4 + c3 + c2 + c1;
}

function unitItemInSlot(unit: any, slot: number): any {
  if (typeof (jass as any).UnitItemInSlot !== "function") return null;
  return (jass as any).UnitItemInSlot(unit, slot);
}

function getItemTypeId(item: any): number {
  if (typeof (jass as any).GetItemTypeId !== "function") return 0;
  return (jass as any).GetItemTypeId(item);
}

/** 来源是否为玩家 1–4 的英雄（当前仅这类来源会触发装备 DOT） */
function isSourceHeroPlayer1to4(unit: any): boolean {
  if (!unit || typeof (jass as any).GetOwningPlayer !== "function" || typeof (jass as any).IsUnitType !== "function") return false;
  const owner = (jass as any).GetOwningPlayer(unit);
  let playerIdx = -1;
  for (let i = 0; i <= 15; i++) {
    if ((jass as any).Player(i) === owner) { playerIdx = i; break; }
  }
  if (playerIdx < 0 || playerIdx > 3) return false;
  const utHero = (jass as any).ConvertUnitType && (jass as any).UNIT_TYPE_HERO != null
    ? (jass as any).ConvertUnitType((jass as any).UNIT_TYPE_HERO) : undefined;
  if (utHero == null) return true;
  return (jass as any).IsUnitType(unit, utHero) === true;
}

// ========== 通用：remaining 递减；无状态时回收 tickTimer ==========
function tick(): void {
  for (const typeId in stateByType) {
    const tab = stateByType[typeId];
    if (tab == null) continue;
    for (const k in tab) {
      const v = tab[k];
      if (v == null) continue;
      v.remaining = v.remaining - TICK;
      if (v.remaining <= 0) {
        const cfg = dotTypes.find(c => c.id === typeId);
        if (cfg != null && typeof cfg.onEnd === "function") (cfg as any).onEnd(k, v);
        delete tab[k];
      }
    }
  }
  let hasAny = false;
  for (const typeId in stateByType) {
    const tab = stateByType[typeId];
    if (tab == null) continue;
    for (const _ in tab) { hasAny = true; break; }
    if (hasAny) break;
  }
  if (!hasAny && tickTimer != null && typeof (jass as any).DestroyTimer === "function") {
    (jass as any).DestroyTimer(tickTimer);
    tickTimer = undefined;
  }
}

/** 在目标身上挂特效，model/duration 由调用方传入；回收走统一列表 */
function addDotEffectOnUnit(unit: any, model: string, duration: number): void {
  if (!unit || typeof (jass as any).AddSpecialEffectTarget !== "function") return;
  const eff = (jass as any).AddSpecialEffectTarget(model, unit, "origin");
  if (eff == null) return;
  if (typeof (jass as any).YDWETimerDestroyEffect === "function") {
    (jass as any).YDWETimerDestroyEffect(duration, eff);
    return;
  }
  const ticks = Math.ceil(duration / EFFECT_RECYCLE_INTERVAL);
  effectRecycleList.push({ eff, ticksLeft: ticks });
  if (effectRecycleTimer == null && typeof (jass as any).CreateTimer === "function" && typeof (jass as any).TimerStart === "function") {
    effectRecycleTimer = (jass as any).CreateTimer();
    (jass as any).TimerStart(effectRecycleTimer, EFFECT_RECYCLE_INTERVAL, true, () => {
      for (let i = effectRecycleList.length - 1; i >= 0; i--) {
        const x = effectRecycleList[i];
        x.ticksLeft = x.ticksLeft - 1;
        if (x.ticksLeft <= 0) {
          if (x.eff != null && typeof (jass as any).DestroyEffect === "function") (jass as any).DestroyEffect(x.eff);
          effectRecycleList.splice(i, 1);
        }
      }
      if (effectRecycleList.length === 0 && effectRecycleTimer != null && typeof (jass as any).DestroyTimer === "function") {
        (jass as any).DestroyTimer(effectRecycleTimer);
        effectRecycleTimer = undefined;
      }
    });
  }
}

/** 造成指定类型的 DOT 伤害，并标记该目标为本类型“自伤”，避免回调里再次施加。来源/目标写入 udg_TempUnit[4]/[3] 供 JASS 读 */
function dealDamageForType(typeId: string, source: any, target: any, amount: number): void {
  if (typeof (jass as any).UnitDamageTarget !== "function") return;
  const cfg = dotTypes.find(c => c.id === typeId);
  if (cfg == null) return;
  const j = jass as any;
  if (j.udg_TempUnit != null) {
    j.udg_TempUnit[3] = target;
    j.udg_TempUnit[4] = source;
  }
  if ((ignoredTargetByType as any)[typeId] == null) (ignoredTargetByType as any)[typeId] = {};
  (ignoredTargetByType as any)[typeId][target] = true;
  damageEventModule.setNextDamageTypeOverride(DAMAGE_TYPE_SKILL + DAMAGE_TYPE_MIND);
  (jass as any).UnitDamageTarget(source, target, amount, false, false, (jass as any).ATTACK_TYPE_NORMAL, cfg.damageType, (jass as any).WEAPON_TYPE_WHOKNOWS);
}

// ========== 每 1 秒：按条造成伤害、挂特效、扣剩余跳数 ==========
function dotTickRun(): void {
  for (let i = dotTicks.length - 1; i >= 0; i--) {
    const e = dotTicks[i];
    dealDamageForType(e.typeId, e.source, e.target, e.amount);
    addDotEffectOnUnit(e.target, e.effectModel, e.effectDuration);
    const cfg = dotTypes.find(c => c.id === e.typeId);
    const state = (stateByType as any)[e.typeId] != null ? (stateByType as any)[e.typeId][e.target] : null;
    if (cfg != null && typeof (cfg as any).onTick === "function" && state != null) (cfg as any).onTick(e.target, state);
    e.ticksLeft = e.ticksLeft - 1;
    if (e.ticksLeft <= 0) dotTicks.splice(i, 1);
  }
  if (dotTicks.length === 0 && dotTimer != null && typeof (jass as any).DestroyTimer === "function") {
    (jass as any).DestroyTimer(dotTimer);
    dotTimer = undefined;
  }
}

// ========== 伤害回调：按类型尝试施加/覆盖 ==========
function onDamage(target: any, damage: number, damageType: number): void {
  if (!target || damage <= 0) return;
  const j = jass as any;
  const source = j.udg_TempUnit != null && j.udg_TempUnit[6] != null ? j.udg_TempUnit[6] : null;
  if (!source) return;
  if (!isSourceHeroPlayer1to4(source)) return;

  for (let t = 0; t < dotTypes.length; t++) {
    const cfg = dotTypes[t];
    const typeId = cfg.id;
    if ((ignoredTargetByType as any)[typeId] != null && (ignoredTargetByType as any)[typeId][target] === true) {
      delete (ignoredTargetByType as any)[typeId][target];
      continue;
    }
    const best = cfg.getBestFromUnit(source);
    if (best == null) continue;

    const amount = cfg.computeAmount(target, best);
    if (amount <= 0) continue;

    if ((stateByType as any)[typeId] == null) (stateByType as any)[typeId] = {};
    const tab = (stateByType as any)[typeId];
    const cur = tab[target];
    const currentProduct = cur != null ? cur.effect * cur.remaining : 0;
    const newProduct = amount * best.duration;
    if (newProduct <= currentProduct) continue;

    if (cur != null && typeof cfg.onEnd === "function") (cfg as any).onEnd(target, cur);

    const state: DotState = { effect: amount, remaining: best.duration };
    tab[target] = state;
    if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);

    for (let i = dotTicks.length - 1; i >= 0; i--) {
      if (dotTicks[i].target === target && dotTicks[i].typeId === typeId) dotTicks.splice(i, 1);
    }
    dotTicks.push({
      typeId,
      source,
      target,
      amount,
      ticksLeft: best.duration,
      effectModel: cfg.effectModel,
      effectDuration: cfg.effectDuration,
    });
    if (dotTimer == null && typeof (jass as any).CreateTimer === "function" && typeof (jass as any).TimerStart === "function") {
      dotTimer = (jass as any).CreateTimer();
      (jass as any).TimerStart(dotTimer, 1, true, dotTickRun);
    }
    if (tickTimer == null && typeof (jass as any).CreateTimer === "function" && typeof (jass as any).TimerStart === "function") {
      tickTimer = (jass as any).CreateTimer();
      (jass as any).TimerStart(tickTimer, TICK, true, tick);
    }
  }
}

// ========== 反恢复：解析 Buff、取装备最强、算伤害（regenHP×effectPct%） ==========
function parseAntiHealBuff(buffStr: string): { effectPct: number; duration: number } | null {
  if (!buffStr || typeof buffStr !== "string") return null;
  const s = buffStr.trim();
  if (s.indexOf("Buff:dmg:") !== 0) return null;
  const rest = s.substring(9);
  const antiIdx = rest.indexOf("AntiHeal");
  if (antiIdx < 0) return null;
  let numEnd = antiIdx + 8;
  while (numEnd < rest.length) {
    const c = rest.charAt(numEnd);
    if (c >= "0" && c <= "9") numEnd++; else break;
  }
  const effectPct = numEnd > antiIdx + 8 ? parseInt(rest.substring(antiIdx + 8, numEnd), 10) || 0 : 0;
  const timeIdx = rest.indexOf("time");
  if (timeIdx < 0) return null;
  let tEnd = timeIdx + 4;
  while (tEnd < rest.length) {
    const c = rest.charAt(tEnd);
    if (c >= "0" && c <= "9") tEnd++; else break;
  }
  const duration = tEnd > timeIdx + 4 ? parseInt(rest.substring(timeIdx + 4, tEnd), 10) || 0 : 0;
  if (duration <= 0) return null;
  return { effectPct, duration };
}

function getTargetRegenHP(targetUnit: any): number {
  if (typeof (jass as any).GetUnitTypeId !== "function" || !targetUnit) return 0;
  const typeId = (jass as any).GetUnitTypeId(targetUnit);
  const idStr = fourCCToString(typeId);
  const slk = (globalThis as any).slk as { unit?: Record<string, Record<string, string>> } | undefined;
  const slkUnit = slk != null && slk.unit ? slk.unit[idStr] : undefined;
  if (slkUnit == null) return 0;
  const regenStr = slkUnit.regenHP ?? slkUnit["regenHP"];
  if (regenStr == null || typeof regenStr !== "string") return 0;
  const n = parseFloat(regenStr);
  return typeof n === "number" && !isNaN(n) ? n : 0;
}

function getBestAntiHealFromUnit(unit: any): { effectPct: number; duration: number } | null {
  let best: { effectPct: number; duration: number; product: number } | null = null;
  for (let slot = 0; slot <= 5; slot++) {
    const item = unitItemInSlot(unit, slot);
    if (!item) continue;
    const idStr = fourCCToString(getItemTypeId(item));
    const entry = (itemsData as Record<string, { Buff?: string }>)[idStr];
    const parsed = entry?.Buff != null ? parseAntiHealBuff(entry.Buff) : null;
    if (!parsed) continue;
    const product = parsed.effectPct * parsed.duration;
    if (best == null || product > best.product) {
      best = { effectPct: parsed.effectPct, duration: parsed.duration, product };
    }
  }
  return best != null ? { effectPct: best.effectPct, duration: best.duration } : null;
}

// ========== 注册反恢复 DOT（当前唯一一种） ==========
registerDotType({
  id: "antiHeal",
  parseBuff: parseAntiHealBuff,
  getBestFromUnit: getBestAntiHealFromUnit,
  computeAmount: (target: any, parsed: any) => {
    const regenHP = getTargetRegenHP(target);
    return regenHP * ((parsed.effectPct as number) / 100);
  },
  damageType: (jass as any).DAMAGE_TYPE_MIND,
  effectModel: "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl",
  effectDuration: 0.8,
});

// ========== 初始化与导出 ==========
let registered = false;

function init(damageEvent: { registerDamageCallback: (cb: (u: any, d: number, t: number, f: boolean, l: boolean) => void, interval?: number) => void }): void {
  if (registered) return;
  registered = true;
  damageEvent.registerDamageCallback((unit: any, damage: number, dmgType: number) => {
    onDamage(unit, damage, dmgType);
  });
}

/** 供治疗等系统读取：单位当前反恢复状态，无则返回 null */
export function getUnitAntiHeal(unit: any): DotState | null {
  const tab = (stateByType as any)["antiHeal"];
  return tab != null ? (tab[unit] ?? null) : null;
}

/** 造成精神伤害（供外部直接调用，如其他技能）；会标记 target 以免伤害回调再次施加同源 DOT。来源/目标由 dealDamageForType 写入 udg_TempUnit[4]/[3] 供 JASS 读 */
export function dealSpiritDamage(source: any, target: any, amount: number): void {
  dealDamageForType("antiHeal", source, target, amount);
}

init(damageEventModule);
