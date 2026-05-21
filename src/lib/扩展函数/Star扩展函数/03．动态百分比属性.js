const { SGSS_SetStatePercentumEX2 } = require("lib.扩展函数.Star扩展函数.00．SGSS");
const aliasToCanonical = {
    "生命": "生命值",
    "生命上限": "生命值",
    "法力": "法力值",
    "魔法值": "法力值",
    "法力上限": "法力值",
    "攻击": "攻击力",
    "防御": "护甲",
};
const maxPercentRegistry = {
    "生命值": (unit, value) => SGSS_SetStatePercentumEX2(unit, 7, value),
    "法力值": (unit, value) => SGSS_SetStatePercentumEX2(unit, 8, value),
};
const basePercentRegistry = {
    "生命值": (unit, value) => callGSUnitPry(unit, 13, value),
    "攻击力": (unit, value) => callGSUnitPry(unit, 14, value),
    "护甲": (unit, value) => callGSUnitPry(unit, 15, value),
};
function callGSUnitPry(unit, id, value) {
    const fn = globalThis.GS_UnitPry;
    if (typeof fn === "function")
        fn(unit, 0, id, value);
}
function normalizeKey(base) {
    const trimmed = (base || "").trim();
    if (trimmed === "")
        return "";
    return aliasToCanonical[trimmed] || trimmed;
}
function trimPercentName(name) {
    if (!name || name.length < 3 || name.indexOf("%") !== name.length - 1)
        return { mode: "none", base: "" };
    const core = name.substring(0, name.length - 1); // 去掉 %
    if (core.indexOf("最大") === 0)
        return { mode: "max", base: normalizeKey(core.substring(2)) };
    if (core.indexOf("基础") === 0)
        return { mode: "base", base: normalizeKey(core.substring(2)) };
    // 无前缀百分比，默认按“基础%”处理（如 护甲%、攻击力%、生命值%）
    return { mode: "base", base: normalizeKey(core) };
}
function applyFromRegistry(mode, base, unit, value) {
    if (mode === "max") {
        const applier = maxPercentRegistry[base];
        if (applier != null) {
            applier(unit, value);
            return true;
        }
        return false;
    }
    const applier = basePercentRegistry[base];
    if (applier != null) {
        applier(unit, value);
        return true;
    }
    return false;
}
export function registerDynamicPercentProperty(mode, key, applier) {
    const normalized = normalizeKey(key);
    if (normalized === "")
        return;
    if (mode === "max") {
        maxPercentRegistry[normalized] = applier;
    }
    else {
        basePercentRegistry[normalized] = applier;
    }
}
export function applyDynamicPercentProperty(unit, statName, value) {
    if (!unit || value === 0)
        return false;
    const parsed = trimPercentName(statName);
    if (parsed.mode === "none" || parsed.base === "")
        return false;
    return applyFromRegistry(parsed.mode, parsed.base, unit, value);
}
/** @noSelfInFile */
