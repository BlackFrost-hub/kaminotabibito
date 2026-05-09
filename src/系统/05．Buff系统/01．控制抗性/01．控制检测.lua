local ____lualib = require("lualib_bundle")
local __TS__ArraySome = ____lualib.__TS__ArraySome
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local ____exports = {}
--- 控制技能检测模块
-- 
-- 功能：判断技能是否为控制技能，单位是否被控制
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("lib.扩展函数.YDWE函数.index")
local getObjectProperty = ____require_result_1.getObjectProperty
local ObjectType = ____require_result_1.ObjectType
local ____require_result_2 = require("系统.05．Buff系统.01．控制抗性.00．控制抗性常量")
local EXCLUDED_UNIT_TYPES = ____require_result_2.EXCLUDED_UNIT_TYPES
--- 检查单位是否被排除
function ____exports.isExcludedFromControlResist(self, unit)
    local unitTypeId = jass.GetUnitTypeId(unit)
    return __TS__ArraySome(
        EXCLUDED_UNIT_TYPES,
        function(____, id) return stringToFourCC(nil, id) == unitTypeId end
    )
end
--- 检查技能命令是否为排除类型
local function isExcludedOrder(self, abilityId)
    local order = getObjectProperty(nil, ObjectType.ABILITY, abilityId, "Order")
    return order == "ward" or order == "web"
end
--- 获取技能英雄持续时间
function ____exports.getHeroDuration(self, abilityId)
    local str = getObjectProperty(nil, ObjectType.ABILITY, abilityId, "HeroDur1")
    return __TS__ParseFloat(str) or 0
end
--- 判断技能是否为控制技能
-- 
-- 条件：
-- 1. 不是排除的命令类型
-- 2. 英雄持续时间 > 0.02秒
function ____exports.isControlAbility(self, abilityId)
    if isExcludedOrder(nil, abilityId) then
        return false
    end
    local duration = ____exports.getHeroDuration(nil, abilityId)
    return duration > 0.02
end
--- 停止命令ID
local STOP_ORDER_ID = 852231
--- 麻痹命令ID
local PARALYSIS_ORDER_ID = 852252
--- 检查单位是否处于被控制状态
-- 
-- 条件：当前命令为stop或麻痹状态
function ____exports.isUnitControlled(self, unit)
    local currentOrder = jass.GetUnitCurrentOrder(unit)
    if currentOrder == STOP_ORDER_ID then
        return true
    end
    if currentOrder == PARALYSIS_ORDER_ID then
        return true
    end
    local issuedOrder = jass.GetIssuedOrderId()
    if jass.OrderId2String(issuedOrder) == "stop" then
        return true
    end
    return false
end
return ____exports
