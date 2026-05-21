--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local jass = require("jass.common")
local jglobals = require("jass.globals")
local RectContainsUnit = jass.RectContainsUnit
local _____6C99_6F20_533A_57DF1 = jglobals.gg_rct______________u
local _____6C99_6F20_533A_57DF2 = jglobals.gg_rct______________047
local function _____53D6_88C5_5907_7269_54C1ID(_____88C5_5907_540D_79F0)
    local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D_79F0)
    if rawId == nil or rawId == "" then
        return 0
    end
    return stringToFourCCSafe(rawId)
end
local _____7CBE_6C99_6218_65A7ID = _____53D6_88C5_5907_7269_54C1ID("精沙战斧")
____exports["处理精沙战斧伤害修正"] = function(context)
    local attacker = context.attacker
    if attacker == nil or attacker == 0 then
        return context.currentDamage
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(attacker, _____7CBE_6C99_6218_65A7ID) then
        return context.currentDamage
    end
    local _____5728_533A_57DF1 = _____6C99_6F20_533A_57DF1 ~= nil and RectContainsUnit(_____6C99_6F20_533A_57DF1, attacker) == true
    local _____5728_533A_57DF2 = _____6C99_6F20_533A_57DF2 ~= nil and RectContainsUnit(_____6C99_6F20_533A_57DF2, attacker) == true
    if not _____5728_533A_57DF1 and not _____5728_533A_57DF2 then
        return context.currentDamage
    end
    return context.currentDamage * 1.3
end
return ____exports
