local ____lualib = require("lualib_bundle")
local __TS__StringSplit = ____lualib.__TS__StringSplit
local __TS__StringTrim = ____lualib.__TS__StringTrim
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__ParseInt = ____lualib.__TS__ParseInt
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local UnitAddItemById = jass.UnitAddItemById
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
____exports["发放任务物品"] = function(unit, itemConfig)
    if unit == nil or unit == 0 or not itemConfig or itemConfig == "" then
        return 0
    end
    local _____53D1_653E_6570_91CF = 0
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
                        local _____7269_54C1 = UnitAddItemById(unit, _____7269_54C1_7C7B_578BID)
                        if _____7269_54C1 ~= nil and _____7269_54C1 ~= 0 then
                            _____53D1_653E_6570_91CF = _____53D1_653E_6570_91CF + 1
                        end
                        j = j + 1
                    end
                end
            end
            ::__continue5::
            i = i + 1
        end
    end
    return _____53D1_653E_6570_91CF
end
return ____exports
