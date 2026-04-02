/**
 * 装备成长：单位使用物品时，若装备数据有 PowerUP 字段，执行属性成长。
 * 格式：  段1+段2+...，段内用 ; 分隔效果；time>0 表示临时（N秒后撤销），time0/无time=永久
 * 效果类型：Nstat / N%stat / Nexp / Nlevel / (level*N)stat / (level*N)exp
 * 规则详见 .cursor/rules/equip-heal-hot-format.md
 */
const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as { [k: string]: any };
const itemsData = (require("系统.02．物品系统.01．装备数据") as { default: Record<string, { PowerUP?: string }> }).default;
const { AddGoldWithFeedback, fourCCToString } = require("系统.00．核心系统.01．封装函数") as {
  AddGoldWithFeedback: (p: { delta: number; player?: any; unit?: any }) => void;
  fourCCToString: (four: number) => string;
};

/** key -> 显示名（与装备系统.ts STAT_CONFIG 保持一致） */
const KEY_TO_NAME: Record<string, string> = {
  hp: "生命值", mp: "魔法值", dmg: "攻击力", armor: "护甲", atkSpeed: "攻速",
  movespeed: "叠加移动速度", str: "力量", agi: "敏捷", int: "智力", all: "全属性",
  critRate: "暴击率", critDmg: "暴击伤害", magicResist: "魔抗",
  hpRegen: "生命恢复", hpRegenPct: "生命恢复%", hpRegenEff: "生命恢复效率",
  skillHeal: "技能治疗率", healReceived: "受到的治疗率",
  mpRegen: "魔法恢复", mpRegenPct: "魔法恢复%", mpCost: "魔法消耗",
  cdReduction: "冷却缩减", accuracy: "命中率", dodge: "闪避率",
  armorPierce: "护甲穿透", magicPierce: "魔法穿透",
  skillDmg: "技能伤害", skillResist: "技能抗性", magicDmg: "魔法伤害",
  physDmg: "物理伤害", physResist: "物理抗性", enhanceDmg: "强化伤害",
  atkDmg: "普攻伤害", atkResist: "普攻抗性",
  lightDmg: "光属性伤害", lightResist: "光属性抗性",
  darkDmg: "暗属性伤害", darkResist: "暗属性抗性",
  woodDmg: "木属性伤害", woodResist: "木属性抗性",
  fireDmg: "火属性伤害", fireResist: "火属性抗性",
  thunderDmg: "雷属性伤害", thunderResist: "雷属性抗性",
  waterDmg: "水属性伤害", waterResist: "水属性抗性",
  MetalResist: "金属性抗性", summonDmg: "召唤物伤害", summonResist: "召唤物抗性",
  dmgReduction: "伤害减少", dmgReductionPct: "伤害减少%",
  lifeSteal: "伤害吸血", magicLifeSteal: "魔法伤害吸血", atkLifeSteal: "普攻伤害吸血",
  critRateTaken: "被暴击率", critDmgTaken: "被暴击伤害", stunResist: "眩晕抗性",
  magicAtkDmg: "魔法普攻伤害", antMastery: "蝼蚁专精", movespeed2: "移动速度",
  dmgBonus: "伤害%", finalDamageMultiplier: "最终伤害%", expGainRate: "经验获取率",
  hpPct: "最大生命值%", baseDmgPct: "基础攻击力%",
};

/** 根据原始 key 字符串（大小写不敏感）查找 KEY_TO_NAME 里的正确 key */
function findStatKey(raw: string): string {
  if (KEY_TO_NAME[raw] !== undefined) return raw;
  const rl = raw.toLowerCase();
  for (const k in KEY_TO_NAME) {
    if (k.toLowerCase() === rl) return k;
  }
  return "";
}

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
          const ak = findStatKey(rawKey);
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
        const ak = findStatKey(rawKey);
        if (ak !== "") effects.push({ type: "stat", key: ak, isPct, value: isPct ? num / 100 : num, isLevelMult: false });
      }
    }
    if (effects.length > 0) segments.push({ effects, timeSec });
  }
  return segments;
}

/** key → ApplyItemBonus 读取的固定全局变量名 */
const KEY_TO_UDG: Record<string, string> = {
  hp: "udg_TempHp", mp: "udg_TempMp", dmg: "udg_TempDmg", armor: "udg_TempArmor",
  atkSpeed: "udg_TempAtkSpeed", movespeed: "udg_TempMoveSpeed",
  str: "udg_TempStr", agi: "udg_TempAgi", int: "udg_TempInt", all: "udg_TempAll",
};

/** 通过 ApplyItemBonus 批量加/减属性
 *  value 永远传正数；isAdd 控制加/减方向（固定全局由 TempIsAdd 控制符号；TempAmount 需带符号用于数据追踪）
 */
function applyStats(unit: any, statEffects: { name: string; key: string; value: number }[], isAdd: boolean): void {
  if (statEffects.length === 0) return;
  // 重置所有固定全局
  g.udg_TempHp = 0; g.udg_TempMp = 0; g.udg_TempDmg = 0; g.udg_TempArmor = 0;
  g.udg_TempAtkSpeed = 0; g.udg_TempMoveSpeed = 0;
  g.udg_TempStr = 0; g.udg_TempAgi = 0; g.udg_TempInt = 0; g.udg_TempAll = 0;
  // 设置基础属性的固定全局（始终正数，TempIsAdd 控制符号）
  for (let i = 0; i < statEffects.length; i++) {
    const udgKey = KEY_TO_UDG[statEffects[i].key];
    if (udgKey !== undefined) g[udgKey] = statEffects[i].value;
  }
  (jass as any).udg_TempUnit[1] = unit;
  g.udg_TempIsAdd = isAdd;
  g.udg_TempStatCount = statEffects.length;
  g.udg_TempString = {};
  g.udg_TempAmount = {};
  for (let i = 0; i < statEffects.length; i++) {
    g.udg_TempString[i + 1] = statEffects[i].name;
    // TempAmount 用于数据追踪：加时正，撤销时负
    g.udg_TempAmount[i + 1] = isAdd ? statEffects[i].value : -statEffects[i].value;
  }
  if (typeof (jass as any).ExecuteFunc === "function") (jass as any).ExecuteFunc("ApplyItemBonus");
}

/** 分 10 份给经验，避免跳级触发不到 */
function addHeroXP(unit: any, amount: number): void {
  if (amount <= 0) return;
  const chunk = Math.floor(amount / 10);
  for (let i = 0; i < 10; i++) {
    if (typeof (jass as any).AddHeroXP === "function") (jass as any).AddHeroXP(unit, chunk, true);
  }
  const remainder = amount - chunk * 10;
  if (remainder > 0 && typeof (jass as any).AddHeroXP === "function") {
    (jass as any).AddHeroXP(unit, remainder, true);
  }
}

function getHeroLevel(unit: any): number {
  return typeof (jass as any).GetHeroLevel === "function" ? (jass as any).GetHeroLevel(unit) : 1;
}

/**
 * 获取单位当前属性的绝对值，用于百分比计算。
 * str/agi/int 用 GetHeroStr/Agi/Int；hp/mp 用 GetUnitState+ConvertUnitState；
 * dmg=ConvertUnitState(0x15)，armor=ConvertUnitState(0x20)（需要 japi）
 */
function getPctStatValue(unit: any, key: string): number {
  if (key === "int") return typeof (jass as any).GetHeroInt === "function" ? (jass as any).GetHeroInt(unit, true) : 0;
  if (key === "str") return typeof (jass as any).GetHeroStr === "function" ? (jass as any).GetHeroStr(unit, true) : 0;
  if (key === "agi") return typeof (jass as any).GetHeroAgi === "function" ? (jass as any).GetHeroAgi(unit, true) : 0;
  if (key === "hp")  return typeof (jass as any).GetUnitState === "function" ? (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(1)) : 0;
  if (key === "mp")  return typeof (jass as any).GetUnitState === "function" ? (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(3)) : 0;
  if (key === "dmg") return typeof (jass as any).GetUnitState === "function" ? (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(0x15)) : 0;
  if (key === "armor") return typeof (jass as any).GetUnitState === "function" ? (jass as any).GetUnitState(unit, (jass as any).ConvertUnitState(0x20)) : 0;
  return 0;
}

/** 对 unit 所属玩家的金币做一次百分比加减（pct 可负） */
function applyGoldPct(unit: any, pct: number): void {
  if (typeof (jass as any).GetOwningPlayer !== "function") return;
  const player = (jass as any).GetOwningPlayer(unit);
  if (!player) return;
  const stateGold = (jass as any).ConvertPlayerState(1);
  const cur: number = typeof (jass as any).GetPlayerState === "function"
    ? (jass as any).GetPlayerState(player, stateGold) : 0;
  const delta = Math.round(cur * pct);
  const newVal = cur + delta < 0 ? 0 : cur + delta;
  if (typeof (jass as any).SetPlayerState === "function") {
    (jass as any).SetPlayerState(player, stateGold, newVal);
  }
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
        ? Math.floor(getHeroLevel(unit) * eff.value)
        : Math.floor(eff.value);
      addHeroXP(unit, amount);
    } else if (eff.type === "level") {
      const cur = getHeroLevel(unit);
      const add = eff.isLevelMult ? Math.floor(cur * eff.value) : Math.floor(eff.value);
      if (add > 0 && typeof (jass as any).SetHeroLevel === "function") {
        (jass as any).SetHeroLevel(unit, cur + add, true);
      }
    } else if (eff.type === "stat" && eff.key !== undefined && eff.key !== "") {
      const name = KEY_TO_NAME[eff.key];
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
  if (goldPct !== 0) {
    if (seg.timeSec <= 0) {
      applyGoldPct(unit, goldPct);
    } else {
      const capturedUnit = unit;
      const capturedPct = goldPct;
      let remaining = Math.floor(seg.timeSec);
      const dt = typeof (jass as any).CreateTimer === "function" ? (jass as any).CreateTimer() : undefined;
      if (dt && typeof (jass as any).TimerStart === "function") {
        const t = dt;
        (jass as any).TimerStart(t, 1.0, true, () => {
          applyGoldPct(capturedUnit, capturedPct);
          remaining = remaining - 1;
          if (remaining <= 0) {
            if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(t);
          }
        });
      }
    }
  }

  // 固定/范围金币：使用封装函数（单位：漂浮字 + 1500 范围音效）
  if (goldFixed.length > 0) {
    for (let i = 0; i < goldFixed.length; i++) {
      const mn = Math.floor(goldFixed[i].min);
      const mx = Math.floor(goldFixed[i].max);
      let delta = mn;
      if (mx !== mn) {
        const a = mn < mx ? mn : mx;
        const b = mn < mx ? mx : mn;
        delta = (math as any).random(a, b);
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
      const dt = typeof (jass as any).CreateTimer === "function" ? (jass as any).CreateTimer() : undefined;
      if (dt && typeof (jass as any).TimerStart === "function") {
        const t = dt;
        (jass as any).TimerStart(t, seg.timeSec, false, () => {
          applyStats(capturedUnit, capturedStats, false);
          if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(t);
        });
      }
    }
  }
}

function onUseItem(): void {
  const unit = typeof (jass as any).GetManipulatingUnit === "function"
    ? (jass as any).GetManipulatingUnit() : undefined;
  const item = typeof (jass as any).GetManipulatedItem === "function"
    ? (jass as any).GetManipulatedItem() : undefined;
  if (!unit || !item) return;
  if (typeof (jass as any).IsUnitType === "function" && jass.IsUnitType(unit, (jass as any).UNIT_TYPE_SUMMONED)) return;
  if (typeof (jass as any).IsUnitIllusionBJ === "function" && (jass as any).IsUnitIllusionBJ(unit)) return;
  const itemId = typeof (jass as any).GetItemTypeId === "function" ? (jass as any).GetItemTypeId(item) : 0;
  const idStr = fourCCToString(itemId);
  const entry = (itemsData as Record<string, { PowerUP?: string }>)[idStr];
  if (!entry || !entry.PowerUP) return;

  // 防重：USE_ITEM 会触发两次
  const glob = globalThis as any;
  const key = "__EquipPowerUP_" + tostring(unit) + "_" + idStr;
  if (glob[key]) return;
  glob[key] = true;
  const ct = typeof (jass as any).CreateTimer === "function" ? (jass as any).CreateTimer() : undefined;
  if (ct && typeof (jass as any).TimerStart === "function") {
    const t = ct;
    (jass as any).TimerStart(t, 0.5, false, () => {
      glob[key] = undefined;
      if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(t);
    });
  }

  const segments = parsePowerUP(entry.PowerUP);
  for (const seg of segments) {
    executeSegment(unit, seg);
  }
}

const INIT_KEY = "__EquipPowerUPInited";
function init(): void {
  if ((g as any)[INIT_KEY]) return;
  (g as any)[INIT_KEY] = true;
  const useItemEv = (jass as any).EVENT_PLAYER_UNIT_USE_ITEM ?? 35;
  const trig = jass.CreateTrigger();
  for (let i = 0; i <= 6; i++) jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), useItemEv, undefined!);
  const p13 = (jass as any).Player?.(13);
  if (p13 != null) jass.TriggerRegisterPlayerUnitEvent(trig, p13, useItemEv, undefined!);
  jass.TriggerAddAction(trig, onUseItem);
}

init();
export {};
