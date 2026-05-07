local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local ____exports = {}
--- 特殊单位消耗处理
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_0.YDUserDataGet
local ____require_result_1 = require("系统.03．技能系统.02．技能消耗.00．消耗常量")
local EDWARD_UNIT_CONFIG_KEY = ____require_result_1.EDWARD_UNIT_CONFIG_KEY
local SPECIAL_UNIT_COST_CONFIG = ____require_result_1.SPECIAL_UNIT_COST_CONFIG
local function _____63D0_53D6_663E_793A_540D(self, _____914D_7F6E_952E_540D)
    local _____7247_6BB5_5217_8868 = __TS__StringSplit(_____914D_7F6E_952E_540D, "|")
    return _____7247_6BB5_5217_8868[1] or _____914D_7F6E_952E_540D
end
--- 获取爱德华单位。
-- 当前仍沿用前半段显示名作为缓存键，避免你尚未填写真实内部 ID 时改坏行为。
function ____exports.getEdwardUnit(self)
    return YDUserDataGet(
        nil,
        "string",
        _____63D0_53D6_663E_793A_540D(nil, EDWARD_UNIT_CONFIG_KEY),
        "单位",
        "unit"
    )
end
--- 检查单位是否为爱德华。
function ____exports.isEdwardUnit(self, unit)
    local edward = ____exports.getEdwardUnit(nil)
    return edward ~= nil and unit == edward
end
--- 爱德华被动处理：扣血代替扣蓝。
function ____exports.handleEdwardPassiveCost(self, unit, manaCost)
    if not ____exports.isEdwardUnit(nil, unit) then
        return
    end
    local currentLife = jass:GetUnitState(unit, jass.UNIT_STATE_LIFE)
    local lifeKeep = currentLife - 1
    local deductAmount = manaCost < lifeKeep and manaCost or lifeKeep
    if deductAmount > 0 then
        jass:SetUnitState(unit, jass.UNIT_STATE_LIFE, currentLife - deductAmount)
    end
end
return ____exports
