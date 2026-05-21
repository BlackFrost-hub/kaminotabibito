/** @noSelfInFile */

import { getDotBuffRow, dotEffectModelFromBuffRow, type DotTypeConfig } from "../01．DOT配置";
import { parseStandardDotBuff } from "../02．DOT解析";

type 燃烧解析结果 = { damagePerSec: number; duration: number; attackOnly: boolean };

function 解析燃烧Buff(buffStr: string): 燃烧解析结果 | null {
  return parseStandardDotBuff(
    buffStr,
    "Burn",
    (damagePerSec, duration, attackOnly) => ({ damagePerSec, duration, attackOnly }),
    true
  );
}

function 取最优燃烧Dot(
  unit: any,
  getBestDotFromUnit: <T extends { duration: number; attackOnly: boolean }>(
    unit: any,
    parseBuff: (s: string) => T | null,
    getProduct: (parsed: T) => number
  ) => T | null
): 燃烧解析结果 | null {
  return getBestDotFromUnit(unit, 解析燃烧Buff, (parsed) => parsed.damagePerSec * parsed.duration);
}

export function 注册燃烧DOT(this: void, deps: {
  registerDotType: (cfg: DotTypeConfig) => void;
  getBestDotFromUnit: <T extends { duration: number; attackOnly: boolean }>(
    unit: any,
    parseBuff: (s: string) => T | null,
    getProduct: (parsed: T) => number
  ) => T | null;
}): void {
  const registerDotType = deps.registerDotType;
  const getBestDotFromUnitFn = deps.getBestDotFromUnit;

  registerDotType({
    id: "burn",
    debuffDotEnemyNoStructure: true,
    parseBuff: (buffStr: string) => 解析燃烧Buff(buffStr),
    getBestFromUnit: (unit: any) => {
      const getBestDotFromUnit = getBestDotFromUnitFn;
      return getBestDotFromUnit(
        unit,
        (buffStr: string) => 解析燃烧Buff(buffStr),
        (parsed) => parsed.damagePerSec * parsed.duration
      );
    },
    computeAmount: (_target: any, parsed: any) => (parsed.damagePerSec as number) ?? 0,
    damageType: (require("jass.common") as any).DAMAGE_TYPE_FIRE,
    effectModel: dotEffectModelFromBuffRow(getDotBuffRow("burn")),
    effectDuration: 0.75,
  });
}
