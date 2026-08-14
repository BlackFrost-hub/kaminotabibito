--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 控制重施放模块
-- 
-- 功能：移除原控制，用马甲重新施放缩短时长的控制技能
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("lib.扩展函数.YDWE函数.index")
local YDWESetUnitAbilityDataReal = ____require_result_1.YDWESetUnitAbilityDataReal
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
--- 控制马甲技能ID
local CONTROL_ABILITY_ID = 1093678385
--- 获取辅助马甲单位类型
function ____exports.getControlHelperUnitType(self)
    return stringToFourCC("e02A")
end
--- 移除原控制技能
function ____exports.removeOriginalControl(self, unit, abilityId)
    jass.UnitRemoveAbility(unit, abilityId)
    jass.IssueImmediateOrder(unit, "stop")
end
--- 创建辅助马甲
function ____exports.createControlHelper(self, caster, target)
    local targetLoc = jass.GetUnitLoc(target)
    local helperType = ____exports.getControlHelperUnitType(nil)
    local x = jass.GetLocationX(targetLoc)
    local y = jass.GetLocationY(targetLoc)
    local helper = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        jass.GetOwningPlayer(caster),
        helperType,
        x,
        y,
        0
    )
    jass.RemoveLocation(targetLoc)
    return helper
end
--- 设置马甲控制技能持续时间
function ____exports.setHelperAbilityDuration(self, helper, duration)
    jass.UnitAddAbility(helper, CONTROL_ABILITY_ID)
    YDWESetUnitAbilityDataReal(
        nil,
        helper,
        CONTROL_ABILITY_ID,
        1,
        102,
        duration
    )
    YDWESetUnitAbilityDataReal(
        nil,
        helper,
        CONTROL_ABILITY_ID,
        1,
        103,
        duration
    )
end
--- 马甲施放控制技能
function ____exports.helperCastControl(self, helper, target)
    jass.IssueTargetOrder(helper, "thunderbolt", target)
end
--- 执行控制重施放
-- 
-- @param caster 原施法者
-- @param target 目标单位
-- @param abilityId 原技能ID
-- @param duration 控制时间
function ____exports.recastControlAbility(self, caster, target, abilityId, duration)
    ____exports.removeOriginalControl(nil, target, abilityId)
    local helper = ____exports.createControlHelper(nil, caster, target)
    ____exports.setHelperAbilityDuration(nil, helper, duration)
    ____exports.helperCastControl(nil, helper, target)
end
return ____exports
