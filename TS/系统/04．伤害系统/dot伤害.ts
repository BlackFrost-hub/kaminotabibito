/**
 * 【通用 DOT 框架】持续伤害/减益（如反恢复、燃烧、中毒等）统一在此注册与驱动。
 *
 * 设计说明（给后续维护或 AI 参考）：
 * - 每种 DOT 通过 registerDotType(config) 注册，配置里包含：解析装备 Buff、取“最强”参数、算每秒伤害、伤害类型、特效模型等。
 * - 覆盖规则：新效果×新持续 > 当前效果×当前剩余 才覆盖；同一次或自己 DOT 触发的伤害不会重复施加（通过 ignoredTargetByType 忽略）。
 * - 共用一套计时器：tickTimer 每 TICK 秒减 remaining；dotTimer 每 1 秒按条目的 amount 造成伤害并播特效；effectRecycleTimer 统一回收特效，无单次计时器泄漏。
 * - 若某 DOT 需要“附加效果”（如 10 秒内减 50 攻），可在 config 里提供 onApply/onTick/onEnd 回调，在施加/每跳/结束时执行。
 *
 * 与 `01．Buff表.ts` 对应：D001「反恢复」、D002「燃烧」。
 * - 反恢复：装备 `Buff:dmg:AntiHeal200%;time3` → 精神伤害，每秒 regenHP×200%，持续 time 秒。
 * - 燃烧：装备 `Buff:dmg:Burn50;time5` → 火焰伤害，每秒固定 damage 点，持续 time 秒（数值由解析结果决定）。
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
const damageEventModule = require("系统.04．伤害系统.伤害事件") as {
  setNextDamageTypeOverride: (n: number) => void;
  markNextPendingDamageAsDotTickBatch: () => void;
  registerDamageCallback: (cb: (u: any, d: number, t: number, f: boolean, l: boolean) => void, interval?: number) => void;
};
const leakCore = require("系统.00．核心系统.泄露审计") as { LeakWatcher?: any };
const LeakWatcher = leakCore.LeakWatcher ?? leakCore;
const debuffMod = require("系统.05．Buff系统.01．Buff表") as { buffs: Record<string, { buffID?: string }> };
const debuffBuffs = debuffMod.buffs;

/** 与 Buff表 D001「反恢复」、D002「燃烧」buffID 对齐，供 UI/其它系统引用 */
export const DOT_DEBUFF_IDS = {
  antiHeal: debuffBuffs["D001"]?.buffID ?? "D001",
  burn: debuffBuffs["D002"]?.buffID ?? "D002",
} as const;

const TICK = 0.25;
/** 伤害类型位：2048=技能 256=精神，用于 Lua 造成的伤害在事件里显示正确文案 */
const DAMAGE_TYPE_SKILL = 2048;
const DAMAGE_TYPE_MIND = 256;
/**
 * 火焰在「伤害事件展示位」里与 伤害测试 里 attr 表一致：bit4 = 火属性（勿用 common.j 的 32，否则会被显示成「金属性」）。
 * UnitDamageTarget 第 7 参仍传 jass.DAMAGE_TYPE_FIRE（句柄）。
 */
const DAMAGE_TYPE_FIRE_UI_BITS_FOR_DISPLAY = 4;

// ========== 通用 DOT 类型配置与注册 ==========
/** 单种 DOT 的配置：解析 Buff、取装备最强、算伤害、伤害类型、特效、可选附加效果回调 */
export interface DotTypeConfig {
  /** 唯一 id，如 "antiHeal"、"burn"、"poison"，用于状态与忽略表 */
  id: string;
  /** 与 Buff 表 `Debuff:dot` 一致：仅对来源玩家的敌方单位生效，且不对建筑（结构体）生效 */
  debuffDotEnemyNoStructure?: boolean;
  /** 从装备 Buff 字符串解析参数，如 "Buff:dmg:AntiHeal200%;time3" -> { duration, ... }，非本类返回 null */
  parseBuff: (buffStr: string) => { duration: number; [key: string]: any } | null;
  /** 从来源单位 6 格装备中取本类最强一条（用于覆盖比较），返回与 parseBuff 相同结构 */
  getBestFromUnit: (unit: any) => { duration: number; [key: string]: any } | null;
  /** 根据解析结果与目标单位计算「每秒伤害量」 */
  computeAmount: (target: any, parsed: any) => number;
  /** JASS 伤害类型常量，如 DAMAGE_TYPE_MIND、DAMAGE_TYPE_FIRE */
  damageType: any;
  /** 传给伤害事件的类型位覆盖（如 2048+256 精神、2048+火焰）；缺省为 技能+精神 */
  nextDamageTypeOverride?: number;
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
export interface DotState {
  effect: number;
  remaining: number;
  /** 施加时来源单位名字（GetUnitName），供 Buff UI 第二行 */
  sourceName?: string;
  /**
   * 解析得到的持续秒数（如 time3→3）。用于判定「同档装备反复普攻」时不覆盖，
   * 否则 newProduct=效果×满持续 恒大于 当前 effect×剩余，会每次都刷新 remaining/ticksLeft，DOT 跳数远超 time。
   */
  _dotParsedDuration?: number;
  [key: string]: any;
}

/** Buff 池同步：避免顶层 require 循环，运行时加载 05．Buff系统.Buff系统 */
function notifyBuffPool(typeId: string, target: any, state: DotState | null): void {
  (pcall as any)(() => {
    const m = require("系统.05．Buff系统.Buff系统") as { syncDotBuff?: (tid: string, u: any, s: { effect: number; remaining: number } | null) => void };
    if (m != null && typeof m.syncDotBuff === "function") m.syncDotBuff(typeId, target, state);
  });
}

/** 按类型、再按目标存状态。stateByType[typeId][GetHandleId(target)] = { effect, remaining, _dotUnitRef?, ... } */
const stateByType: Record<string, Record<any, DotState>> = {};
/** 每 1 秒执行一次的伤害条：typeId、来源、目标、每跳伤害、剩余跳数、特效用模型与时长 */
interface DotTickEntry { typeId: string; source: any; target: any; amount: number; ticksLeft: number; effectModel: string; effectDuration: number }
const dotTicks: DotTickEntry[] = [];
/** 刚被我们「某类型」伤害打到的单位，下一帧伤害回调里跳过对该类型施加，避免 DOT 触发的伤害再次叠 DOT */
const ignoredTargetByType: Record<string, Record<any, boolean>> = {};
/** 一次 dotTickRun 内可能多次 UnitDamageTarget，ignored 被前一次 onDamage 清空后后续 DOT 仍会进 apply；本表在整轮 tick 内抑制对该目标的装备叠层 */
let dotTickBatchTargetHids: Record<number, boolean> | null = null;
/** 与 dotTickBatchTargetHids 同步快照，供 notify 时比对；秒跳批次数清依赖 伤害事件 延后回调而非 Timer(0) */
let dotBatchSnapForClear: Record<number, boolean> | null = null;
let dotBatchDeferredRemaining = 0;
let tickTimer: any = undefined;
let dotTimer: any = undefined;

/** 特效回收：每 0.2s 检查，到期 DestroyEffect；只用一个周期计时器，不创建单次计时器 */
const EFFECT_RECYCLE_INTERVAL = 0.2;
const effectRecycleList: { eff: any; ticksLeft: number }[] = [];
let effectRecycleTimer: any = undefined;

const itemsData = (require("系统.02．物品系统.01．装备数据") as { items?: Record<string, { Buff?: string }>; default?: Record<string, { Buff?: string }> }).items
  ?? (require("系统.02．物品系统.01．装备数据") as { default?: Record<string, { Buff?: string }> }).default
  ?? {};

/** Lua 下单位作表键时，伤害回调的 target 与选中枚举的 sole 可能不是同一 userdata；统一用 GetHandleId 作键。 */
function unitHid(u: any): number {
  if (u == null || u === 0) return 0;
  if (typeof (jass as any).GetHandleId !== "function") return 0;
  return (jass as any).GetHandleId(u) as number;
}

/** 该目标上本类 DOT 是否仍有未执行的秒级跳数（与 state.remaining 不同步时作兜底） */
function hasPendingDotTick(typeId: string, hid: number): boolean {
  for (let i = 0; i < dotTicks.length; i++) {
    const e = dotTicks[i];
    if (e.typeId === typeId && unitHid(e.target) === hid && e.ticksLeft > 0) return true;
  }
  return false;
}

function getDotSourceDisplayName(u: any): string {
  if (u == null || u === 0) return "未知";
  if (typeof (jass as any).GetUnitName === "function") {
    const n = (jass as any).GetUnitName(u);
    if (n !== undefined && n !== null && `${n}` !== "") return `${n}`;
  }
  return "未知";
}

/** 为 true 时在屏幕刷 [DOT] 诊断（tick 序号、ticksLeft、施加/跳过原因）。排查完改回 false。 */
export let DOT_DAMAGE_DEBUG = false;
let dotDbgTickSeq = 0;

function dotDbg(msg: string): void {
  if (!DOT_DAMAGE_DEBUG) return;
  const pr = (globalThis as any).print;
  if (typeof pr === "function") pr("[DOT] " + msg);
  if (typeof (jass as any).DisplayTextToPlayer !== "function") return;
  for (let pi = 0; pi <= 3; pi++) {
    const p = (jass as any).Player(pi);
    if (p != null) (jass as any).DisplayTextToPlayer(p, 0, 0, "[DOT] " + msg);
  }
}

/**
 * `IsUnitType` 第二参为 unittype。common.j 里 `UNIT_TYPE_STRUCTURE` 已是 unittype，不可再 `ConvertUnitType(UNIT_TYPE_STRUCTURE)`（该 native 只吃整数索引，如 64）。
 */
function getStructureUnitTypeHandle(): any {
  const jc = jass as any;
  const gg = g as any;
  const direct = jc.UNIT_TYPE_STRUCTURE ?? gg.UNIT_TYPE_STRUCTURE;
  if (direct != null) return direct;
  if (typeof (jass as any).ConvertUnitType === "function") return (jass as any).ConvertUnitType(64);
  return null;
}

/** Debuff:dot：仅可对「来源玩家视角下的敌方单位」施加，且不可对建筑 */
/** 禁止用局部变量承接 jass API 再调用，TSTL 会编成 `j:Fn()` 导致 bad self */
function isDebuffDotTargetOk(source: any, target: any): boolean {
  if (source == null || target == null || target === 0) return false;
  const utStruct = getStructureUnitTypeHandle();
  if (typeof (jass as any).IsUnitType === "function" && utStruct != null) {
    if ((jass as any).IsUnitType(target, utStruct) === true) return false;
  }
  if (typeof (jass as any).GetOwningPlayer !== "function") return false;
  const srcP = (jass as any).GetOwningPlayer(source);
  if (srcP == null) return false;
  if (typeof (jass as any).IsUnitEnemy === "function") {
    return (jass as any).IsUnitEnemy(target, srcP) === true;
  }
  if (typeof (jass as any).IsPlayerEnemy === "function") {
    const tp = (jass as any).GetOwningPlayer(target);
    if (tp != null) return (jass as any).IsPlayerEnemy(srcP, tp) === true;
  }
  return false;
}

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

/**
 * 与 JASS `return IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO)` 一致：第二参为全局 `UNIT_TYPE_HERO`（unittype），
 * 同 `装备限制` / `任务管理器` 的 `jass.IsUnitType(unit, jass.UNIT_TYPE_HERO)`，不要对常量再套一层 `ConvertUnitType`。
 * 仅当 jass 与 `jass.globals` 都未注入该常量时，用 `ConvertUnitType(2)` 兜底（common.j 里 HERO=$02）。
 */
function heroUnitTypeForIsUnitType(): any {
  const direct = (jass as any).UNIT_TYPE_HERO ?? (g as any).UNIT_TYPE_HERO;
  if (direct != null) return direct;
  if (typeof (jass as any).ConvertUnitType !== "function") return undefined;
  return (jass as any).ConvertUnitType(2);
}

/** 来源是否为玩家 1–4 的英雄（当前仅这类来源会触发装备 DOT） */
function isSourceHeroPlayer1to4(unit: any): boolean {
  if (!unit || typeof (jass as any).GetOwningPlayer !== "function") return false;
  const hasIsUnitType = typeof (jass as any).IsUnitType === "function";
  const hasHeroLevel = typeof (jass as any).GetHeroLevel === "function";
  if (!hasIsUnitType && !hasHeroLevel) return false;
  const owner = (jass as any).GetOwningPlayer(unit);
  let playerIdx = -1;
  for (let i = 0; i <= 15; i++) {
    if ((jass as any).Player(i) === owner) { playerIdx = i; break; }
  }
  if (playerIdx < 0 || playerIdx > 3) return false;
  const utHero = heroUnitTypeForIsUnitType();
  if (hasIsUnitType && utHero != null && (jass as any).IsUnitType(unit, utHero) === true) return true;
  /** 绑定未导出 `UNIT_TYPE_HERO` 时，`ConvertUnitType(2)+IsUnitType` 可能恒假；与 JASS 一致用 `GetHeroLevel`（非英雄为 0） */
  if (hasHeroLevel && (jass as any).GetHeroLevel(unit) > 0) return true;
  return false;
}

/** stateByType 槽位应为 DotState 表；若被污染为数字等则剔除，避免 cur.remaining 报错 */
function isValidDotStateRow(v: any): boolean {
  return v != null && typeof v === "object" && typeof (v as DotState).remaining === "number" && typeof (v as DotState).effect === "number";
}

// ========== 通用：remaining 递减；无状态时回收 tickTimer ==========
function tick(): void {
  for (const typeId in stateByType) {
    const tab = stateByType[typeId];
    if (tab == null) continue;
    for (const k in tab) {
      const v = tab[k];
      if (v == null) continue;
      if (!isValidDotStateRow(v)) {
        delete tab[k];
        continue;
      }
      v.remaining = v.remaining - TICK;
      if (v.remaining <= 0) {
        const cfg = dotTypes.find(c => c.id === typeId);
        if (cfg != null && typeof cfg.onEnd === "function") {
          const uref = (v as any)._dotUnitRef;
          (cfg as any).onEnd(uref != null ? uref : k, v);
        }
        notifyBuffPool(typeId, k, null);
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
  if (!hasAny && tickTimer != null) {
    LeakWatcher.destroyTimer(tickTimer);
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
  if (effectRecycleTimer == null && typeof (jass as any).TimerStart === "function") {
    effectRecycleTimer = LeakWatcher.createTimer("dot_effectRecycle");
    (jass as any).TimerStart(effectRecycleTimer, EFFECT_RECYCLE_INTERVAL, true, () => {
      for (let i = effectRecycleList.length - 1; i >= 0; i--) {
        const x = effectRecycleList[i];
        x.ticksLeft = x.ticksLeft - 1;
        if (x.ticksLeft <= 0) {
          if (x.eff != null && typeof (jass as any).DestroyEffect === "function") (jass as any).DestroyEffect(x.eff);
          effectRecycleList.splice(i, 1);
        }
      }
      if (effectRecycleList.length === 0 && effectRecycleTimer != null) {
        LeakWatcher.destroyTimer(effectRecycleTimer);
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
  /** 本次伤害由本模块 DOT 造成：须让 onDamage 里「所有」装备 DOT 类型都跳过施加，否则会只忽略当前 type，另一类型仍走 newProduct>effect*remaining 把剩余时间刷新满，导致跳数远超 time（如 3 秒变 5+ 跳）。 */
  const dh = unitHid(target);
  for (let di = 0; di < dotTypes.length; di++) {
    const tid = dotTypes[di].id;
    if ((ignoredTargetByType as any)[tid] == null) (ignoredTargetByType as any)[tid] = {};
    (ignoredTargetByType as any)[tid][dh] = true;
  }
  const typeBits =
    cfg.nextDamageTypeOverride != null ? cfg.nextDamageTypeOverride : DAMAGE_TYPE_SKILL + DAMAGE_TYPE_MIND;
  damageEventModule.setNextDamageTypeOverride(typeBits);
  if (typeof damageEventModule.markNextPendingDamageAsDotTickBatch === "function") {
    damageEventModule.markNextPendingDamageAsDotTickBatch();
  }
  (jass as any).UnitDamageTarget(source, target, amount, false, false, (jass as any).ATTACK_TYPE_NORMAL, cfg.damageType, (jass as any).WEAPON_TYPE_WHOKNOWS);
}

/** 由 伤害事件.runDeferredDamageDisplay 在每段 DOT 伤害展示回调结束后调用，替代 Timer(0) 清空 batch（避免早于 deferred onDamage） */
export function notifyDotTickBatchDamageDisplayed(): void {
  if (dotBatchDeferredRemaining <= 0) return;
  dotBatchDeferredRemaining -= 1;
  if (dotBatchDeferredRemaining <= 0) {
    if (dotTickBatchTargetHids != null && dotTickBatchTargetHids === dotBatchSnapForClear) dotTickBatchTargetHids = null;
    dotBatchSnapForClear = null;
    dotBatchDeferredRemaining = 0;
  }
}

// ========== 每 1 秒：按条造成伤害、挂特效、扣剩余跳数 ==========
function dotTickRun(): void {
  dotDbgTickSeq = dotDbgTickSeq + 1;
  dotDbg(`dotTick#${dotDbgTickSeq} entries=${dotTicks.length}`);
  const batch: Record<number, boolean> = {};
  for (let bi = dotTicks.length - 1; bi >= 0; bi--) {
    const bh = unitHid(dotTicks[bi].target);
    if (bh !== 0) batch[bh] = true;
  }
  const batchSnap = batch;
  dotTickBatchTargetHids = batchSnap;
  const nDeals = dotTicks.length;
  dotBatchSnapForClear = batchSnap;
  dotBatchDeferredRemaining = nDeals;
  for (let i = dotTicks.length - 1; i >= 0; i--) {
    const e = dotTicks[i];
    dotDbg(
      `deal ${e.typeId} hid=${unitHid(e.target)} ticksLeft=${e.ticksLeft} amt=${e.amount}`
    );
    dealDamageForType(e.typeId, e.source, e.target, e.amount);
    addDotEffectOnUnit(e.target, e.effectModel, e.effectDuration);
    const cfg = dotTypes.find(c => c.id === e.typeId);
    const stTab = (stateByType as any)[e.typeId];
    const stateRaw =
      stTab != null ? (stTab as any)[unitHid(e.target)] ?? (stTab as any)[e.target] : null;
    const state = isValidDotStateRow(stateRaw) ? (stateRaw as DotState) : null;
    if (cfg != null && typeof (cfg as any).onTick === "function" && state != null) (cfg as any).onTick(e.target, state);
    e.ticksLeft = e.ticksLeft - 1;
    if (e.ticksLeft <= 0) dotTicks.splice(i, 1);
  }
  /** batch 清空改由 伤害事件 在 deferred 展示回调里 notifyDotTickBatchDamageDisplayed（Timer(0) 会早于 afterRead 注册的 deferred，导致 skipApply 失效） */
  if (nDeals <= 0) {
    dotTickBatchTargetHids = null;
    dotBatchSnapForClear = null;
    dotBatchDeferredRemaining = 0;
  }
  if (dotTicks.length === 0 && dotTimer != null) {
    LeakWatcher.destroyTimer(dotTimer);
    dotTimer = undefined;
  }
}

// ========== 伤害回调：按类型尝试施加/覆盖 ==========
function onDamage(target: any, damage: number, damageType: number): void {
  if (!target || damage <= 0) return;
  /** 禁止 const j=jass 再 j.GetUnitName / j.IsUnitType，TSTL 会编成 j:GetXxx 导致 bad self */
  const ju = jass as any;
  const tgtName =
    typeof ju.GetUnitName === "function" ? `${(jass as any).GetUnitName(target)}` : "?";
  const tgtHidEarly = unitHid(target);
  const source = ju.udg_TempUnit != null && ju.udg_TempUnit[6] != null ? ju.udg_TempUnit[6] : null;
  const srcName =
    source != null && typeof ju.GetUnitName === "function" ? `${(jass as any).GetUnitName(source)}` : "?";
  const srcHid = source != null ? unitHid(source) : 0;
  if (DOT_DAMAGE_DEBUG) {
    dotDbg(`hit dmg=${damage} dt=${damageType} tgt=${tgtName}[${tgtHidEarly}] src=${srcName}[${srcHid}] u6=${source != null}`);
  }
  if (!source) {
    dotDbg("abort: udg_TempUnit[6] nil (伤害事件未写攻击者)");
    return;
  }
  const utHeroDbg = heroUnitTypeForIsUnitType();
  const isHeroUnit =
    typeof (jass as any).IsUnitType === "function" && utHeroDbg != null
      ? (jass as any).IsUnitType(source, utHeroDbg) === true
      : false;
  const heroLv = typeof (jass as any).GetHeroLevel === "function" ? (jass as any).GetHeroLevel(source) : -1;
  const heroGate = isSourceHeroPlayer1to4(source);
  if (DOT_DAMAGE_DEBUG) {
    const uj = (jass as any).UNIT_TYPE_HERO;
    const ug = (g as any).UNIT_TYPE_HERO;
    dotDbg(
      `heroGate=${heroGate} IsUT=${isHeroUnit} heroLv=${heroLv} utJ=${uj != null ? "yes" : "nil"} utG=${ug != null ? "yes" : "nil"} fb=${uj == null && ug == null ? "yes" : "no"} debuffOk=${isDebuffDotTargetOk(source, target)}`
    );
  }
  if (!heroGate) {
    dotDbg("abort: need P1-4 hero attacker");
    return;
  }

  for (let t = 0; t < dotTypes.length; t++) {
    const cfg = dotTypes[t];
    const typeId = cfg.id;
    const tgtHid = unitHid(target);
    if ((ignoredTargetByType as any)[typeId] != null && (ignoredTargetByType as any)[typeId][tgtHid] === true) {
      delete (ignoredTargetByType as any)[typeId][tgtHid];
      dotDbg(`ignored ${typeId} hid=${tgtHid}`);
      continue;
    }
    if (dotTickBatchTargetHids != null && dotTickBatchTargetHids[tgtHid] === true) {
      dotDbg(`skipApplyDotTickBatch ${typeId} hid=${tgtHid}`);
      continue;
    }
    if (cfg.debuffDotEnemyNoStructure === true && !isDebuffDotTargetOk(source, target)) {
      dotDbg(`skipDebuffTarget ${typeId} hid=${tgtHid} (need enemy, not structure)`);
      continue;
    }
    const best = cfg.getBestFromUnit(source);
    if (best == null) {
      dotDbg(`noBest ${typeId} (装备栏无本类 Buff 段)`);
      continue;
    }

    const amount = cfg.computeAmount(target, best);
    if (amount <= 0) {
      dotDbg(`noAmount ${typeId} amt=${amount}`);
      continue;
    }

    if ((stateByType as any)[typeId] == null) (stateByType as any)[typeId] = {};
    const tab = (stateByType as any)[typeId];
    const curRaw = tab[tgtHid];
    let cur: DotState | null = isValidDotStateRow(curRaw) ? (curRaw as DotState) : null;
    if (curRaw != null && cur == null) {
      delete tab[tgtHid];
      dotDbg(`dropCorruptState ${typeId} hid=${tgtHid}`);
    }
    /**
     * 同解析持续 + 每跳强度接近 + 效果尚未结束：不因后续伤害事件再叠一层「满 time」。
     * 反恢复等会有浮点抖动，eps 过严会失败；若仅用 amount×满持续 与 effect×剩余 比乘积，剩余变短时必「假更强」而刷新，总时长会超过 timeN（如一次普攻打出 5 秒跳）。
     */
    const durNear =
      cur != null &&
      cur._dotParsedDuration != null &&
      Math.abs(best.duration - cur._dotParsedDuration) < 0.05;
    const amtNear = cur != null && Math.abs(amount - cur.effect) < 1.0;
    if (cur != null && durNear && amtNear && cur.remaining > 0.01) {
      dotDbg(`skipSameBuffActive ${typeId} hid=${tgtHid} rem=${cur.remaining.toFixed(2)}`);
      continue;
    }
    /** state.remaining 已接近 0 但 dotTicks 仍有跳数时，不刷新 */
    if (cur != null && durNear && amtNear && hasPendingDotTick(typeId, tgtHid)) {
      dotDbg(`skipWhileTicksPending ${typeId} hid=${tgtHid}`);
      continue;
    }
    const currentProduct = cur != null ? cur.effect * cur.remaining : 0;
    const newProduct = amount * best.duration;
    if (newProduct <= currentProduct) {
      dotDbg(`skipWeak ${typeId} hid=${tgtHid} newP=${newProduct} curP=${currentProduct}`);
      continue;
    }

    if (cur != null && typeof cfg.onEnd === "function") (cfg as any).onEnd(target, cur);

    dotDbg(`apply ${typeId} hid=${tgtHid} dur=${best.duration} amt=${amount} ticks=${best.duration}`);

    const state: DotState = {
      effect: amount,
      remaining: best.duration,
      _dotUnitRef: target,
      sourceName: getDotSourceDisplayName(source),
      _dotParsedDuration: best.duration,
    };
    tab[tgtHid] = state;
    notifyBuffPool(typeId, target, state);
    if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);

    for (let i = dotTicks.length - 1; i >= 0; i--) {
      const e = dotTicks[i];
      if (e.typeId === typeId && unitHid(e.target) === tgtHid) dotTicks.splice(i, 1);
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
    if (dotTimer == null && typeof (jass as any).TimerStart === "function") {
      dotTimer = LeakWatcher.createTimer("dot_tick");
      (jass as any).TimerStart(dotTimer, 1, true, dotTickRun);
    }
    if (tickTimer == null && typeof (jass as any).TimerStart === "function") {
      tickTimer = LeakWatcher.createTimer("dot_state");
      (jass as any).TimerStart(tickTimer, TICK, true, tick);
    }
  }
}

/** 装备 `Buff` 可多段，用 `+` 连接，例如：`Buff:dmg:...;timeN+Buff:dmg:...;timeN` */
function splitItemBuffSegments(buff: string): string[] {
  if (!buff || typeof buff !== "string") return [];
  const parts = buff.split("+");
  const out: string[] = [];
  for (let i = 0; i < parts.length; i++) {
    const t = parts[i].trim();
    if (t !== "") out.push(t);
  }
  return out;
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
    const segments = entry?.Buff != null ? splitItemBuffSegments(entry.Buff) : [];
    for (let si = 0; si < segments.length; si++) {
      const parsed = parseAntiHealBuff(segments[si]);
      if (!parsed) continue;
      const product = parsed.effectPct * parsed.duration;
      if (best == null || product > best.product) {
        best = { effectPct: parsed.effectPct, duration: parsed.duration, product };
      }
    }
  }
  return best != null ? { effectPct: best.effectPct, duration: best.duration } : null;
}

// ========== 燃烧：Buff:dmg:Burn50;time5 → 每秒 50 点火焰伤害，持续 5 秒（与 Buff表 D002 文案一致） ==========
function parseBurnBuff(buffStr: string): { damagePerSec: number; duration: number } | null {
  if (!buffStr || typeof buffStr !== "string") return null;
  const s = buffStr.trim();
  if (s.indexOf("Buff:dmg:") !== 0) return null;
  const rest = s.substring(9);
  const burnIdx = rest.indexOf("Burn");
  if (burnIdx < 0) return null;
  let numEnd = burnIdx + 4;
  while (numEnd < rest.length) {
    const c = rest.charAt(numEnd);
    if (c >= "0" && c <= "9") numEnd++; else break;
  }
  const damagePerSec = numEnd > burnIdx + 4 ? parseInt(rest.substring(burnIdx + 4, numEnd), 10) || 0 : 0;
  const timeIdx = rest.indexOf("time");
  if (timeIdx < 0) return null;
  let tEnd = timeIdx + 4;
  while (tEnd < rest.length) {
    const c = rest.charAt(tEnd);
    if (c >= "0" && c <= "9") tEnd++; else break;
  }
  const duration = tEnd > timeIdx + 4 ? parseInt(rest.substring(timeIdx + 4, tEnd), 10) || 0 : 0;
  if (duration <= 0 || damagePerSec <= 0) return null;
  return { damagePerSec, duration };
}

function getBestBurnFromUnit(unit: any): { damagePerSec: number; duration: number } | null {
  let best: { damagePerSec: number; duration: number; product: number } | null = null;
  for (let slot = 0; slot <= 5; slot++) {
    const item = unitItemInSlot(unit, slot);
    if (!item) continue;
    const idStr = fourCCToString(getItemTypeId(item));
    const entry = (itemsData as Record<string, { Buff?: string }>)[idStr];
    const segments = entry?.Buff != null ? splitItemBuffSegments(entry.Buff) : [];
    for (let si = 0; si < segments.length; si++) {
      const parsed = parseBurnBuff(segments[si]);
      if (!parsed) continue;
      const product = parsed.damagePerSec * parsed.duration;
      if (best == null || product > best.product) {
        best = { damagePerSec: parsed.damagePerSec, duration: parsed.duration, product };
      }
    }
  }
  return best != null ? { damagePerSec: best.damagePerSec, duration: best.duration } : null;
}

// ========== 注册：反恢复、燃烧 ==========
registerDotType({
  id: "antiHeal",
  debuffDotEnemyNoStructure: true,
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

registerDotType({
  id: "burn",
  debuffDotEnemyNoStructure: true,
  parseBuff: parseBurnBuff,
  getBestFromUnit: getBestBurnFromUnit,
  computeAmount: (_target: any, parsed: any) => (parsed.damagePerSec as number) ?? 0,
  damageType: (jass as any).DAMAGE_TYPE_FIRE,
  nextDamageTypeOverride: DAMAGE_TYPE_SKILL + DAMAGE_TYPE_FIRE_UI_BITS_FOR_DISPLAY,
  effectModel: "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",
  effectDuration: 0.75,
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
  if (tab == null || unit == null || unit === 0) return null;
  const h = unitHid(unit);
  if (h !== 0 && tab[h] != null) return isValidDotStateRow(tab[h]) ? (tab[h] as DotState) : null;
  const u = tab[unit];
  return u != null && isValidDotStateRow(u) ? (u as DotState) : null;
}

/** 供 UI 等读取：单位当前燃烧 DOT 状态，无则返回 null */
export function getUnitBurn(unit: any): DotState | null {
  const tab = (stateByType as any)["burn"];
  if (tab == null || unit == null || unit === 0) return null;
  const h = unitHid(unit);
  if (h !== 0 && tab[h] != null) return isValidDotStateRow(tab[h]) ? (tab[h] as DotState) : null;
  const u = tab[unit];
  return u != null && isValidDotStateRow(u) ? (u as DotState) : null;
}

/** 造成精神伤害（供外部直接调用，如其他技能）；会标记 target 以免伤害回调再次施加同源 DOT。来源/目标由 dealDamageForType 写入 udg_TempUnit[4]/[3] 供 JASS 读 */
export function dealSpiritDamage(source: any, target: any, amount: number): void {
  dealDamageForType("antiHeal", source, target, amount);
}

/** 造成火焰伤害（外部技能与 burn DOT 同源类型时可调用） */
export function dealBurnDamage(source: any, target: any, amount: number): void {
  dealDamageForType("burn", source, target, amount);
}

init(damageEventModule);
