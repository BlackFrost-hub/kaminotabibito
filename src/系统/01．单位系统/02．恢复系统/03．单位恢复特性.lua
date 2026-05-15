local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__ObjectEntries = ____lualib.__TS__ObjectEntries
local __TS__ArraySort = ____lualib.__TS__ArraySort
local ____exports = {}
--- 单位恢复特性配置表
-- 
-- key: 游戏内单位名|内部物体ID
-- value: 恢复特性配置
____exports.UNIT_REGEN_TRAITS = {["炎杀姬|H00R"] = {lifeMultiplier = 1.6, manaMultiplier = 1}}
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local function _____63D0_53D6_5185_90E8_7269_4F53ID(self, _____914D_7F6E_952E_540D)
    local _____7247_6BB5_5217_8868 = __TS__StringSplit(_____914D_7F6E_952E_540D, "|")
    return _____7247_6BB5_5217_8868[#_____7247_6BB5_5217_8868] or _____914D_7F6E_952E_540D
end
--- 获取单位生命恢复倍率
-- 
-- @param unit 目标单位
-- @returns 生命恢复倍率（默认1.0）
function ____exports.getUnitLifeRegenMultiplier(self, unit)
    local unitTypeId = jass.GetUnitTypeId(unit)
    local entries = __TS__ArraySort(
        __TS__ObjectEntries(____exports.UNIT_REGEN_TRAITS),
        function(____, ____bindingPattern0, ____bindingPattern1)
            local a
            a = ____bindingPattern0[1]
            local b
            b = ____bindingPattern1[1]
            return a < b and -1 or (a > b and 1 or 0)
        end
    )
    for ____, ____value in ipairs(entries) do
        local _____914D_7F6E_952E_540D = ____value[1]
        local trait = ____value[2]
        if stringToFourCC(
            nil,
            _____63D0_53D6_5185_90E8_7269_4F53ID(nil, _____914D_7F6E_952E_540D)
        ) == unitTypeId then
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
    local entries = __TS__ArraySort(
        __TS__ObjectEntries(____exports.UNIT_REGEN_TRAITS),
        function(____, ____bindingPattern0, ____bindingPattern1)
            local a
            a = ____bindingPattern0[1]
            local b
            b = ____bindingPattern1[1]
            return a < b and -1 or (a > b and 1 or 0)
        end
    )
    for ____, ____value in ipairs(entries) do
        local _____914D_7F6E_952E_540D = ____value[1]
        local trait = ____value[2]
        if stringToFourCC(
            nil,
            _____63D0_53D6_5185_90E8_7269_4F53ID(nil, _____914D_7F6E_952E_540D)
        ) == unitTypeId then
            return trait.manaMultiplier
        end
    end
    return 1
end
return ____exports
