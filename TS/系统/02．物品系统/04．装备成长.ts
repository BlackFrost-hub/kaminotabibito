/** @noSelfInFile */
/**
 * 装备成长：单位使用物品时，若装备数据有 PowerUP 字段，执行属性成长。
 * 格式：  段1+段2+...，段内用 ; 分隔效果；time>0 表示临时（N秒后撤销），time0/无time=永久
 * 效果类型：Nstat / N%stat / Nexp / Nlevel / (level*N)stat / (level*N)exp
 * 规则详见 `.cursor/rules/equipment/heal-hot-format.md`
 */
const jass = require("jass.common") as JassCommon;
const GetItemTypeId = (jass as any).GetItemTypeId as (this: void, item: any) => number;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { round } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  round: (this: void, value: number) => number;
};
const { onItemUse } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemUse: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const g = require("jass.globals") as { [k: string]: any };
const { AddGoldWithFeedback, fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  AddGoldWithFeedback: (p: { delta: number; player?: any; unit?: any }) => void;
  fourCCToString: (this: void, four: number) => string;
};
const { IsUnitIllusionBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as {
  IsUnitIllusionBJ: (unit: any) => boolean;
};
const itemRelatedFns = require("lib.扩展函数.物品相关函数.index") as {
  KEY_TO_NAME: Record<string, string>;
  findStatKey: (this: void, raw: string) => string;
  getItemDataEntry: (this: void, item: any) => any | null;
};
const { applyEquipStatsTS } = require("lib.扩展函数.Star扩展函数.01．装备属性应用") as {
  applyEquipStatsTS: (this: void, unit: any, stats: { name: string; value: number }[]) => Record<string, number>;
};
const { onSecond, offSecond } = globalThis as unknown as {
  onSecond: (this: void, cb: () => void) => void;
  offSecond: (this: void, cb: () => void) => void;
};

interface Effect {
  type: "stat" | "exp" | "level" | "gold";
  key?: string;        // stat 时使用
  isPct: boolean;
  value: number;       // 固定值或 level*N 里的 N
  isLevelMult: boolean; // true = (level*N) 语法
  min?: number;        // gold 固定/范围：min
  max?: number;        // gold 固定/范围：max（无则等于 min）
}

interface Segment {
  effects: Effect[];
  timeSec: number; // 0=永久，>0=临时
}

function parsePowerUP(powerUpStr: string): Segment[] {
  const segments: Segment[] = [];
  const rawSegs = powerUpStr.split("+");
  for (let si = 0; si < rawSegs.length; si++) {
    const rawSeg = rawSegs[si].trim();
    if (rawSeg === "") continue;
    const tokens = rawSeg.split(";").map((x) => x.trim()).filter((x) => x !== "");
    let timeSec = 0;
    const effectTokens: string[] = [];
    for (const t of tokens) {
      const tl = t.toLowerCase();
      if (tl.indexOf("time") === 0) {
        const w = parseFloat(t.substring(4)) || 0;
        if (w > timeSec) timeSec = w;
      } else {
        effectTokens.push(t);
      }
    }
    const effects: Effect[] = [];
    for (const t of effectTokens) {
      // gold 特判：支持 "500gold" / "500-7500gold" / "10%gold"
      const tl0 = t.toLowerCase();
      if (tl0.endsWith("gold")) {
        // 百分比：10%gold
        if (tl0.indexOf("%gold") >= 0) {
          const pctStr = t.substring(0, tl0.indexOf("%")).trim();
          const pctNum = parseFloat(pctStr) || 0;
          effects.push({ type: "gold", isPct: true, value: pctNum / 100, isLevelMult: false });
          continue;
        }
        // 固定/范围：500gold / 500-7500gold
        const core = t.substring(0, t.length - 4).trim(); // 去掉 gold
        const dash = core.indexOf("-");
        if (dash >= 0) {
          const a = parseFloat(core.substring(0, dash).trim()) || 0;
          const b = parseFloat(core.substring(dash + 1).trim()) || 0;
          const mn = a < b ? a : b;
          const mx = a < b ? b : a;
          effects.push({ type: "gold", isPct: false, value: 0, isLevelMult: false, min: mn, max: mx });
        } else {
          const v = parseFloat(core) || 0;
          effects.push({ type: "gold", isPct: false, value: 0, isLevelMult: false, min: v, max: v });
        }
        continue;
      }
      // (level*N)key 语法
      if (t.indexOf("(level*") === 0) {
        const closeIdx = t.indexOf(")");
        if (closeIdx < 0) continue;
        const mult = parseFloat(t.substring(7, closeIdx)) || 0;
        const rawKey = t.substring(closeIdx + 1).trim();
        const kl = rawKey.toLowerCase();
        if (kl === "exp") {
          effects.push({ type: "exp", isPct: false, value: mult, isLevelMult: true });
        } else if (kl === "level") {
          effects.push({ type: "level", isPct: false, value: mult, isLevelMult: true });
        } else {
          const ak = itemRelatedFns.findStatKey(rawKey);
          if (ak !== "") effects.push({ type: "stat", key: ak, isPct: false, value: mult, isLevelMult: true });
        }
        continue;
      }
      // N%key 或 Nkey
      const pctIdx = t.indexOf("%");
      const isPct = pctIdx >= 0;
      const cleaned = isPct ? t.substring(0, pctIdx) + t.substring(pctIdx + 1) : t;
      // 找数字结束位置
      let numEnd = 0;
      while (numEnd < cleaned.length) {
        const ch = cleaned.substring(numEnd, numEnd + 1);
        if ((ch >= "0" && ch <= "9") || ch === "." || (numEnd === 0 && ch === "-")) {
          numEnd++;
        } else {
          break;
        }
      }
      const num = parseFloat(cleaned.substring(0, numEnd)) || 0;
      const rawKey = cleaned.substring(numEnd).trim();
      const kl = rawKey.toLowerCase();
      if (kl === "exp") {
        effects.push({ type: "exp", isPct: false, value: num, isLevelMult: false });
      } else if (kl === "level") {
        effects.push({ type: "level", isPct: false, value: num, isLevelMult: false });
      } else if (kl === "gold") {
        // 兼容旧写法：N%gold 走百分比；Ngold 走固定（但不支持范围，这里只当固定）
        if (isPct) effects.push({ type: "gold", isPct: true, value: num / 100, isLevelMult: false });
        else effects.push({ type: "gold", isPct: false, value: 0, isLevelMult: false, min: num, max: num });
      } else {
        const ak = itemRelatedFns.findStatKey(rawKey);
        if (ak !== "") effects.push({ type: "stat", key: ak, isPct, value: isPct ? num / 100 : num, isLevelMult: false });
      }
    }
    if (effects.length > 0) segments.push({ effects, timeSec });
  }
  return segments;
}

/** 通过 TS 装备属性应用器批量加/减属性 */
function applyStats(unit: any, statEffects: { name: string; key: string; value: number }[], isAdd: boolean): void {
  if (statEffects.length === 0) return;
  const payload = isAdd
    ? statEffects
    : statEffects.map((x) => ({ ...x, value: -x.value }));
  applyEquipStatsTS(unit, payload);
}

/** 分 10 份给经验，避免跳级触发不到 */
function addHeroXP(unit: any, amount: number): void {
  if (amount <= 0) return;
  const chunk = (jass as any).R2I(amount / 10);
  for (let i = 0; i < 10; i++) {
    (jass as any).AddHeroXP(unit, chunk, true);
  }
  const remainder = amount - chunk * 10;
  if (remainder > 0) {
    (jass as any).AddHeroXP(unit, remainder, true);
  }
}

function getHeroLevel(unit: any): number {
  return (jass as any).GetHeroLevel(unit);
}

/**
 * 获取单位当前属性的绝对值，用于百分比计算。
 * str/agi/int 用 GetHeroStr/Agi/Int；hp/mp 用 GetUnitState+ConvertUnitState；
 * dmg=ConvertUnitState(0x15)，armor=ConvertUnitState(0x20)（需要 japi）
 */
function getPctStatValue(unit: any, key: string): number {
  if (key === "int") return (jass as any).GetHeroInt(unit, true);
  if (key === "str") return (jass as any).GetHeroStr(unit, true);
  if (key === "agi") return (jass as any).GetHeroAgi(unit, true);
  if (key === "hp")  return (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(1));
  if (key === "mp")  return (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(3));
  if (key === "dmg") return (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(0x15));
  if (key === "armor") return (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(0x20));
  return 0;
}

/** 对 unit 所属玩家的金币做一次百分比加减（pct 可负） */
function applyGoldPct(unit: any, pct: number): void {
  const player = (jass as any).GetOwningPlayer(unit);
  if (!player) return;
  const stateGold = (jass as any).ConvertPlayerState(1);
  const cur: number = (jass as any).GetPlayerState(player, stateGold);
  const delta = round(cur * pct);
  const newVal = cur + delta < 0 ? 0 : cur + delta;
  (jass as any).SetPlayerState(player, stateGold, newVal);
}

function executeSegment(unit: any, seg: Segment): void {
  const statEffects: { name: string; key: string; value: number }[] = [];
  let goldPct = 0;
  const goldFixed: { min: number; max: number }[] = [];

  for (const eff of seg.effects) {
    if (eff.type === "gold") {
      if (eff.isPct) goldPct += eff.value;
      else {
        const mn = typeof eff.min === "number" ? eff.min : 0;
        const mx = typeof eff.max === "number" ? eff.max : mn;
        goldFixed.push({ min: mn, max: mx });
      }
    } else if (eff.type === "exp") {
      const amount = eff.isLevelMult
        ? (jass as any).R2I(getHeroLevel(unit) * eff.value)
        : (jass as any).R2I(eff.value);
      addHeroXP(unit, amount);
    } else if (eff.type === "level") {
      const cur = getHeroLevel(unit);
      const add = eff.isLevelMult ? (jass as any).R2I(cur * eff.value) : (jass as any).R2I(eff.value);
      if (add > 0) {
        (jass as any).SetHeroLevel(unit, cur + add, true);
      }
    } else if (eff.type === "stat" && eff.key !== undefined && eff.key !== "") {
      const name = itemRelatedFns.KEY_TO_NAME[eff.key];
      if (name === undefined) continue;
      let val: number;
      if (eff.isPct) {
        val = getPctStatValue(unit, eff.key) * eff.value;
      } else if (eff.isLevelMult) {
        val = getHeroLevel(unit) * eff.value;
      } else {
        val = eff.value;
      }
      statEffects.push({ name, key: eff.key, value: val });
    }
  }

  // 处理金币百分比效果（每秒一次，持续 timeSec 秒；无 time 则只触发一次）
  // 使用中心计时器的 onSecond：省 timer handle，死亡/到期自动 offSecond 解绑
  if (goldPct !== 0) {
    if (seg.timeSec <= 0) {
      applyGoldPct(unit, goldPct);
    } else {
      const capturedUnit = unit;
      const capturedPct = goldPct;
      let remaining = (jass as any).R2I(seg.timeSec);
      const cb = (): void => {
        if (capturedUnit && (jass as any).IsUnitType(capturedUnit, (jass as any).UNIT_TYPE_DEAD)) {
          offSecond(cb);
          return;
        }
        applyGoldPct(capturedUnit, capturedPct);
        remaining -= 1;
        if (remaining <= 0) {
          offSecond(cb);
        }
      };
      onSecond(cb);
    }
  }

  // 固定/范围金币：使用封装函数（单位：漂浮字 + 1500 范围音效）
  if (goldFixed.length > 0) {
    for (let i = 0; i < goldFixed.length; i++) {
        const mn = (jass as any).R2I(goldFixed[i].min);
        const mx = (jass as any).R2I(goldFixed[i].max);
      let delta = mn;
      if (mx !== mn) {
        const a = mn < mx ? mn : mx;
        const b = mn < mx ? mx : mn;
        delta = (jass as any).GetRandomInt(a, b);
      }
      if (delta !== 0) AddGoldWithFeedback({ delta, unit });
    }
  }

  if (statEffects.length > 0) {
    applyStats(unit, statEffects, true);
    // 临时效果：timer 到期后撤销
    if (seg.timeSec > 0) {
      const capturedStats: { name: string; key: string; value: number }[] = statEffects;
      const capturedUnit = unit;
      安排装备成长属性回退(capturedUnit, capturedStats, seg.timeSec);
    }
  }
}

function onUseItem(): void {
  const unit = (jass as any).GetManipulatingUnit();
  const item = (jass as any).GetManipulatedItem();
  if (!unit || !item) return;
  if (jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return;
  if (IsUnitIllusionBJ(unit)) return;
  const entry = itemRelatedFns.getItemDataEntry(item);
  if (!entry || !entry.PowerUP) return;

  const glob = globalThis as any;
  const idStr = fourCCToString(GetItemTypeId(item));
  const key = "__EquipPowerUP_" + tostring(unit) + "_" + idStr;
  if (glob[key]) return;
  glob[key] = true;
  安排装备成长防抖清理(key, 0.5);

  const segments = parsePowerUP(entry.PowerUP);
  for (const seg of segments) {
    executeSegment(unit, seg);
  }
}

const INIT_KEY = "__EquipPowerUPInited";

const 装备成长计时检查间隔毫秒 = 10;
const 装备成长回退单位列表: any[] = [];
const 装备成长回退属性列表: { name: string; key: string; value: number }[][] = [];
const 装备成长回退到期毫秒列表: number[] = [];
const 装备成长防抖键列表: string[] = [];
const 装备成长防抖到期毫秒列表: number[] = [];
let 装备成长计时检查回调ID = 0;

function 停止装备成长计时检查(this: void): void {
  if (装备成长计时检查回调ID <= 0) return;
  removePeriodicCallback(装备成长计时检查回调ID);
  装备成长计时检查回调ID = 0;
}

function 确保装备成长计时检查(this: void): void {
  if (装备成长计时检查回调ID > 0) return;
  装备成长计时检查回调ID = addPeriodicCallback(装备成长计时检查间隔毫秒, on装备成长计时检查);
}

function 安排装备成长属性回退(
  this: void,
  unit: any,
  stats: { name: string; key: string; value: number }[],
  delaySec: number,
): void {
  装备成长回退单位列表.push(unit);
  装备成长回退属性列表.push(stats);
  装备成长回退到期毫秒列表.push(getServerTime() + delaySec * 1000);
  确保装备成长计时检查();
}

function 安排装备成长防抖清理(this: void, key: string, delaySec: number): void {
  装备成长防抖键列表.push(key);
  装备成长防抖到期毫秒列表.push(getServerTime() + delaySec * 1000);
  确保装备成长计时检查();
}

function 处理装备成长属性回退到期(this: void, now: number): void {
  let writeIndex = 0;
  for (let i = 0; i < 装备成长回退单位列表.length; i++) {
    if (now >= 装备成长回退到期毫秒列表[i]) {
      applyStats(装备成长回退单位列表[i], 装备成长回退属性列表[i], false);
    } else {
      装备成长回退单位列表[writeIndex] = 装备成长回退单位列表[i];
      装备成长回退属性列表[writeIndex] = 装备成长回退属性列表[i];
      装备成长回退到期毫秒列表[writeIndex] = 装备成长回退到期毫秒列表[i];
      writeIndex += 1;
    }
  }
  for (let i = 装备成长回退单位列表.length - 1; i >= writeIndex; i--) {
    装备成长回退单位列表.pop();
    装备成长回退属性列表.pop();
    装备成长回退到期毫秒列表.pop();
  }
}

function 处理装备成长防抖到期(this: void, now: number): void {
  let writeIndex = 0;
  for (let i = 0; i < 装备成长防抖键列表.length; i++) {
    if (now >= 装备成长防抖到期毫秒列表[i]) {
      (globalThis as any)[装备成长防抖键列表[i]] = undefined;
    } else {
      装备成长防抖键列表[writeIndex] = 装备成长防抖键列表[i];
      装备成长防抖到期毫秒列表[writeIndex] = 装备成长防抖到期毫秒列表[i];
      writeIndex += 1;
    }
  }
  for (let i = 装备成长防抖键列表.length - 1; i >= writeIndex; i--) {
    装备成长防抖键列表.pop();
    装备成长防抖到期毫秒列表.pop();
  }
}

function on装备成长计时检查(this: void): void {
  const now = getServerTime();
  处理装备成长属性回退到期(now);
  处理装备成长防抖到期(now);
  if (装备成长回退单位列表.length <= 0 && 装备成长防抖键列表.length <= 0) {
    停止装备成长计时检查();
  }
}

function init(): void {
  if ((g as any)[INIT_KEY]) return;
  (g as any)[INIT_KEY] = true;
  // 使用物品事件中心注册，减少触发器数量
  onItemUse((unit, item) => {
    onUseItem();
  });
}

init();
export {};
