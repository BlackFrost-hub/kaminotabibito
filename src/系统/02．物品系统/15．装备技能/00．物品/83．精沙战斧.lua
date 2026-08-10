--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local jass = require("jass.common")
local ____require_result_2 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF_5217_8868 = ____require_result_2["获取矩形区域列表"]
local RectContainsUnit = jass.RectContainsUnit
local _____7CBE_6C99_6218_65A7_6C99_6F20_533A_57DF = _____83B7_53D6_77E9_5F62_533A_57DF_5217_8868({"精沙战斧.沙漠区域1"})
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
    local _____5728_7CBE_6C99_6218_65A7_6C99_6F20_533A_57DF = false
    do
        local i = 0
        while i < #_____7CBE_6C99_6218_65A7_6C99_6F20_533A_57DF do
            if RectContainsUnit(_____7CBE_6C99_6218_65A7_6C99_6F20_533A_57DF[i + 1], attacker) == true then
                _____5728_7CBE_6C99_6218_65A7_6C99_6F20_533A_57DF = true
                break
            end
            i = i + 1
        end
    end
    if not _____5728_7CBE_6C99_6218_65A7_6C99_6F20_533A_57DF then
        return context.currentDamage
    end
    return context.currentDamage * 1.3
end
return ____exports
