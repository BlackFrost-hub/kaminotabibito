--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 特殊单位消耗处理
-- 
-- 配置哪些单位有特殊的消耗处理方式
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
--- 特殊单位消耗处理配置表
-- 
-- key: 单位类型ID
-- value: 处理配置
____exports.SPECIAL_UNIT_COST_CONFIG = {}
--- 获取爱德华单位
function ____exports.getEdwardUnit(self)
    return YDUserDataGet(
        nil,
        "string",
        "爱德华",
        "单位",
        "unit"
    )
end
--- 检查单位是否为爱德华
function ____exports.isEdwardUnit(self, unit)
    local edward = ____exports.getEdwardUnit(nil)
    return edward ~= nil and unit == edward
end
--- 爱德华被动处理：扣血代替扣蓝
function ____exports.handleEdwardPassiveCost(self, unit, manaCost)
    if not ____exports.isEdwardUnit(nil, unit) then
        return
    end
    local currentLife = jass.GetUnitState(unit, jass.UNIT_STATE_LIFE)
    local deductAmount = math.min(manaCost, currentLife - 1)
    if deductAmount > 0 then
        jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, currentLife - deductAmount)
    end
end
return ____exports
