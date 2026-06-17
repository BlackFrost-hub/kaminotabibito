--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_2.UnitHasItemOfTypeBJ
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_3.getServerTime
local GetHandleId = jass.GetHandleId
local _____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1ID_7F13_5B58 = {}
local _____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_51B7_5374_8868 = {}
____exports["第三章主线Boss战利品装备名"] = {
    ["地核熔炉之心"] = "地核熔炉之心",
    ["锻造者手套"] = "锻造者手套",
    ["冰焰宝珠"] = "冰焰宝珠",
    ["怨火核心碎片"] = "怨火核心碎片",
    ["永恒轮回法典"] = "永恒轮回法典"
}
____exports["取第三章主线Boss战利品物品ID"] = function(_____88C5_5907_540D)
    local cached = _____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1ID_7F13_5B58[_____88C5_5907_540D]
    if cached ~= nil then
        return cached
    end
    local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
    local id = stringToFourCCSafe(rawId)
    _____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1ID_7F13_5B58[_____88C5_5907_540D] = id
    return id
end
____exports["单位持有第三章主线Boss战利品"] = function(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 then
        return false
    end
    local itemId = ____exports["取第三章主线Boss战利品物品ID"](_____88C5_5907_540D)
    if itemId == 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(unit, itemId) == true
end
____exports["取第三章主线Boss战利品冷却键"] = function(unit, tag)
    if unit == nil or unit == 0 then
        return ""
    end
    return (tag .. ":") .. tostring(GetHandleId(unit))
end
____exports["第三章主线Boss战利品冷却中"] = function(key)
    if key == "" then
        return true
    end
    return (_____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_51B7_5374_8868[key] or 0) > getServerTime()
end
____exports["设置第三章主线Boss战利品冷却"] = function(key, _____79D2_6570)
    if key == "" then
        return
    end
    _____7B2C_4E09_7AE0_4E3B_7EBFBoss_6218_5229_54C1_51B7_5374_8868[key] = getServerTime() + _____79D2_6570 * 1000
end
____exports["是技能伤害快照"] = function(snapshot)
    return snapshot ~= nil and (snapshot.isSkillAttack == true or snapshot.isSkillDamage == true)
end
return ____exports
