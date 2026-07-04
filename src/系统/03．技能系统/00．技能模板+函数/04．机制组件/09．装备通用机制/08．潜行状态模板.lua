local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.15．隐身.隐身系统")
local _____65BD_52A0_9690_8EAB = ____require_result_0["施加隐身"]
local _____79FB_9664_9690_8EAB = ____require_result_0["移除隐身"]
local _____5355_4F4D_662F_5426_9690_8EAB_4E2D = ____require_result_0["单位是否隐身中"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____65BD_52A0_79FB_901F_63D0_5347Buff = ____require_result_1["施加移速提升Buff"]
local _____6E05_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["清除单位指定Buff"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local removeDelayedCallback = ____require_result_2.removeDelayedCallback
local GetHandleId = jass.GetHandleId
local _____9ED8_8BA4_6F5C_884C_79FB_901FBuffID = "C033"
local _____6F5C_884C_72B6_6001_8868 = {}
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____7ED3_675F_6F5C_884C_8BB0_5F55(record, _____539F_56E0)
    if record["已结束"] then
        return
    end
    record["已结束"] = true
    if record["到期回调ID"] ~= 0 then
        removeDelayedCallback(record["到期回调ID"])
    end
    __TS__Delete(_____6F5C_884C_72B6_6001_8868, record["单位ID"])
    _____79FB_9664_9690_8EAB(record["单位"])
    _____6E05_9664_5355_4F4D_6307_5B9ABuff(record["单位"], record["移速BuffID"])
    if record["参数"]["on结束"] ~= nil then
        record["参数"]["on结束"](record, _____539F_56E0)
    end
end
local function _____521B_5EFA_6F5C_884C_8BB0_5F55(_____53C2_6570, _____5355_4F4DID)
    local _____540D_79F0 = _____53C2_6570["名称"] or "潜行状态"
    local _____79FB_901FBuffID = _____53C2_6570["移速BuffID"] or _____9ED8_8BA4_6F5C_884C_79FB_901FBuffID
    local record
    record = {
        ["单位"] = _____53C2_6570["单位"],
        ["单位ID"] = _____5355_4F4DID,
        ["名称"] = _____540D_79F0,
        ["移速BuffID"] = _____79FB_901FBuffID,
        ["参数"] = _____53C2_6570,
        ["到期回调ID"] = 0,
        ["已结束"] = false,
        ["移除"] = function(_____539F_56E0)
            _____7ED3_675F_6F5C_884C_8BB0_5F55(record, _____539F_56E0 or "手动移除")
        end
    }
    return record
end
____exports["施加潜行状态"] = function(_____53C2_6570)
    if _____53C2_6570["单位"] == nil or _____53C2_6570["单位"] == 0 or not (_____53C2_6570["持续秒数"] > 0) then
        return nil
    end
    local unitId = _____53D6_5355_4F4DID(_____53C2_6570["单位"])
    if unitId == 0 then
        return nil
    end
    local old = _____6F5C_884C_72B6_6001_8868[unitId]
    if old ~= nil then
        _____7ED3_675F_6F5C_884C_8BB0_5F55(old, "刷新覆盖")
    end
    local ____65BD_52A0_9690_8EAB_8 = _____65BD_52A0_9690_8EAB
    local ____53C2_6570__5355_4F4D_7 = _____53C2_6570["单位"]
    local ____53C2_6570__6301_7EED_79D2_6570_4 = _____53C2_6570["持续秒数"]
    local ____temp_5 = _____53C2_6570["破隐固定额外伤害"] or 0
    local ____temp_6 = _____53C2_6570["破隐伤害倍率"] or 1
    local ____53C2_6570__6765_6E90_5355_4F4D_3 = _____53C2_6570["来源单位"]
    if ____53C2_6570__6765_6E90_5355_4F4D_3 == nil then
        ____53C2_6570__6765_6E90_5355_4F4D_3 = _____53C2_6570["单位"]
    end
    ____65BD_52A0_9690_8EAB_8(____53C2_6570__5355_4F4D_7, {["持续时间"] = ____53C2_6570__6301_7EED_79D2_6570_4, ["破隐固定额外伤害"] = ____temp_5, ["破隐伤害倍率"] = ____temp_6, ["来源单位"] = ____53C2_6570__6765_6E90_5355_4F4D_3})
    if (_____53C2_6570["固定移速"] or 0) > 0 or (_____53C2_6570["基础移速百分比"] or 0) > 0 or (_____53C2_6570["当前移速百分比"] or 0) > 0 then
        local ____65BD_52A0_79FB_901F_63D0_5347Buff_10 = _____65BD_52A0_79FB_901F_63D0_5347Buff
        local ____53C2_6570__6765_6E90_5355_4F4D_9 = _____53C2_6570["来源单位"]
        if ____53C2_6570__6765_6E90_5355_4F4D_9 == nil then
            ____53C2_6570__6765_6E90_5355_4F4D_9 = _____53C2_6570["单位"]
        end
        ____65BD_52A0_79FB_901F_63D0_5347Buff_10(____53C2_6570__6765_6E90_5355_4F4D_9, _____53C2_6570["单位"], {
            ["持续时间"] = _____53C2_6570["持续秒数"],
            ["固定移速"] = _____53C2_6570["固定移速"],
            ["基础移速百分比"] = _____53C2_6570["基础移速百分比"],
            ["当前移速百分比"] = _____53C2_6570["当前移速百分比"],
            BuffID = _____53C2_6570["移速BuffID"] or _____9ED8_8BA4_6F5C_884C_79FB_901FBuffID,
            sourceName = _____53C2_6570["名称"] or "潜行"
        })
    end
    local record = _____521B_5EFA_6F5C_884C_8BB0_5F55(_____53C2_6570, unitId)
    record["到期回调ID"] = addDelayedCallback(
        _____53C2_6570["持续秒数"] * 1000,
        function()
            if _____6F5C_884C_72B6_6001_8868[unitId] == record then
                _____7ED3_675F_6F5C_884C_8BB0_5F55(record, "到期")
            end
        end
    )
    _____6F5C_884C_72B6_6001_8868[unitId] = record
    if _____53C2_6570["on开始"] ~= nil then
        _____53C2_6570["on开始"](record)
    end
    return record
end
____exports["移除潜行状态"] = function(_____5355_4F4D, _____539F_56E0)
    local unitId = _____53D6_5355_4F4DID(_____5355_4F4D)
    if unitId == 0 then
        return false
    end
    local record = _____6F5C_884C_72B6_6001_8868[unitId]
    if record == nil then
        _____79FB_9664_9690_8EAB(_____5355_4F4D)
        return false
    end
    _____7ED3_675F_6F5C_884C_8BB0_5F55(record, _____539F_56E0 or "手动移除")
    return true
end
____exports["单位是否潜行中"] = function(_____5355_4F4D)
    local unitId = _____53D6_5355_4F4DID(_____5355_4F4D)
    if unitId == 0 then
        return false
    end
    return _____6F5C_884C_72B6_6001_8868[unitId] ~= nil or _____5355_4F4D_662F_5426_9690_8EAB_4E2D(_____5355_4F4D)
end
return ____exports
