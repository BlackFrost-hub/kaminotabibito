local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.01．装备属性应用")
local applyEquipStatsTS = ____require_result_1.applyEquipStatsTS
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.05．移动速度突破系统")
local SOS_SetUnitSpeed = ____require_result_2.SOS_SetUnitSpeed
local SOS_GetUnitSpeed = ____require_result_2.SOS_GetUnitSpeed
local SOS_UnSetUnitSpeed = ____require_result_2.SOS_UnSetUnitSpeed
local GetHandleId = jass.GetHandleId
local GetUnitName = jass.GetUnitName
local GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local GetUnitMoveSpeed = jass.GetUnitMoveSpeed
local _____9ED8_8BA4_79FB_901F_63D0_5347BuffID = "C033"
local _____5F15_64CE_79FB_901F_4E0A_9650 = 522
local _____79FB_901F_63D0_5347_8BB0_5F55_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    if type(_____5355_4F4D) == "number" then
        return _____5355_4F4D
    end
    return GetHandleId(_____5355_4F4D) or 0
end
local function _____53D6_5355_4F4D_952E(_____5355_4F4D, BuffID)
    local hid = _____53D6_5355_4F4D_53E5_67C4ID(_____5355_4F4D)
    if hid == 0 or BuffID == "" then
        return ""
    end
    return (tostring(hid) .. "|") .. BuffID
end
local function _____53D6_6709_6548BuffID(BuffID)
    return BuffID ~= nil and BuffID ~= "" and BuffID or _____9ED8_8BA4_79FB_901F_63D0_5347BuffID
end
local function _____53D6_6B63_6570(value)
    return value ~= nil and value > 0 and value or 0
end
local function _____5E94_7528_79FB_901F_5C5E_6027(_____5355_4F4D, _____79FB_901F)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____79FB_901F == 0 then
        return
    end
    applyEquipStatsTS(_____5355_4F4D, {{name = "叠加移动速度", value = _____79FB_901F}})
end
local function _____8BA1_7B97_79FB_901F_63D0_5347_503C(_____76EE_6807_5355_4F4D, _____53C2_6570)
    local _____56FA_5B9A_79FB_901F = _____53D6_6B63_6570(_____53C2_6570["固定移速"])
    local _____57FA_7840_767E_5206_6BD4 = _____53D6_6B63_6570(_____53C2_6570["基础移速百分比"])
    local _____5F53_524D_767E_5206_6BD4 = _____53D6_6B63_6570(_____53C2_6570["当前移速百分比"])
    local _____57FA_7840_79FB_901F = GetUnitDefaultMoveSpeed(_____76EE_6807_5355_4F4D) or 0
    local _____5F53_524D_79FB_901F = GetUnitMoveSpeed(_____76EE_6807_5355_4F4D) or 0
    return _____56FA_5B9A_79FB_901F + _____57FA_7840_79FB_901F * _____57FA_7840_767E_5206_6BD4 + _____5F53_524D_79FB_901F * _____5F53_524D_767E_5206_6BD4
end
local function ____on_79FB_901F_63D0_5347_79FB_9664(_____5355_4F4D, BuffID, _row)
    local key = _____53D6_5355_4F4D_952E(_____5355_4F4D, BuffID)
    if key == "" then
        return
    end
    local _____8BB0_5F55 = _____79FB_901F_63D0_5347_8BB0_5F55_8868[key]
    __TS__Delete(_____79FB_901F_63D0_5347_8BB0_5F55_8868, key)
    if _____8BB0_5F55 == nil then
        return
    end
    local ____temp_3
    if type(_____5355_4F4D) == "number" then
        ____temp_3 = _____8BB0_5F55["单位"]
    else
        ____temp_3 = _____5355_4F4D
    end
    local _____5B9E_9645_5355_4F4D = ____temp_3
    _____5E94_7528_79FB_901F_5C5E_6027(_____5B9E_9645_5355_4F4D, -_____8BB0_5F55["应用移速"])
    if _____8BB0_5F55["原突破移速"] > _____5F15_64CE_79FB_901F_4E0A_9650 then
        SOS_SetUnitSpeed(_____5B9E_9645_5355_4F4D, _____8BB0_5F55["原突破移速"])
    else
        SOS_UnSetUnitSpeed(_____5B9E_9645_5355_4F4D)
    end
end
____exports["施加移速提升Buff"] = function(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return false
    end
    if not (_____53C2_6570["持续时间"] > 0) then
        return false
    end
    local BuffID = _____53D6_6709_6548BuffID(_____53C2_6570.BuffID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____76EE_6807_5355_4F4D, BuffID)
    local _____63D0_5347_79FB_901F = _____8BA1_7B97_79FB_901F_63D0_5347_503C(_____76EE_6807_5355_4F4D, _____53C2_6570)
    if not (_____63D0_5347_79FB_901F > 0) then
        return false
    end
    local _____539F_7A81_7834_79FB_901F = SOS_GetUnitSpeed(_____76EE_6807_5355_4F4D) or 0
    local _____5F53_524D_5B9E_9645_79FB_901F = _____539F_7A81_7834_79FB_901F > _____5F15_64CE_79FB_901F_4E0A_9650 and _____539F_7A81_7834_79FB_901F or (GetUnitMoveSpeed(_____76EE_6807_5355_4F4D) or 0)
    local _____63D0_5347_540E_79FB_901F = _____5F53_524D_5B9E_9645_79FB_901F + _____63D0_5347_79FB_901F
    local key = _____53D6_5355_4F4D_952E(_____76EE_6807_5355_4F4D, BuffID)
    if key == "" then
        return false
    end
    _____5E94_7528_79FB_901F_5C5E_6027(_____76EE_6807_5355_4F4D, _____63D0_5347_79FB_901F)
    if _____63D0_5347_540E_79FB_901F > _____5F15_64CE_79FB_901F_4E0A_9650 then
        SOS_SetUnitSpeed(_____76EE_6807_5355_4F4D, _____63D0_5347_540E_79FB_901F)
    else
        SOS_UnSetUnitSpeed(_____76EE_6807_5355_4F4D)
    end
    _____79FB_901F_63D0_5347_8BB0_5F55_8868[key] = {
        ["单位"] = _____76EE_6807_5355_4F4D,
        BuffID = BuffID,
        ["应用移速"] = _____63D0_5347_79FB_901F,
        ["原突破移速"] = _____539F_7A81_7834_79FB_901F,
        ["应用突破移速"] = _____63D0_5347_540E_79FB_901F
    }
    registerManualBuff(
        _____76EE_6807_5355_4F4D,
        BuffID,
        _____53C2_6570["持续时间"],
        _____63D0_5347_79FB_901F,
        {
            sourceName = _____6765_6E90_5355_4F4D ~= nil and _____6765_6E90_5355_4F4D ~= 0 and GetUnitName(_____6765_6E90_5355_4F4D) or nil,
            iconOverride = _____53C2_6570["图标路径"],
            effectModelOverride = _____53C2_6570["特效路径"],
            onRemove = ____on_79FB_901F_63D0_5347_79FB_9664
        }
    )
    return true
end
____exports["清除单位移速提升Buff"] = function(_____5355_4F4D)
    return _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____5355_4F4D, _____9ED8_8BA4_79FB_901F_63D0_5347BuffID)
end
return ____exports
