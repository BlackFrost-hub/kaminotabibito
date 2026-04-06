/**
 * 【通用 DOT 框架】持续伤害/减益（如反恢复、燃烧、中毒等）统一在此注册与驱动。
 *
 * 设计说明（给后续维护或 AI 参考）：
 * - 每种 DOT 通过 registerDotType(config) 注册，配置里包含：解析装备 Buff、取“最强”参数、算每秒伤害、伤害类型、特效模型等。
 * - **普攻命中**：`01．伤害事件.ts` 在同步阶段快照 `isNormalAttack`，经 `registerDamageCallback` 第 6 参传入；装备普攻类 DOT（`Buff:attack:`）由 `tryApplyHeroAttackGearDots` 等路径处理。视为玩家主动叠 debuff；只要装备仍能提供本类 `best`，则**有条必刷新满额 time**（与乘积、字段漂移无关）。无条则新建。
 * - **非普攻伤害**（技能等）：仍用「同解析 time → 刷新」或「新乘积更大 → 换条」；DOT 秒跳自伤靠 ignoredTargetByType 整轮跳过，batch 仅挡无普攻位的回调。
 * - **剩余秒数**：由 `05．Buff系统.00．Buff系统` 的 Buff 池以 `BUFF_POOL_TICK`（0.1s）递减；本模块每 tick 末 `syncDotRemainingFromBuffPool` 把池内 remaining/effect 写回 `stateByType`。
 * - **dotTimer**：每 1 秒按条目的 amount 造成伤害并播特效；到期以池为准移除条目；effectRecycleTimer 统一回收特效。
 * - 若某 DOT 需要“附加效果”（如 10 秒内减 50 攻），可在 config 里提供 onApply/onTick/onEnd 回调，在施加/每跳/结束时执行。
 *
 * 与 `01．Buff表.ts` 对应：D001「反恢复」、D002「燃烧」、D003「中毒」、D004「巨魔头颅诅咒」等（`effect` 行与表同步）。
 * **图标与每跳特效模型**：只改 `01．Buff表.ts` 的 `icon` / `effect`，勿在本文件写死路径。
 * - 反恢复：装备 `Buff:dmg:AntiHeal200%;time3` → 精神伤害，每秒 regenHP×200%，持续 time 秒。
 * - 燃烧：装备 `Buff:dmg:Burn50;time5` → 火焰伤害，每秒固定 damage 点，持续 time 秒（数值由解析结果决定）。
 */
import type { BuffData } from "../05．Buff系统/01．Buff表";
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
const { fourCCToString } = require("系统.00．核心系统.01．封装函数") as {
  fourCCToString: (four: number) => string;
};
const damageEventModule = require("系统.04．伤害系统.01．伤害事件") as {
  markNextPendingDamageAsDotTickBatch: () => void;
  registerDamageCallback: (
    cb: (unit: any, d: number, t: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean) => void,
    interval?: number
  ) => void;
};
const leakCore = require("系统.00．核心系统.05．泄露审计") as { LeakWatcher?: any };
const LeakWatcher = leakCore.LeakWatcher ?? leakCore;
const debuffMod = require("系统.05．Buff系统.01．Buff表") as { buffs: Record<string, BuffData> };
const debuffBuffs = debuffMod.buffs;

/** DOT 每跳 `AddSpecialEffectTarget` 的模型路径，与同 ID 行的 `effect` 一致 */
function dotEffectModelFromBuffRow(rowId: "D001" | "D002" | "D003" | "D004"): string {
  const row = debuffBuffs[rowId];
  return row != null && typeof row.effect === "string" && row.effect !== "" ? row.effect : "";
}

/** 与 Buff表 buffID 对齐，供 UI/其它系统引用（新增 Debuff 时在表内加行并在此补键） */
export const DOT_DEBUFF_IDS = {
  antiHeal: debuffBuffs["D001"]?.buffID ?? "D001",
  burn: debuffBuffs["D002"]?.buffID ?? "D002",
  poison: debuffBuffs["D003"]?.buffID ?? "D003",
  trollCurse: debuffBuffs["D004"]?.buffID ?? "D004",
} as const;

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
  /**
   * 可选：为 true 时，仅当伤害事件传入的「普攻命中」快照为真时才能触发本类 DOT（与 `01．伤害事件.ts` 第 6 参一致）。
   * 对应装备 Buff 前缀 "Buff:attack:"；普攻装备叠层走 `tryApplyHeroAttackGearDots` 等路径。
   */
  attackOnlyTrigger?: boolean;
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
  /** 解析得到的持续秒数（如 time3→3）。用于判定「同档」：再次命中时整段重置为该 time，不与更强装备混淆。 */
  _dotParsedDuration?: number;
  [key: string]: any;
}

/** Buff 池同步：避免顶层 require 循环，运行时加载 05．Buff系统.00．Buff系统 */
function notifyBuffPool(typeId: string, target: any, state: DotState | null): void {
  (pcall as any)(() => {
    const m = require("系统.05．Buff系统.00．Buff系统") as {
      syncDotBuff?: (
        tid: string,
        u: any,
        s: { effect: number; remaining: number; sourceName?: string; _dotParsedDuration?: number } | null
      ) => void;
    };
    if (m != null && typeof m.syncDotBuff === "function") m.syncDotBuff(typeId, target, state);
  });
}

/** 按类型、再按目标存状态。stateByType[typeId][GetHandleId(target)] = { effect, remaining, _dotUnitRef?, ... } */
const stateByType: Record<string, Record<any, DotState>> = {};
/** 每 1 秒执行一次的伤害条：typeId、来源、目标、每跳伤害、特效用模型与时长（是否仍持续以 Buff 池 remaining 为准） */
interface DotTickEntry { typeId: string; source: any; target: any; amount: number; effectModel: string; effectDuration: number }
const dotTicks: DotTickEntry[] = [];

/** Buff 池 buffID → dot typeId（与 00．Buff系统 DOT_TYPE_TO_BUFF_ID 互逆） */
const BUFF_ID_TO_DOT_TYPE: Record<string, string> = {
  D001: "antiHeal",
  D002: "burn",
  D003: "poison",
  D004: "trollCurse",
};
function dotTypeIdFromBuffId(buffID: string): string | null {
  return BUFF_ID_TO_DOT_TYPE[buffID] ?? null;
}
/** 刚被我们「某类型」伤害打到的单位，下一帧伤害回调里跳过对该类型施加，避免 DOT 触发的伤害再次叠 DOT */
const ignoredTargetByType: Record<string, Record<any, boolean>> = {};
/** 一次 dotTickRun 内可能多次 UnitDamageTarget，ignored 被前一次 onDamage 清空后后续 DOT 仍会进 apply；本表在整轮 tick 内抑制对该目标的装备叠层 */
let dotTickBatchTargetHids: Record<number, boolean> | null = null;
/** 与 dotTickBatchTargetHids 同步快照，供 notify 时比对；秒跳批次数清依赖 伤害事件 延后回调而非 Timer(0) */
let dotBatchSnapForClear: Record<number, boolean> | null = null;
let dotBatchDeferredRemaining = 0;
let dotTimer: any = undefined;

/** 特效回收：每 0.2s 检查，到期 DestroyEffect；只用一个周期计时器，不创建单次计时器 */
const EFFECT_RECYCLE_INTERVAL = 0.2;
const effectRecycleList: { eff: any; ticksLeft: number }[] = [];
let effectRecycleTimer: any = undefined;

const equipDataMod = require("系统.02．物品系统.01．装备数据") as {
  items?: Record<string, { Buff?: string }>;
  default?: Record<string, { Buff?: string }>;
};
const itemsData = equipDataMod.items ?? equipDataMod.default ?? {};

/** Lua 下单位作表键时，伤害回调的 target 与选中枚举的 sole 可能不是同一 userdata；统一用 GetHandleId 作键。 */
function unitHid(u: any): number {
  if (u == null || u === 0) return 0;
  if (typeof (jass as any).GetHandleId !== "function") return 0;
  return (jass as any).GetHandleId(u) as number;
}

function removeDotTicksForTargetHid(typeId: string, tgtHid: number): void {
  for (let i = dotTicks.length - 1; i >= 0; i--) {
    const e = dotTicks[i];
    if (e.typeId === typeId && unitHid(e.target) === tgtHid) dotTicks.splice(i, 1);
  }
}

/** pairs 迭代可能混用 number / string 键，不合并会导致「同目标两行状态」或 onDamage 读不到 cur、乘积误判。 */
function tabRowForHid(tab: Record<any, any>, hid: number): any {
  if (hid === 0) return null;
  const n = tab[hid];
  if (n != null) return n;
  return (tab as any)[`${hid}`];
}

function tabSetHid(tab: Record<any, any>, hid: number, state: DotState): void {
  if (hid === 0) return;
  delete (tab as any)[`${hid}`];
  tab[hid] = state;
}

function tabDeleteHid(tab: Record<any, any>, hid: number): void {
  if (hid === 0) return;
  delete tab[hid];
  delete (tab as any)[`${hid}`];
}

function collectHidsInTab(tab: Record<any, any>): number[] {
  const seen: Record<number, boolean> = {};
  const out: number[] = [];
  for (const k in tab) {
    const kn = typeof k === "number" ? (k as number) : parseInt(`${k}`, 10);
    if (isNaN(kn) || kn === 0) continue;
    if (seen[kn]) continue;
    seen[kn] = true;
    out.push(kn);
  }
  return out;
}

function getDotSourceDisplayName(u: any): string {
  if (u == null || u === 0) return "未知";
  if (typeof (jass as any).GetUnitName === "function") {
    const n = (jass as any).GetUnitName(u);
    if (n !== undefined && n !== null && `${n}` !== "") return `${n}`;
  }
  return "未知";
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

/**
 * Buff 池每 0.1s 递减后调用：把池内 remaining/effect 写回 `stateByType`；池已无行则清理逻辑层与秒跳队列。
 */
export function syncDotRemainingFromBuffPool(): void {
  const buffM = require("系统.05．Buff系统.00．Buff系统") as {
    getBuffRuntimeByHid?: (hid: number, buffID: string) => { remaining: number; effect: number; sourceName?: string; _dotParsedDuration?: number } | null;
    DOT_TYPE_TO_BUFF_ID?: Record<string, string>;
  };
  const map = buffM.DOT_TYPE_TO_BUFF_ID;
  if (map == null || typeof buffM.getBuffRuntimeByHid !== "function") return;

  for (const typeId in stateByType) {
    const tab = (stateByType as any)[typeId];
    if (tab == null) continue;
    const buffID = (map as any)[typeId] as string | undefined;
    if (buffID == null || buffID === "") continue;
    const hids = collectHidsInTab(tab);
    for (let hi = 0; hi < hids.length; hi++) {
      const kn = hids[hi];
      const v = tabRowForHid(tab, kn);
      if (v == null || !isValidDotStateRow(v)) {
        tabDeleteHid(tab, kn);
        continue;
      }
      const rt = buffM.getBuffRuntimeByHid(kn, buffID);
      if (rt == null || rt.remaining <= 0) {
        const cfg = dotTypes.find(c => c.id === typeId);
        if (cfg != null && typeof cfg.onEnd === "function") {
          const uref = (v as any)._dotUnitRef;
          (cfg as any).onEnd(uref != null ? uref : kn, v);
        }
        notifyBuffPool(typeId, kn, null);
        tabDeleteHid(tab, kn);
        removeDotTicksForTargetHid(typeId, kn);
        continue;
      }
      v.remaining = rt.remaining;
      v.effect = rt.effect;
      if (rt.sourceName !== undefined) v.sourceName = rt.sourceName;
      if (rt._dotParsedDuration !== undefined) v._dotParsedDuration = rt._dotParsedDuration;
    }
  }
}

/** Buff 池判定某 DOT 到期时调用（池行已删，勿再 syncDotBuff null） */
export function clearDotByBuffPoolExpire(buffID: string, hid: number): void {
  const typeId = dotTypeIdFromBuffId(buffID);
  if (typeId == null || hid === 0) return;
  const tab = (stateByType as any)[typeId];
  if (tab == null) return;
  const v = tabRowForHid(tab, hid);
  if (v != null && isValidDotStateRow(v)) {
    const cfg = dotTypes.find(c => c.id === typeId);
    if (cfg != null && typeof cfg.onEnd === "function") {
      const uref = (v as any)._dotUnitRef;
      (cfg as any).onEnd(uref != null ? uref : hid, v);
    }
  }
  tabDeleteHid(tab, hid);
  removeDotTicksForTargetHid(typeId, hid);
}

/**
 * 伤害事件延后展示前调用：用 entry.gearDotAttackRefreshHint 判定普攻位（已在事件同步阶段快照，不依赖 jass 全局），每刀只叠一次装备 DOT，避免多段伤害丢 8192/16384。
 * 与 `onDamage` 内普攻分支互斥：回调里 `isAttackHitForDot` 为真时不再叠层。
 */
export function tryApplyHeroAttackGearDots(source: any, target: any, _damage: number): void {
  if (!target || !source) return;
  if (!isSourceHeroPlayer1to4(source)) return;
  const tgtHid = unitHid(target);
  for (let t = 0; t < dotTypes.length; t++) {
    const cfg = dotTypes[t];
    const typeId = cfg.id;
    if (cfg.debuffDotEnemyNoStructure === true && !isDebuffDotTargetOk(source, target)) {
      continue;
    }
    const best = cfg.getBestFromUnit(source);
    if (best == null) continue;
    const amount = cfg.computeAmount(target, best);
    if (amount <= 0) continue;
    if ((stateByType as any)[typeId] == null) (stateByType as any)[typeId] = {};
    const tab = (stateByType as any)[typeId];
    const curRaw = tabRowForHid(tab, tgtHid);
    let cur: DotState | null = isValidDotStateRow(curRaw) ? (curRaw as DotState) : null;
    if (curRaw != null && cur == null) {
      tabDeleteHid(tab, tgtHid);
    }
    applyEquipmentDotOnHeroAttack(typeId, cfg, tab, tgtHid, target, source, amount, best.duration, cur);
  }
}

/** 在目标身上挂特效，model/duration 由调用方传入；回收走统一列表 */
function addDotEffectOnUnit(unit: any, model: string, duration: number): void {
  if (!unit || !model || model === "" || typeof (jass as any).AddSpecialEffectTarget !== "function") return;
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

/**
 * 造成指定类型的 DOT 伤害，并标记该目标为本类型“自伤”，避免回调里再次施加。
 * udg_TempUnit[3]=target / [4]=source：JASS/GUI 触发器约定槽位（与 BuffJASS桥接同协议），
 * 此处是向 JASS 端输出，不是从 JASS 读取输入，不可删除。
 */
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

/** 判定「同一件装备解析出的 time」是否与当前状态一致（仅用于非普攻叠层） */
const DURATION_TIER_EPS = 0.05;

function sameDurationTier(cur: DotState, bestDuration: number): boolean {
  return cur._dotParsedDuration != null && Math.abs(bestDuration - cur._dotParsedDuration) < DURATION_TIER_EPS;
}

function ensureDotTimers(): void {
  /** 禁止 `const j = jass; j.TimerStart(...)`：TSTL 会编成 `j:TimerStart` 导致 bad self（jhandle_t expected, got table） */
  if (dotTimer == null && typeof (jass as any).TimerStart === "function") {
    dotTimer = LeakWatcher.createTimer("dot_tick");
    (jass as any).TimerStart(dotTimer, 1, true, dotTickRun);
  }
}

function pushDotTickForTarget(
  typeId: string,
  source: any,
  target: any,
  tgtHid: number,
  amount: number,
  duration: number,
  cfg: DotTypeConfig
): void {
  for (let i = dotTicks.length - 1; i >= 0; i--) {
    const e = dotTicks[i];
    if (e.typeId === typeId && unitHid(e.target) === tgtHid) dotTicks.splice(i, 1);
  }
  dotTicks.push({
    typeId,
    source,
    target,
    amount,
    effectModel: cfg.effectModel,
    effectDuration: cfg.effectDuration,
  });
}

function fillDotStateRow(cur: DotState, target: any, source: any, amount: number, bestDuration: number): void {
  cur.effect = amount;
  cur.remaining = bestDuration;
  cur._dotParsedDuration = bestDuration;
  cur._dotUnitRef = target;
  cur.sourceName = getDotSourceDisplayName(source);
}

/**
 * 普攻/弩命中：始终以当前背包 `best` 写满持续时间（有条刷新、无条新建），不再走乘积分支。
 */
function applyEquipmentDotOnHeroAttack(
  typeId: string,
  cfg: DotTypeConfig,
  tab: Record<any, any>,
  tgtHid: number,
  target: any,
  source: any,
  amount: number,
  bestDuration: number,
  cur: DotState | null
): void {
  if (cur != null) {
    fillDotStateRow(cur, target, source, amount, bestDuration);
    pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
    notifyBuffPool(typeId, target, cur);
  } else {
    const state: DotState = {
      effect: amount,
      remaining: bestDuration,
      _dotUnitRef: target,
      sourceName: getDotSourceDisplayName(source),
      _dotParsedDuration: bestDuration,
    };
    tabSetHid(tab, tgtHid, state);
    pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
    notifyBuffPool(typeId, target, state);
    if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);
  }
  ensureDotTimers();
}

/** 技能等非普攻伤害：同档刷新或乘积更强时换条 */
function applyEquipmentDotOnNonAttack(
  typeId: string,
  cfg: DotTypeConfig,
  tab: Record<any, any>,
  tgtHid: number,
  target: any,
  source: any,
  amount: number,
  bestDuration: number,
  cur: DotState | null
): void {
  if (cur == null) {
    const state: DotState = {
      effect: amount,
      remaining: bestDuration,
      _dotUnitRef: target,
      sourceName: getDotSourceDisplayName(source),
      _dotParsedDuration: bestDuration,
    };
    tabSetHid(tab, tgtHid, state);
    pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
    notifyBuffPool(typeId, target, state);
    if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);
    ensureDotTimers();
    return;
  }
  if (sameDurationTier(cur, bestDuration)) {
    fillDotStateRow(cur, target, source, amount, bestDuration);
    pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
    notifyBuffPool(typeId, target, cur);
    ensureDotTimers();
    return;
  }
  const currentProduct = cur.effect * cur.remaining;
  const newProduct = amount * bestDuration;
  if (newProduct <= currentProduct) return;
  if (typeof cfg.onEnd === "function") (cfg as any).onEnd(target, cur);
  const state: DotState = {
    effect: amount,
    remaining: bestDuration,
    _dotUnitRef: target,
    sourceName: getDotSourceDisplayName(source),
    _dotParsedDuration: bestDuration,
  };
  tabSetHid(tab, tgtHid, state);
  pushDotTickForTarget(typeId, source, target, tgtHid, amount, bestDuration, cfg);
  notifyBuffPool(typeId, target, state);
  if (typeof cfg.onApply === "function") (cfg as any).onApply(target, state);
  ensureDotTimers();
}

// ========== 每 1 秒：按条造成伤害、挂特效；是否仍持续以 Buff 池 remaining 为准 ==========
function dotTickRun(): void {
  const buffM = require("系统.05．Buff系统.00．Buff系统") as {
    getBuffRuntimeByHid?: (hid: number, buffID: string) => { remaining: number } | null;
    DOT_TYPE_TO_BUFF_ID?: Record<string, string>;
  };
  for (let i = dotTicks.length - 1; i >= 0; i--) {
    const e = dotTicks[i];
    const eh = unitHid(e.target);
    const bid =
      buffM.DOT_TYPE_TO_BUFF_ID != null ? ((buffM.DOT_TYPE_TO_BUFF_ID as any)[e.typeId] as string | undefined) : undefined;
    const rt =
      bid != null && bid !== "" && typeof buffM.getBuffRuntimeByHid === "function"
        ? buffM.getBuffRuntimeByHid(eh, bid)
        : null;
    if (rt == null || rt.remaining <= 0.001) dotTicks.splice(i, 1);
  }
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
    const eh = unitHid(e.target);
    dealDamageForType(e.typeId, e.source, e.target, e.amount);
    addDotEffectOnUnit(e.target, e.effectModel, e.effectDuration);
    const cfg = dotTypes.find(c => c.id === e.typeId);
    const stTab = (stateByType as any)[e.typeId];
    const stateRaw = stTab != null ? tabRowForHid(stTab, eh) ?? (stTab as any)[e.target] : null;
    const state = isValidDotStateRow(stateRaw) ? (stateRaw as DotState) : null;
    if (cfg != null && typeof (cfg as any).onTick === "function" && state != null) (cfg as any).onTick(e.target, state);
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

// ========== 伤害回调：装备 DOT 施加（普攻与其它伤害分流） ==========
/**
 * - `ignoredTargetByType`：DOT 自伤一轮内各类型各清一次并跳过叠层。
 * - `suppressDotApplyForBatch`：秒跳批内且无普攻位时跳过（普攻永远可走 `applyEquipmentDotOnHeroAttack`）。
 */
function onDamage(target: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttackHit?: boolean): void {
  if (!target) return;
  const isAttackHitForDot = isNormalAttackHit === true;
  if (damage <= 0 && !isAttackHitForDot) return;
  if (!source) return;
  if (!isSourceHeroPlayer1to4(source)) return;

  const tgtHid = unitHid(target);
  const suppressDotApplyForBatch =
    fromDotTickBatch === true &&
    dotTickBatchTargetHids != null &&
    dotTickBatchTargetHids[tgtHid] === true &&
    !isAttackHitForDot;

  for (let t = 0; t < dotTypes.length; t++) {
    const cfg = dotTypes[t];
    const typeId = cfg.id;
    if ((ignoredTargetByType as any)[typeId] != null && (ignoredTargetByType as any)[typeId][tgtHid] === true) {
      delete (ignoredTargetByType as any)[typeId][tgtHid];
      continue;
    }
    if (suppressDotApplyForBatch) {
      continue;
    }
    /** 普攻/弩的装备叠层由 `伤害事件` 延后阶段 `tryApplyHeroAttackGearDots` 统一处理，避免多段 mergedType 丢普攻位 */
    if (isAttackHitForDot) {
      continue;
    }
    if (cfg.debuffDotEnemyNoStructure === true && !isDebuffDotTargetOk(source, target)) {
      continue;
    }
    const best = cfg.getBestFromUnit(source);
    if (best == null) {
      continue;
    }
    if ((best as any).attackOnly === true || cfg.attackOnlyTrigger === true) {
      if (!isAttackHitForDot) {
        continue;
      }
    }

    const amount = cfg.computeAmount(target, best);
    if (amount <= 0) {
      continue;
    }

    if ((stateByType as any)[typeId] == null) (stateByType as any)[typeId] = {};
    const tab = (stateByType as any)[typeId];
    const curRaw = tabRowForHid(tab, tgtHid);
    let cur: DotState | null = isValidDotStateRow(curRaw) ? (curRaw as DotState) : null;
    if (curRaw != null && cur == null) {
      tabDeleteHid(tab, tgtHid);
    }

    if (isAttackHitForDot) {
      applyEquipmentDotOnHeroAttack(typeId, cfg, tab, tgtHid, target, source, amount, best.duration, cur);
    } else {
      applyEquipmentDotOnNonAttack(typeId, cfg, tab, tgtHid, target, source, amount, best.duration, cur);
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

/** 从字符串中读取从 startIdx 开始的连续数字 */
function readNumberFromString(s: string, startIdx: number): number {
  let numEnd = startIdx;
  while (numEnd < s.length) {
    const c = s.charAt(numEnd);
    if (c >= "0" && c <= "9") numEnd++;
    else break;
  }
  return numEnd > startIdx ? parseInt(s.substring(startIdx, numEnd), 10) || 0 : 0;
}

/** 通用的标准 DOT Buff 解析（适用于 AntiHeal、Burn、Poison） */
function parseStandardDotBuff<T>(
  buffStr: string,
  keyword: string,
  createResult: (value: number, duration: number, attackOnly: boolean) => T,
  requireValuePositive: boolean = true
): T | null {
  if (!buffStr || typeof buffStr !== "string") return null;
  const s = buffStr.trim();
  let attackOnly = false;
  if (s.indexOf("Buff:attack:") === 0) {
    attackOnly = true;
  } else if (s.indexOf("Buff:dmg:") !== 0) {
    return null;
  }
  const rest = s.substring(attackOnly ? 12 : 9);
  const keywordIdx = rest.indexOf(keyword);
  if (keywordIdx < 0) return null;
  const valueStartIdx = keywordIdx + keyword.length;
  const value = readNumberFromString(rest, valueStartIdx);
  const timeIdx = rest.indexOf("time");
  if (timeIdx < 0) return null;
  const duration = readNumberFromString(rest, timeIdx + 4);
  if (duration <= 0) return null;
  if (requireValuePositive && value <= 0) return null;
  return createResult(value, duration, attackOnly);
}

/** 通用的从单位装备中取最强 DOT 的函数 */
function getBestDotFromUnit<T extends { duration: number; attackOnly: boolean }>(
  unit: any,
  parseBuff: (s: string) => T | null,
  getProduct: (parsed: T) => number
): T | null {
  let best: (T & { product: number }) | null = null;
  for (let slot = 0; slot <= 5; slot++) {
    const item = unitItemInSlot(unit, slot);
    if (!item) continue;
    const idStr = fourCCToString(getItemTypeId(item));
    const entry = (itemsData as Record<string, { Buff?: string }>)[idStr];
    const segments = entry?.Buff != null ? splitItemBuffSegments(entry.Buff) : [];
    for (let si = 0; si < segments.length; si++) {
      const parsed = parseBuff(segments[si]);
      if (!parsed) continue;
      const product = getProduct(parsed);
      if (best == null || product > best.product) {
        best = { ...parsed, product };
      }
    }
  }
  if (best == null) return null;
  const { product, ...result } = best;
  return result as unknown as T;
}

// ========== 反恢复：解析 Buff、取装备最强、算伤害（regenHP×effectPct%） ==========
function parseAntiHealBuff(buffStr: string): { effectPct: number; duration: number; attackOnly: boolean } | null {
  return parseStandardDotBuff(
    buffStr,
    "AntiHeal",
    (effectPct, duration, attackOnly) => ({ effectPct, duration, attackOnly }),
    false
  );
}

/**
 * 目标最大生命（诅咒 DOT 按 %MaxHP 结算）。
 * 1.27 等环境 `jass.UNIT_STATE_MAX_LIFE` 常为 nil，需与 `装备回复` 一致用 `ConvertUnitState(1)` 取最大生命。
 * **禁止**用 `globalThis["GetUnitState"](u,s)`：TSTL 会编成 `gt:GetUnitState`，Lua 里变成 `(gt,u,s)` 参数错位，恒得 0。
 */
function getUnitMaxHp(targetUnit: any): number {
  if (!targetUnit) return 0;
  if (typeof (jass as any).BlzGetUnitMaxHP === "function") {
    const m = (jass as any).BlzGetUnitMaxHP(targetUnit);
    if (typeof m === "number" && isFinite(m) && m > 0) return m;
  }
  if (typeof (jass as any).GetUnitState !== "function") return 0;
  const jc = jass as any;
  const gg = g as any;
  let maxLifeState: any = null;
  if (jc.UNIT_STATE_MAX_LIFE != null) maxLifeState = jc.UNIT_STATE_MAX_LIFE;
  else if (gg.UNIT_STATE_MAX_LIFE != null) maxLifeState = gg.UNIT_STATE_MAX_LIFE;
  else if (typeof (jass as any).ConvertUnitState === "function")
    maxLifeState = (jass as any).ConvertUnitState(1);
  if (maxLifeState == null) return 0;
  const v = (jass as any).GetUnitState(targetUnit, maxLifeState);
  return typeof v === "number" && isFinite(v) && v > 0 ? v : 0;
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

function getBestAntiHealFromUnit(unit: any): { effectPct: number; duration: number; attackOnly: boolean } | null {
  return getBestDotFromUnit(unit, parseAntiHealBuff, (parsed) => parsed.effectPct * parsed.duration);
}

// ========== 燃烧：Buff:dmg:Burn50;time5 → 每秒 50 点火焰伤害，持续 5 秒（与 Buff表 D002 文案一致） ==========
function parseBurnBuff(buffStr: string): { damagePerSec: number; duration: number; attackOnly: boolean } | null {
  return parseStandardDotBuff(
    buffStr,
    "Burn",
    (damagePerSec, duration, attackOnly) => ({ damagePerSec, duration, attackOnly }),
    true
  );
}

function getBestBurnFromUnit(unit: any): { damagePerSec: number; duration: number; attackOnly: boolean } | null {
  return getBestDotFromUnit(unit, parseBurnBuff, (parsed) => parsed.damagePerSec * parsed.duration);
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
  effectModel: dotEffectModelFromBuffRow("D001"),
  effectDuration: 0.8,
});

registerDotType({
  id: "burn",
  debuffDotEnemyNoStructure: true,
  parseBuff: parseBurnBuff,
  getBestFromUnit: getBestBurnFromUnit,
  computeAmount: (_target: any, parsed: any) => (parsed.damagePerSec as number) ?? 0,
  damageType: (jass as any).DAMAGE_TYPE_FIRE,
  effectModel: dotEffectModelFromBuffRow("D002"),
  effectDuration: 0.75,
});

// ========== 中毒：Buff:attack:Poison{N};time{N} → 每秒 N 点金属性（酸性）伤害，仅攻击触发 ==========
function parsePoisonBuff(buffStr: string): { damagePerSec: number; duration: number; attackOnly: boolean } | null {
  return parseStandardDotBuff(
    buffStr,
    "Poison",
    (damagePerSec, duration, attackOnly) => ({ damagePerSec, duration, attackOnly }),
    true
  );
}

function getBestPoisonFromUnit(unit: any): { damagePerSec: number; duration: number; attackOnly: boolean } | null {
  return getBestDotFromUnit(unit, parsePoisonBuff, (parsed) => parsed.damagePerSec * parsed.duration);
}

registerDotType({
  id: "poison",
  debuffDotEnemyNoStructure: true,
  parseBuff: parsePoisonBuff,
  getBestFromUnit: getBestPoisonFromUnit,
  computeAmount: (_target: any, parsed: any) => (parsed.damagePerSec as number) ?? 0,
  damageType: (jass as any).DAMAGE_TYPE_ACID,
  effectModel: dotEffectModelFromBuffRow("D003"),
  effectDuration: 0.8,
});

// ========== 巨魔头颅诅咒：dmg:curse{N}%MaxHP;time{N} / attack:curse… → 每秒目标最大生命 N% 的物理伤害，对齐 Buff 表 D004 ==========
function parseTrollCurseBuff(buffStr: string): { pctMaxHpPerSec: number; duration: number; attackOnly: boolean } | null {
  if (!buffStr || typeof buffStr !== "string") return null;
  let s = buffStr.trim();
  if (s.indexOf("Buff:") === 0) s = s.substring(5);
  let attackOnly = false;
  let rest: string;
  if (s.indexOf("attack:curse") === 0) {
    attackOnly = true;
    rest = s.substring(13);
  } else if (s.indexOf("dmg:curse") === 0) {
    rest = s.substring(9);
  } else {
    return null;
  }
  let numEnd = 0;
  while (numEnd < rest.length) {
    const c = rest.charAt(numEnd);
    if (c >= "0" && c <= "9") numEnd++;
    else break;
  }
  const pctMaxHpPerSec = numEnd > 0 ? parseInt(rest.substring(0, numEnd), 10) || 0 : 0;
  const pctPos = rest.indexOf("%MaxHP");
  if (pctPos < 0 || pctPos !== numEnd) return null;
  const timeIdx = rest.indexOf("time");
  if (timeIdx < 0) return null;
  let tEnd = timeIdx + 4;
  while (tEnd < rest.length) {
    const c = rest.charAt(tEnd);
    if (c >= "0" && c <= "9") tEnd++;
    else break;
  }
  const duration = tEnd > timeIdx + 4 ? parseInt(rest.substring(timeIdx + 4, tEnd), 10) || 0 : 0;
  if (duration <= 0 || pctMaxHpPerSec <= 0) return null;
  return { pctMaxHpPerSec, duration, attackOnly };
}

function getBestTrollCurseFromUnit(unit: any): { pctMaxHpPerSec: number; duration: number; attackOnly: boolean } | null {
  return getBestDotFromUnit(unit, parseTrollCurseBuff, (parsed) => parsed.pctMaxHpPerSec * parsed.duration);
}

registerDotType({
  id: "trollCurse",
  debuffDotEnemyNoStructure: true,
  parseBuff: parseTrollCurseBuff,
  getBestFromUnit: getBestTrollCurseFromUnit,
  computeAmount: (target: any, parsed: any) => {
    const maxHp = getUnitMaxHp(target);
    return maxHp * ((parsed.pctMaxHpPerSec as number) / 100);
  },
  damageType: (jass as any).DAMAGE_TYPE_NORMAL,
  effectModel: dotEffectModelFromBuffRow("D004"),
  effectDuration: 0.8,
});

// ========== 初始化与导出 ==========
let registered = false;

function getDotStateByTypeId(typeId: string, unit: any): DotState | null {
  const tab = (stateByType as any)[typeId];
  if (tab == null || unit == null || unit === 0) return null;
  const h = unitHid(unit);
  const raw = h !== 0 ? tabRowForHid(tab, h) : null;
  if (raw != null) return isValidDotStateRow(raw) ? (raw as DotState) : null;
  const u = tab[unit];
  return u != null && isValidDotStateRow(u) ? (u as DotState) : null;
}

/** 供治疗等系统读取：单位当前反恢复状态，无则返回 null */
export function getUnitAntiHeal(unit: any): DotState | null {
  return getDotStateByTypeId("antiHeal", unit);
}

/** 供 UI 等读取：单位当前燃烧 DOT 状态，无则返回 null */
export function getUnitBurn(unit: any): DotState | null {
  return getDotStateByTypeId("burn", unit);
}

/** 供 UI 等读取：单位当前中毒 DOT 状态，无则返回 null */
export function getUnitPoison(unit: any): DotState | null {
  return getDotStateByTypeId("poison", unit);
}

/** 供 UI 等读取：D004 巨魔头颅诅咒（`registerDotType` id `trollCurse` 注册后才有状态） */
export function getUnitTrollCurse(unit: any): DotState | null {
  return getDotStateByTypeId("trollCurse", unit);
}

/** 造成精神伤害（供外部直接调用，如其他技能）；会标记 target 以免伤害回调再次施加同源 DOT。udg_TempUnit[3]/[4] 由 dealDamageForType 写入（JASS约定输出槽，不可删） */
export function dealSpiritDamage(source: any, target: any, amount: number): void {
  dealDamageForType("antiHeal", source, target, amount);
}

/** 造成火焰伤害（外部技能与 burn DOT 同源类型时可调用） */
export function dealBurnDamage(source: any, target: any, amount: number): void {
  dealDamageForType("burn", source, target, amount);
}

if (!registered) {
  registered = true;
  damageEventModule.registerDamageCallback(onDamage);
}
