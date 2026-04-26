/**
 * 【通用 DOT 框架】持续伤害/减益（如反恢复、燃烧、中毒等）统一在此注册与驱动。
 *
 * 设计说明（给后续维护或 AI 参考）：
 * - 每种 DOT 通过 registerDotType(config) 注册，配置里包含：解析装备 Buff、取“最强”参数、算每秒伤害、伤害类型、特效模型等。
 * - **普攻命中**：`01．伤害事件.ts` 在同步阶段快照 `isNormalAttack`，经 `registerDamageCallback` 第 6 参传入；装备普攻类 DOT（`Buff:attack:`）由 `tryApplyHeroAttackGearDots` 等路径处理。视为玩家主动叠 debuff；只要装备仍能提供本类 `best`，则**有条必刷新满额 time**（与乘积、字段漂移无关）。无条则新建。
 * - **非普攻伤害**（技能等）：仍用「同解析 time → 刷新」或「新乘积更大 → 换条」；DOT 秒跳自伤靠 ignoredTargetByType 整轮跳过，batch 仅挡无普攻位的回调。
 * - **剩余秒数**：由 `05．Buff系统.00．Buff系统` 的 Buff 池以 `BUFF_POOL_TICK`（0.1s）递减；本模块每 tick 末 `syncDotRemainingFromBuffPool` 把池内 remaining/effect 写回 `stateByType`。**单位被 `PauseUnit` 暂停时** Buff 池不扣秒、DOT 秒跳不结算（`IsUnitPausedBJ`，与 `06．DOT执行器` 一致）。
 * - **dotTimer**：每 1 秒按条目的 amount 造成伤害并播特效；到期以池为准移除条目；effectRecycleTimer 统一回收特效。
 * - 若某 DOT 需要“附加效果”（如 10 秒内减 50 攻），可在 config 里提供 onApply/onTick/onEnd 回调，在施加/每跳/结束时执行。
 *
 * 与 `01．Buff表.ts` 对应：D001「反恢复」、D002「燃烧」、D003「中毒」、D004「巨魔头颅诅咒」等（`effect` 行与表同步）。
 * **图标与每跳特效模型**：只改 `01．Buff表.ts` 的 `icon` / `effect`，勿在本文件写死路径。
 * - 反恢复：装备 `Buff:dmg:AntiHeal200%;time3` → 精神伤害，每秒 regenHP×200%，持续 time 秒。
 * - 燃烧：装备 `Buff:dmg:Burn50;time5` → 火焰伤害，每秒固定 damage 点，持续 time 秒（数值由解析结果决定）。
 */
// ========== 虚拟分区：运行时依赖 ==========
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;

// ========== 虚拟分区：DOT 子模块导入 ==========
import {
  dotEffectModelFromBuffRow,
  type DotState,
  type DotTypeConfig,
} from "./01．DOT定义/01．DOT配置";
import { registerBuiltInDotTypes } from "./01．DOT定义/03．DOT类型定义";
import {
  getDotSourceDisplayName,
  isValidDotStateRow,
  tabDeleteHid,
  tabRowForHid,
  tabSetHid,
  unitHid,
} from "./01．DOT定义/04．DOT工具";
import { createDotStateSync } from "./01．DOT定义/05．DOT状态同步";
import { createDotExecutor } from "./01．DOT定义/06．DOT执行器";
import { createDotApplyStrategy } from "./01．DOT定义/07．DOT施加策略";
import { createDotBaseUtils } from "./01．DOT定义/08．DOT基础工具";

// ========== 虚拟分区：其它依赖 ==========
const { fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (four: number) => string;
};
const damageEventModule = require("系统.04．伤害系统.01．伤害事件") as {
  markNextPendingDamageAsDotTickBatch: () => void;
  registerDamageCallback: (
    cb: (unit: any, d: number, t: number, fromDotTickBatch?: boolean, source?: any, isNormalAttack?: boolean) => void,
    interval?: number
  ) => void;
};
const leakCore = require("lib.扩展函数.封装函数.05．泄露审计.index") as { LeakWatcher?: any };
const LeakWatcher = leakCore.LeakWatcher ?? leakCore;

// ========== 虚拟分区：DOT 类型配置与注册 ==========
const dotTypes: DotTypeConfig[] = [];

/** 注册一种 DOT，后续伤害回调会按配置解析装备并施加/覆盖 */
export function registerDotType(config: DotTypeConfig): void {
  dotTypes.push(config);
}

// ========== 虚拟分区：Buff 池桥接 ==========
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

// ========== 虚拟分区：运行时状态 ==========
/** 按类型、再按目标存状态。stateByType[typeId][GetHandleId(target)] = { effect, remaining, _dotUnitRef?, ... } */
const stateByType: Record<string, Record<any, DotState>> = {};
/** 每 1 秒执行一次的伤害条：typeId、来源、目标、每跳伤害、特效用模型与时长（是否仍持续以 Buff 池 remaining 为准） */
interface DotTickEntry { typeId: string; source: any; target: any; amount: number; effectModel: string; effectDuration: number }
const dotTicks: DotTickEntry[] = [];

/** 刚被我们「某类型」伤害打到的单位，下一帧伤害回调里跳过对该类型施加，避免 DOT 触发的伤害再次叠 DOT */
const ignoredTargetByType: Record<string, Record<any, boolean>> = {};

// ========== 虚拟分区：装备数据源 ==========
const equipDataMod = require("系统.02．物品系统.01．装备数据") as {
  items?: Record<string, { Buff?: string }>;
  default?: Record<string, { Buff?: string }>;
};
const itemsData = equipDataMod.items ?? equipDataMod.default ?? {};
const dotBaseUtils = createDotBaseUtils({
  jass: jass as any,
  g: g as any,
  itemsData: itemsData as Record<string, { Buff?: string }>,
  fourCCToString,
});

// ========== 虚拟分区：dotTicks 清理 ==========
function removeDotTicksForTargetHid(typeId: string, tgtHid: number): void {
  for (let i = dotTicks.length - 1; i >= 0; i--) {
    const e = dotTicks[i];
    if (e.typeId === typeId && unitHid(e.target) === tgtHid) dotTicks.splice(i, 1);
  }
}

// ========== 虚拟分区：子模块装配（sync / executor / strategy） ==========
const dotStateSync = createDotStateSync({
  stateByType,
  dotTypes,
  removeDotTicksForTargetHid,
  notifyBuffPool,
});

const dotExecutor = createDotExecutor({
  jass: jass as any,
  LeakWatcher,
  dotTypes,
  dotTicks,
  stateByType,
  ignoredTargetByType,
  damageEventModule,
  unitHid,
  tabRowForHid,
  isValidDotStateRow,
});

const dotApplyStrategy = createDotApplyStrategy({
  dotTypes,
  stateByType,
  dotTicks,
  ignoredTargetByType,
  unitHid,
  isSourceHeroPlayer1to4: dotBaseUtils.isSourceHeroPlayer1to4,
  isDebuffDotTargetOk: dotBaseUtils.isDebuffDotTargetOk,
  tabRowForHid,
  tabSetHid,
  tabDeleteHid,
  isValidDotStateRow,
  getDotSourceDisplayName,
  notifyBuffPool,
  ensureDotTimers: () => dotExecutor.ensureDotTimers(),
  getDotTickBatchTargetHids: () => dotExecutor.getDotTickBatchTargetHids(),
});


/**
 * Buff 池每 0.1s 递减后调用：把池内 remaining/effect 写回 `stateByType`；池已无行则清理逻辑层与秒跳队列。
 */
export function syncDotRemainingFromBuffPool(): void {
  dotStateSync.syncDotRemainingFromBuffPool();
}

/** Buff 池判定某 DOT 到期时调用（池行已删，勿再 syncDotBuff null） */
export function clearDotByBuffPoolExpire(buffID: string, hid: number): void {
  dotStateSync.clearDotByBuffPoolExpire(buffID, hid);
}

// ========== 虚拟分区：普攻装备 DOT 入口 ==========
/**
 * 伤害事件延后展示前调用：用 entry.gearDotAttackRefreshHint 判定普攻位（已在事件同步阶段快照，不依赖 jass 全局），每刀只叠一次装备 DOT，避免多段伤害丢 8192/16384。
 * 与 `onDamage` 内普攻分支互斥：回调里 `isAttackHitForDot` 为真时不再叠层。
 */
export function tryApplyHeroAttackGearDots(source: any, target: any, _damage: number): void {
  dotApplyStrategy.tryApplyHeroAttackGearDots(source, target, _damage);
}


// ========== 虚拟分区：DOT 秒跳批次通知 ==========
/** 由 伤害事件.runDeferredDamageDisplay 在每段 DOT 伤害展示回调结束后调用，替代 Timer(0) 清空 batch（避免早于 deferred onDamage） */
export function notifyDotTickBatchDamageDisplayed(): void {
  dotExecutor.notifyDotTickBatchDamageDisplayed();
}

// ========== 虚拟分区：伤害回调入口（委托策略模块） ==========
function onDamage(target: any, damage: number, damageType: number, fromDotTickBatch?: boolean, source?: any, isNormalAttackHit?: boolean): void {
  dotApplyStrategy.onDamage(target, damage, damageType, fromDotTickBatch, source, isNormalAttackHit);
}

// ========== 虚拟分区：基础工具桥接（供 DOT 类型定义 / 策略） ==========
const getBestDotFromUnit = dotBaseUtils.getBestDotFromUnit;
const getUnitMaxHp = dotBaseUtils.getUnitMaxHp;
const getTargetRegenHP = dotBaseUtils.getTargetRegenHP;

// ========== 虚拟分区：内置 DOT 注册 ==========
registerBuiltInDotTypes({
  registerDotType,
  getBestDotFromUnit,
  getTargetRegenHP,
  getUnitMaxHp,
  dotEffectModelFromBuffRow,
});

// ========== 虚拟分区：对外查询/调用 API ==========
let registered = false;

function getDotStateByTypeId(typeId: string, unit: any): DotState | null {
  const tab = (stateByType as any)[typeId];
  if (tab == null || unit == null || unit === 0) return null;
  const h = unitHid(unit);
  if (h === 0) return null;
  const raw = tabRowForHid(tab, h);
  return raw != null && isValidDotStateRow(raw) ? (raw as DotState) : null;
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

/** 造成精神伤害（供外部直接调用，如其他技能）；会标记 target 以免伤害回调再次施加同源 DOT。 */
export function dealSpiritDamage(source: any, target: any, amount: number): void {
  dotExecutor.dealDamageForType("antiHeal", source, target, amount);
}

/** 造成火焰伤害（外部技能与 burn DOT 同源类型时可调用） */
export function dealBurnDamage(source: any, target: any, amount: number): void {
  dotExecutor.dealDamageForType("burn", source, target, amount);
}

// ========== 虚拟分区：伤害回调注册 ==========
if (!registered) {
  registered = true;
  // 先取出再调用，避免 TSTL 生成 damageEventModule:registerDamageCallback（模块表当 self 传入）
  const registerCb = damageEventModule.registerDamageCallback;
  if (registerCb != null) {
    registerCb(onDamage);
  }
}
