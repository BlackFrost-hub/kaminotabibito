local ____lualib = require("lualib_bundle")
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local ____exports = {}
--- 单位恢复特性配置表
-- 
-- key: 单位类型ID（字符串形式，如 'H00R'）
-- value: 恢复特性配置
____exports.UNIT_REGEN_TRAITS = {H00R = {lifeMultiplier = 1.6, manaMultiplier = 1}}
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
--- 获取单位生命恢复倍率
-- 
-- @param unit 目标单位
-- @returns 生命恢复倍率（默认1.0）
function ____exports.getUnitLifeRegenMultiplier(self, unit)
    local unitTypeId = jass.GetUnitTypeId(unit)
    for ____, ____value in ipairs(__TS__ObjectEntries(____exports.UNIT_REGEN_TRAITS)) do
        local idStr = ____value[1]
        local trait = ____value[2]
        if stringToFourCC(nil, idStr) == unitTypeId then
            return trait.lifeMultiplier
        end
    end
    return 1
end
--- 获取单位魔法恢复倍率
-- 
-- @param unit 目标单位
-- @returns 魔法恢复倍率（默认1.0）
function ____exports.getUnitManaRegenMultiplier(self, unit)
    local unitTypeId = jass.GetUnitTypeId(unit)
    for ____, ____value in ipairs(__TS__ObjectEntries(____exports.UNIT_REGEN_TRAITS)) do
        local idStr = ____value[1]
        local trait = ____value[2]
        if stringToFourCC(nil, idStr) == unitTypeId then
            return trait.manaMultiplier
        end
    end
    return 1
end
return ____exports
