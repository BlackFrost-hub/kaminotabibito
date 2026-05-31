--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_0.SGSS_SetState
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local getServerTime = ____require_result_1.getServerTime
local _____4E34_65F6_9644_52A0_653B_51FB_68C0_67E5_95F4_9694_6BEB_79D2 = 10
local _____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868 = {}
local _____4E34_65F6_9644_52A0_653B_51FB_6570_503C_5217_8868 = {}
local _____4E34_65F6_9644_52A0_653B_51FB_5230_671F_6BEB_79D2_5217_8868 = {}
local _____4E34_65F6_9644_52A0_653B_51FB_68C0_67E5_56DE_8C03ID = 0
local function _____7EDD_5BF9_503C(_____6570_503C)
    return _____6570_503C >= 0 and _____6570_503C or -_____6570_503C
end
local function _____8C03_6574_5355_4F4D_9644_52A0_653B_51FB(_____5355_4F4D, _____6570_503C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    if _____6570_503C == 0 then
        return
    end
    SGSS_SetState(_____5355_4F4D, 1, _____6570_503C)
end
local function _____505C_6B62_4E34_65F6_9644_52A0_653B_51FB_68C0_67E5()
    if _____4E34_65F6_9644_52A0_653B_51FB_68C0_67E5_56DE_8C03ID <= 0 then
        return
    end
    removePeriodicCallback(_____4E34_65F6_9644_52A0_653B_51FB_68C0_67E5_56DE_8C03ID)
    _____4E34_65F6_9644_52A0_653B_51FB_68C0_67E5_56DE_8C03ID = 0
end
local function ____on_4E34_65F6_9644_52A0_653B_51FB_68C0_67E5()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #_____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868 do
            if now >= _____4E34_65F6_9644_52A0_653B_51FB_5230_671F_6BEB_79D2_5217_8868[i + 1] then
                _____8C03_6574_5355_4F4D_9644_52A0_653B_51FB(
                    _____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868[i + 1],
                    -_____7EDD_5BF9_503C(_____4E34_65F6_9644_52A0_653B_51FB_6570_503C_5217_8868[i + 1])
                )
            else
                _____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868[writeIndex + 1] = _____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868[i + 1]
                _____4E34_65F6_9644_52A0_653B_51FB_6570_503C_5217_8868[writeIndex + 1] = _____4E34_65F6_9644_52A0_653B_51FB_6570_503C_5217_8868[i + 1]
                _____4E34_65F6_9644_52A0_653B_51FB_5230_671F_6BEB_79D2_5217_8868[writeIndex + 1] = _____4E34_65F6_9644_52A0_653B_51FB_5230_671F_6BEB_79D2_5217_8868[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #_____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868 - 1
        while i >= writeIndex do
            table.remove(_____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868)
            table.remove(_____4E34_65F6_9644_52A0_653B_51FB_6570_503C_5217_8868)
            table.remove(_____4E34_65F6_9644_52A0_653B_51FB_5230_671F_6BEB_79D2_5217_8868)
            i = i - 1
        end
    end
    if #_____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868 <= 0 then
        _____505C_6B62_4E34_65F6_9644_52A0_653B_51FB_68C0_67E5()
    end
end
local function _____786E_4FDD_4E34_65F6_9644_52A0_653B_51FB_68C0_67E5()
    if _____4E34_65F6_9644_52A0_653B_51FB_68C0_67E5_56DE_8C03ID > 0 then
        return
    end
    _____4E34_65F6_9644_52A0_653B_51FB_68C0_67E5_56DE_8C03ID = addPeriodicCallback(_____4E34_65F6_9644_52A0_653B_51FB_68C0_67E5_95F4_9694_6BEB_79D2, ____on_4E34_65F6_9644_52A0_653B_51FB_68C0_67E5)
end
____exports["施加临时附加攻击"] = function(_____5355_4F4D, _____6570_503C, _____6301_7EED_65F6_95F4)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    if _____6570_503C == 0 or not (_____6301_7EED_65F6_95F4 > 0) then
        return
    end
    _____8C03_6574_5355_4F4D_9644_52A0_653B_51FB(_____5355_4F4D, _____6570_503C)
    _____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868[#_____4E34_65F6_9644_52A0_653B_51FB_5355_4F4D_5217_8868 + 1] = _____5355_4F4D
    _____4E34_65F6_9644_52A0_653B_51FB_6570_503C_5217_8868[#_____4E34_65F6_9644_52A0_653B_51FB_6570_503C_5217_8868 + 1] = _____6570_503C
    _____4E34_65F6_9644_52A0_653B_51FB_5230_671F_6BEB_79D2_5217_8868[#_____4E34_65F6_9644_52A0_653B_51FB_5230_671F_6BEB_79D2_5217_8868 + 1] = getServerTime() + _____6301_7EED_65F6_95F4 * 1000
    _____786E_4FDD_4E34_65F6_9644_52A0_653B_51FB_68C0_67E5()
end
return ____exports
