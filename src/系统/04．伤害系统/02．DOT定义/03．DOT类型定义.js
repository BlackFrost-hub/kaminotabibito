import { getDotBuffRow } from "./01．DOT配置";
import { parseStandardDotBuff, readNumberFromString } from "./02．DOT解析";
// ========== 虚拟分区：运行时依赖 ==========
const jass = require("jass.common");
// ========== 虚拟分区：内置 DOT 统一注册入口 ==========
export function registerBuiltInDotTypes(deps) {
    // ========== 虚拟分区：antiHeal ==========
    function parseAntiHealBuff(buffStr) {
        return parseStandardDotBuff(buffStr, "AntiHeal", (effectPct, duration, attackOnly) => ({ effectPct, duration, attackOnly }), false);
    }
    function getBestAntiHealFromUnit(unit) {
        return deps.getBestDotFromUnit(unit, parseAntiHealBuff, (parsed) => parsed.effectPct * parsed.duration);
    }
    deps.registerDotType({
        id: "antiHeal",
        debuffDotEnemyNoStructure: true,
        parseBuff: parseAntiHealBuff,
        getBestFromUnit: getBestAntiHealFromUnit,
        computeAmount: (target, parsed) => {
            const regenHP = deps.getTargetRegenHP(target);
            return regenHP * (parsed.effectPct / 100);
        },
        damageType: jass.DAMAGE_TYPE_MIND,
        effectModel: deps.dotEffectModelFromBuffRow(getDotBuffRow("antiHeal")),
        effectDuration: 0.8,
    });
    // ========== 虚拟分区：burn ==========
    function parseBurnBuff(buffStr) {
        return parseStandardDotBuff(buffStr, "Burn", (damagePerSec, duration, attackOnly) => ({ damagePerSec, duration, attackOnly }), true);
    }
    function getBestBurnFromUnit(unit) {
        return deps.getBestDotFromUnit(unit, parseBurnBuff, (parsed) => parsed.damagePerSec * parsed.duration);
    }
    deps.registerDotType({
        id: "burn",
        debuffDotEnemyNoStructure: true,
        parseBuff: parseBurnBuff,
        getBestFromUnit: getBestBurnFromUnit,
        computeAmount: (_target, parsed) => parsed.damagePerSec ?? 0,
        damageType: jass.DAMAGE_TYPE_FIRE,
        effectModel: deps.dotEffectModelFromBuffRow(getDotBuffRow("burn")),
        effectDuration: 0.75,
    });
    // ========== 虚拟分区：poison ==========
    function parsePoisonBuff(buffStr) {
        return parseStandardDotBuff(buffStr, "Poison", (damagePerSec, duration, attackOnly) => ({ damagePerSec, duration, attackOnly }), true);
    }
    function getBestPoisonFromUnit(unit) {
        return deps.getBestDotFromUnit(unit, parsePoisonBuff, (parsed) => parsed.damagePerSec * parsed.duration);
    }
    deps.registerDotType({
        id: "poison",
        debuffDotEnemyNoStructure: true,
        parseBuff: parsePoisonBuff,
        getBestFromUnit: getBestPoisonFromUnit,
        computeAmount: (_target, parsed) => parsed.damagePerSec ?? 0,
        damageType: jass.DAMAGE_TYPE_ACID,
        effectModel: deps.dotEffectModelFromBuffRow(getDotBuffRow("poison")),
        effectDuration: 0.8,
    });
    // ========== 虚拟分区：trollCurse ==========
    function parseTrollCurseBuff(buffStr) {
        if (!buffStr || typeof buffStr !== "string")
            return null;
        let s = buffStr.trim();
        if (s.indexOf("Buff:") === 0)
            s = s.substring(5);
        let attackOnly = false;
        let rest;
        if (s.indexOf("attack:curse") === 0) {
            attackOnly = true;
            rest = s.substring(13);
        }
        else if (s.indexOf("dmg:curse") === 0) {
            rest = s.substring(9);
        }
        else {
            return null;
        }
        let numEnd = 0;
        while (numEnd < rest.length) {
            const c = rest.charAt(numEnd);
            if (c >= "0" && c <= "9")
                numEnd++;
            else
                break;
        }
        const pctMaxHpPerSec = numEnd > 0 ? parseInt(rest.substring(0, numEnd), 10) || 0 : 0;
        const pctPos = rest.indexOf("%MaxHP");
        if (pctPos < 0 || pctPos !== numEnd)
            return null;
        const timeIdx = rest.indexOf("time");
        if (timeIdx < 0)
            return null;
        const duration = readNumberFromString(rest, timeIdx + 4);
        if (duration <= 0 || pctMaxHpPerSec <= 0)
            return null;
        return { pctMaxHpPerSec, duration, attackOnly };
    }
    function getBestTrollCurseFromUnit(unit) {
        return deps.getBestDotFromUnit(unit, parseTrollCurseBuff, (parsed) => parsed.pctMaxHpPerSec * parsed.duration);
    }
    deps.registerDotType({
        id: "trollCurse",
        debuffDotEnemyNoStructure: true,
        parseBuff: parseTrollCurseBuff,
        getBestFromUnit: getBestTrollCurseFromUnit,
        computeAmount: (target, parsed) => {
            const maxHp = deps.getUnitMaxHp(target);
            return maxHp * (parsed.pctMaxHpPerSec / 100);
        },
        damageType: jass.DAMAGE_TYPE_NORMAL,
        effectModel: deps.dotEffectModelFromBuffRow(getDotBuffRow("trollCurse")),
        effectDuration: 0.8,
    });
}
