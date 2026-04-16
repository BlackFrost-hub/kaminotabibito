import { getDotBuffRow, type DotTypeConfig } from "./01．DOT配置";
import { parseStandardDotBuff, readNumberFromString } from "./02．DOT解析";

// ========== 虚拟分区：运行时依赖 ==========
const jass = require("jass.common") as any;

// ========== 虚拟分区：解析类型 ==========
type AntiHealParsed = { effectPct: number; duration: number; attackOnly: boolean };
type BurnParsed = { damagePerSec: number; duration: number; attackOnly: boolean };
type PoisonParsed = { damagePerSec: number; duration: number; attackOnly: boolean };
type TrollCurseParsed = { pctMaxHpPerSec: number; duration: number; attackOnly: boolean };

// ========== 虚拟分区：内置 DOT 统一注册入口 ==========
export function registerBuiltInDotTypes(deps: {
  registerDotType: (cfg: DotTypeConfig) => void;
  getBestDotFromUnit: <T extends { duration: number; attackOnly: boolean }>(
    unit: any,
    parseBuff: (s: string) => T | null,
    getProduct: (parsed: T) => number
  ) => T | null;
  getTargetRegenHP: (target: any) => number;
  getUnitMaxHp: (target: any) => number;
  dotEffectModelFromBuffRow: (rowId: "D001" | "D002" | "D003" | "D004") => string;
}): void {
  // ========== 虚拟分区：antiHeal ==========
  function parseAntiHealBuff(buffStr: string): AntiHealParsed | null {
    return parseStandardDotBuff(
      buffStr,
      "AntiHeal",
      (effectPct, duration, attackOnly) => ({ effectPct, duration, attackOnly }),
      false
    );
  }

  function getBestAntiHealFromUnit(unit: any): AntiHealParsed | null {
    return deps.getBestDotFromUnit(unit, parseAntiHealBuff, (parsed) => parsed.effectPct * parsed.duration);
  }

  deps.registerDotType({
    id: "antiHeal",
    debuffDotEnemyNoStructure: true,
    parseBuff: parseAntiHealBuff,
    getBestFromUnit: getBestAntiHealFromUnit,
    computeAmount: (target: any, parsed: any) => {
      const regenHP = deps.getTargetRegenHP(target);
      return regenHP * ((parsed.effectPct as number) / 100);
    },
    damageType: jass.DAMAGE_TYPE_MIND,
    effectModel: deps.dotEffectModelFromBuffRow(getDotBuffRow("antiHeal")),
    effectDuration: 0.8,
  });

  // ========== 虚拟分区：burn ==========
  function parseBurnBuff(buffStr: string): BurnParsed | null {
    return parseStandardDotBuff(
      buffStr,
      "Burn",
      (damagePerSec, duration, attackOnly) => ({ damagePerSec, duration, attackOnly }),
      true
    );
  }

  function getBestBurnFromUnit(unit: any): BurnParsed | null {
    return deps.getBestDotFromUnit(unit, parseBurnBuff, (parsed) => parsed.damagePerSec * parsed.duration);
  }

  deps.registerDotType({
    id: "burn",
    debuffDotEnemyNoStructure: true,
    parseBuff: parseBurnBuff,
    getBestFromUnit: getBestBurnFromUnit,
    computeAmount: (_target: any, parsed: any) => (parsed.damagePerSec as number) ?? 0,
    damageType: jass.DAMAGE_TYPE_FIRE,
    effectModel: deps.dotEffectModelFromBuffRow(getDotBuffRow("burn")),
    effectDuration: 0.75,
  });

  // ========== 虚拟分区：poison ==========
  function parsePoisonBuff(buffStr: string): PoisonParsed | null {
    return parseStandardDotBuff(
      buffStr,
      "Poison",
      (damagePerSec, duration, attackOnly) => ({ damagePerSec, duration, attackOnly }),
      true
    );
  }

  function getBestPoisonFromUnit(unit: any): PoisonParsed | null {
    return deps.getBestDotFromUnit(unit, parsePoisonBuff, (parsed) => parsed.damagePerSec * parsed.duration);
  }

  deps.registerDotType({
    id: "poison",
    debuffDotEnemyNoStructure: true,
    parseBuff: parsePoisonBuff,
    getBestFromUnit: getBestPoisonFromUnit,
    computeAmount: (_target: any, parsed: any) => (parsed.damagePerSec as number) ?? 0,
    damageType: jass.DAMAGE_TYPE_ACID,
    effectModel: deps.dotEffectModelFromBuffRow(getDotBuffRow("poison")),
    effectDuration: 0.8,
  });

  // ========== 虚拟分区：trollCurse ==========
  function parseTrollCurseBuff(buffStr: string): TrollCurseParsed | null {
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
    const duration = readNumberFromString(rest, timeIdx + 4);
    if (duration <= 0 || pctMaxHpPerSec <= 0) return null;
    return { pctMaxHpPerSec, duration, attackOnly };
  }

  function getBestTrollCurseFromUnit(unit: any): TrollCurseParsed | null {
    return deps.getBestDotFromUnit(unit, parseTrollCurseBuff, (parsed) => parsed.pctMaxHpPerSec * parsed.duration);
  }

  deps.registerDotType({
    id: "trollCurse",
    debuffDotEnemyNoStructure: true,
    parseBuff: parseTrollCurseBuff,
    getBestFromUnit: getBestTrollCurseFromUnit,
    computeAmount: (target: any, parsed: any) => {
      const maxHp = deps.getUnitMaxHp(target);
      return maxHp * ((parsed.pctMaxHpPerSec as number) / 100);
    },
    damageType: jass.DAMAGE_TYPE_NORMAL,
    effectModel: deps.dotEffectModelFromBuffRow(getDotBuffRow("trollCurse")),
    effectDuration: 0.8,
  });
}
