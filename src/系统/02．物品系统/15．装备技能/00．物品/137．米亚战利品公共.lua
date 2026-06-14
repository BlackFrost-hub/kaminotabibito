local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01－FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_2.UnitHasItemOfTypeBJ
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_3.getServerTime
local addPeriodicCallback = ____require_result_3.addPeriodicCallback
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_4.SGSS_SetState
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____5F00_59CB_62A4_76FE = ____require_result_5["开始护盾"]
local _____62A4_76FE_7C7B_578B = ____require_result_5["护盾类型"]
local _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C = ____require_result_5["查询单位标签护盾值"]
local _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE = ____require_result_5["充能单位标签护盾"]
local GetHandleId = jass.GetHandleId
local _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID = 9
local _____7C73_4E9A_88C5_5907ID_7F13_5B58 = {}
local _____7C73_4E9A_88C5_5907_51B7_5374_8868 = {}
local _____7C73_4E9A_4E34_65F6_79FB_901F_79FB_9664_961F_5217 = {}
local _____7C73_4E9A_4E34_65F6_79FB_901FTick_5DF2_542F_52A8 = false
____exports["米亚战利品装备名"] = {
    ["腐化猫爪手套"] = "腐化猫爪手套",
    ["纯净水源吊坠"] = "纯净水源吊坠",
    ["灵猫步伐之靴"] = "灵猫步伐之靴",
    ["腐化核心法杖"] = "腐化核心法杖",
    ["米亚的项圈"] = "米亚的项圈"
}
____exports["取米亚装备物品ID"] = function(_____88C5_5907_540D)
    local cached = _____7C73_4E9A_88C5_5907ID_7F13_5B58[_____88C5_5907_540D]
    if cached ~= nil then
        return cached
    end
    local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
    local id = stringToFourCCSafe(rawId)
    _____7C73_4E9A_88C5_5907ID_7F13_5B58[_____88C5_5907_540D] = id
    return id
end
____exports["单位持有米亚战利品"] = function(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 then
        return false
    end
    local itemId = ____exports["取米亚装备物品ID"](_____88C5_5907_540D)
    if itemId == 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(unit, itemId) == true
end
____exports["取米亚装备冷却键"] = function(unit, tag)
    if unit == nil or unit == 0 then
        return ""
    end
    return (tag .. ":") .. tostring(GetHandleId(unit))
end
____exports["米亚装备冷却中"] = function(key)
    if key == "" then
        return true
    end
    return (_____7C73_4E9A_88C5_5907_51B7_5374_8868[key] or 0) > getServerTime()
end
____exports["设置米亚装备冷却"] = function(key, _____79D2_6570)
    if key == "" then
        return
    end
    _____7C73_4E9A_88C5_5907_51B7_5374_8868[key] = getServerTime() + _____79D2_6570 * 1000
end
local function _____5904_7406_7C73_4E9A_4E34_65F6_79FB_901F_79FB_9664()
    local now = getServerTime()
    do
        local i = #_____7C73_4E9A_4E34_65F6_79FB_901F_79FB_9664_961F_5217 - 1
        while i >= 0 do
            do
                local _____8BB0_5F55 = _____7C73_4E9A_4E34_65F6_79FB_901F_79FB_9664_961F_5217[i + 1]
                if _____8BB0_5F55 == nil or now < _____8BB0_5F55["到期时间"] then
                    goto __continue15
                end
                SGSS_SetState(_____8BB0_5F55["单位"], _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, -_____8BB0_5F55["移速比例"])
                __TS__ArraySplice(_____7C73_4E9A_4E34_65F6_79FB_901F_79FB_9664_961F_5217, i, 1)
            end
            ::__continue15::
            i = i - 1
        end
    end
end
local function _____786E_4FDD_7C73_4E9A_4E34_65F6_79FB_901FTick()
    if _____7C73_4E9A_4E34_65F6_79FB_901FTick_5DF2_542F_52A8 then
        return
    end
    _____7C73_4E9A_4E34_65F6_79FB_901FTick_5DF2_542F_52A8 = true
    addPeriodicCallback(100, _____5904_7406_7C73_4E9A_4E34_65F6_79FB_901F_79FB_9664)
end
____exports["施加米亚临时移速"] = function(unit, _____79FB_901F_6BD4_4F8B, _____6301_7EED_79D2_6570)
    if unit == nil or unit == 0 or _____79FB_901F_6BD4_4F8B == 0 or not (_____6301_7EED_79D2_6570 > 0) then
        return
    end
    SGSS_SetState(unit, _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, _____79FB_901F_6BD4_4F8B)
    _____7C73_4E9A_4E34_65F6_79FB_901F_79FB_9664_961F_5217[#_____7C73_4E9A_4E34_65F6_79FB_901F_79FB_9664_961F_5217 + 1] = {
        ["单位"] = unit,
        ["移速比例"] = _____79FB_901F_6BD4_4F8B,
        ["到期时间"] = getServerTime() + _____6301_7EED_79D2_6570 * 1000
    }
    _____786E_4FDD_7C73_4E9A_4E34_65F6_79FB_901FTick()
end
____exports["施加米亚项圈护盾"] = function(unit, _____62A4_76FE_503C, _____6301_7EED_79D2_6570)
    if unit == nil or unit == 0 or not (_____62A4_76FE_503C > 0) or not (_____6301_7EED_79D2_6570 > 0) then
        return
    end
    local tag = "装备:米亚的项圈"
    local params = {
        ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
        ["数值"] = _____62A4_76FE_503C,
        ["持续时间"] = _____6301_7EED_79D2_6570,
        ["来源单位"] = unit,
        ["标签"] = tag,
        ["显示护盾条"] = true,
        ["可驱散"] = false
    }
    local current = _____67E5_8BE2_5355_4F4D_6807_7B7E_62A4_76FE_503C(unit, tag)
    if current > 0 then
        _____5145_80FD_5355_4F4D_6807_7B7E_62A4_76FE(
            unit,
            tag,
            _____62A4_76FE_503C,
            _____62A4_76FE_503C,
            params
        )
        return
    end
    _____5F00_59CB_62A4_76FE(unit, params)
end
return ____exports
