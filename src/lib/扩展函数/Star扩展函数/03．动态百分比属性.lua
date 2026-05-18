local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local callGSUnitPry
function callGSUnitPry(unit, id, value)
    local fn = _G.GS_UnitPry
    if type(fn) == "function" then
        fn(unit, 0, id, value)
    end
end
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetStatePercentumEX2 = ____require_result_0.SGSS_SetStatePercentumEX2
local aliasToCanonical = {
    ["生命"] = "生命值",
    ["生命上限"] = "生命值",
    ["法力"] = "法力值",
    ["魔法值"] = "法力值",
    ["法力上限"] = "法力值",
    ["攻击"] = "攻击力",
    ["防御"] = "护甲"
}
local maxPercentRegistry = {
    ["生命值"] = function(____, unit, value) return SGSS_SetStatePercentumEX2(unit, 7, value) end,
    ["法力值"] = function(____, unit, value) return SGSS_SetStatePercentumEX2(unit, 8, value) end
}
local basePercentRegistry = {
    ["生命值"] = function(____, unit, value) return callGSUnitPry(unit, 13, value) end,
    ["攻击力"] = function(____, unit, value) return callGSUnitPry(unit, 14, value) end,
    ["护甲"] = function(____, unit, value) return callGSUnitPry(unit, 15, value) end
}
local function normalizeKey(self, base)
    local trimmed = __TS__StringTrim(base or "")
    if trimmed == "" then
        return ""
    end
    return aliasToCanonical[trimmed] or trimmed
end
local function trimPercentName(self, name)
    if not name or #name < 3 or (string.find(name, "%", nil, true) or 0) - 1 ~= #name - 1 then
        return {mode = "none", base = ""}
    end
    local core = __TS__StringSubstring(name, 0, #name - 1)
    if (string.find(core, "最大", nil, true) or 0) - 1 == 0 then
        return {
            mode = "max",
            base = normalizeKey(
                nil,
                __TS__StringSubstring(core, 2)
            )
        }
    end
    if (string.find(core, "基础", nil, true) or 0) - 1 == 0 then
        return {
            mode = "base",
            base = normalizeKey(
                nil,
                __TS__StringSubstring(core, 2)
            )
        }
    end
    return {
        mode = "base",
        base = normalizeKey(nil, core)
    }
end
local function applyFromRegistry(self, mode, base, unit, value)
    if mode == "max" then
        local applier = maxPercentRegistry[base]
        if applier ~= nil then
            applier(nil, unit, value)
            return true
        end
        return false
    end
    local applier = basePercentRegistry[base]
    if applier ~= nil then
        applier(nil, unit, value)
        return true
    end
    return false
end
function ____exports.registerDynamicPercentProperty(mode, key, applier)
    local normalized = normalizeKey(nil, key)
    if normalized == "" then
        return
    end
    if mode == "max" then
        maxPercentRegistry[normalized] = applier
    else
        basePercentRegistry[normalized] = applier
    end
end
function ____exports.applyDynamicPercentProperty(unit, statName, value)
    if not unit or value == 0 then
        return false
    end
    local parsed = trimPercentName(nil, statName)
    if parsed.mode == "none" or parsed.base == "" then
        return false
    end
    return applyFromRegistry(
        nil,
        parsed.mode,
        parsed.base,
        unit,
        value
    )
end
return ____exports
