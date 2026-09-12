local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseInt = ____lualib.__TS__ParseInt
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.物品相关函数.创建物品函数")
local _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C = ____require_result_0["创建物品并注册排泄监听"]
local _____7ED9_4E88_5355_4F4D_7269_54C1 = ____require_result_0["给予单位物品"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_2["广播单位提示"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
____exports["发放任务物品"] = function(unit, itemConfig)
    if unit == nil or unit == 0 or not itemConfig or itemConfig == "" then
        return 0
    end
    local _____53D1_653E_6570_91CF = 0
    local _____6709_6389_843D = false
    local _____914D_7F6E_5217_8868 = __TS__StringSplit(itemConfig, "|")
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            do
                local _____914D_7F6E = __TS__StringTrim(_____914D_7F6E_5217_8868[i + 1])
                if _____914D_7F6E == "" then
                    goto __continue5
                end
                local _____6570_91CF_5206_9694_4F4D_7F6E = (string.find(_____914D_7F6E, "*", nil, true) or 0) - 1
                local _____7269_54C1_4EE3_7801 = __TS__StringTrim(_____6570_91CF_5206_9694_4F4D_7F6E >= 0 and __TS__StringSubstring(_____914D_7F6E, 0, _____6570_91CF_5206_9694_4F4D_7F6E) or _____914D_7F6E)
                local _____6570_91CF = _____6570_91CF_5206_9694_4F4D_7F6E >= 0 and (__TS__ParseInt(
                    __TS__StringSubstring(_____914D_7F6E, _____6570_91CF_5206_9694_4F4D_7F6E + 1),
                    10
                ) or 0) or 1
                if _____6570_91CF < 1 then
                    _____6570_91CF = 1
                end
                local _____7269_54C1_7C7B_578BID = stringToFourCCSafe(_____7269_54C1_4EE3_7801)
                if _____7269_54C1_7C7B_578BID == 0 then
                    goto __continue5
                end
                do
                    local j = 0
                    while j < _____6570_91CF do
                        do
                            local item = _____521B_5EFA_7269_54C1_5E76_6CE8_518C_6392_6CC4_76D1_542C(
                                _____7269_54C1_7C7B_578BID,
                                GetUnitX(unit),
                                GetUnitY(unit)
                            )
                            if item == nil or item == 0 then
                                goto __continue10
                            end
                            if _____7ED9_4E88_5355_4F4D_7269_54C1(unit, item) then
                                _____53D1_653E_6570_91CF = _____53D1_653E_6570_91CF + 1
                            else
                                _____53D1_653E_6570_91CF = _____53D1_653E_6570_91CF + 1
                                _____6709_6389_843D = true
                            end
                        end
                        ::__continue10::
                        j = j + 1
                    end
                end
            end
            ::__continue5::
            i = i + 1
        end
    end
    if _____6709_6389_843D then
        _____5E7F_64AD_5355_4F4D_63D0_793A(unit, "物品栏已满，部分奖励物品掉落在脚下，请注意拾取。", 4000)
    end
    return _____53D1_653E_6570_91CF
end
return ____exports
