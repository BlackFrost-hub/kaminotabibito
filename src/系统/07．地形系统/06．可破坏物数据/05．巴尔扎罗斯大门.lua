--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local ModifyGateBJ = ____require_result_1.ModifyGateBJ
local GetPlayersAll = ____require_result_1.GetPlayersAll
local ____require_result_2 = require("lib.扩展函数.BJ函数.05A．电影函数")
local TransmissionFromUnitWithNameBJ = ____require_result_2.TransmissionFromUnitWithNameBJ
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
local GetUnitTypeId = jass.GetUnitTypeId
local _____5DF4_5C14_624E_7F57_65AF_5927_95E8_5168_5C40_540D = "gg_dest_B00M_13602"
local _____6076_9B54_770B_5B88_8005_5355_4F4DID = stringToFourCCSafe("n03S")
local _____4F20_97F3_8BF4_8BDD_8005 = "(远处的声音)"
local _____4F20_97F3_6587_672C = "不错，你们几个小鬼的实力得到了我的认可，进来吧！"
local bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN
local bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET
local _____5927_95E8_5DF2_5F00_542F = false
local function _____5904_7406_6076_9B54_770B_5B88_8005_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    if _____5927_95E8_5DF2_5F00_542F then
        return
    end
    if _____6B7B_4EA1_5355_4F4D == nil or _____6B7B_4EA1_5355_4F4D == 0 then
        return
    end
    if GetUnitTypeId(_____6B7B_4EA1_5355_4F4D) ~= _____6076_9B54_770B_5B88_8005_5355_4F4DID then
        return
    end
    _____5927_95E8_5DF2_5F00_542F = true
    local _____5927_95E8 = jglobals[_____5DF4_5C14_624E_7F57_65AF_5927_95E8_5168_5C40_540D]
    if _____5927_95E8 ~= nil and _____5927_95E8 ~= 0 then
        ModifyGateBJ(bj_GATEOPERATION_OPEN, _____5927_95E8)
    end
    TransmissionFromUnitWithNameBJ(
        GetPlayersAll(),
        nil,
        _____4F20_97F3_8BF4_8BDD_8005,
        nil,
        _____4F20_97F3_6587_672C,
        bj_TIMETYPE_SET,
        10,
        false
    )
end
registerDeathListener(_____5904_7406_6076_9B54_770B_5B88_8005_6B7B_4EA1)
return ____exports
