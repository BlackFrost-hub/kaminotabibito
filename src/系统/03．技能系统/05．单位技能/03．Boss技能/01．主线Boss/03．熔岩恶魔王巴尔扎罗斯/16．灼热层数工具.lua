--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local getBuffRuntime = ____require_result_0.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local _____707C_70ED_6700_5927_5C42_6570 = 12
local _____707C_70ED_9ED8_8BA4_6301_7EED_79D2 = 30
local function _____9650_5236_707C_70ED_5C42_6570(value)
    if value < 0 then
        return 0
    end
    if value > _____707C_70ED_6700_5927_5C42_6570 then
        return _____707C_70ED_6700_5927_5C42_6570
    end
    return value
end
____exports["获取巴尔扎罗斯灼热层数"] = function(target)
    if target == nil or target == 0 then
        return 0
    end
    local runtime = getBuffRuntime(target, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["灼热"])
    local ____9650_5236_707C_70ED_5C42_6570_5 = _____9650_5236_707C_70ED_5C42_6570
    local ____opt_result_3
    if runtime ~= nil then
        ____opt_result_3 = runtime.stack
    end
    local ____opt_result_3_4 = ____opt_result_3
    if ____opt_result_3_4 == nil then
        ____opt_result_3_4 = 0
    end
    return ____9650_5236_707C_70ED_5C42_6570_5(____opt_result_3_4)
end
____exports["施加巴尔扎罗斯灼热"] = function(target, _____5C42_6570, _____6301_7EED_79D2)
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = _____707C_70ED_9ED8_8BA4_6301_7EED_79D2
    end
    if target == nil or target == 0 or _____5C42_6570 <= 0 then
        return
    end
    local nextStack = _____9650_5236_707C_70ED_5C42_6570(____exports["获取巴尔扎罗斯灼热层数"](target) + _____5C42_6570)
    registerManualBuff(
        target,
        _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["灼热"],
        _____6301_7EED_79D2,
        nextStack,
        {stack = nextStack, sourceName = "巴尔扎罗斯"}
    )
end
____exports["清除巴尔扎罗斯灼热"] = function(target)
    if target == nil or target == 0 then
        return false
    end
    return _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["灼热"])
end
____exports["减少巴尔扎罗斯灼热层数"] = function(target, _____5C42_6570)
    if target == nil or target == 0 or _____5C42_6570 <= 0 then
        return
    end
    local current = ____exports["获取巴尔扎罗斯灼热层数"](target)
    if current <= 0 then
        return
    end
    local nextStack = _____9650_5236_707C_70ED_5C42_6570(current - _____5C42_6570)
    if nextStack <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(target, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["灼热"])
        return
    end
    local runtime = getBuffRuntime(target, _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["灼热"])
    local ____registerManualBuff_12 = registerManualBuff
    local ____target_10 = target
    local ____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E_BuffID__707C_70ED_11 = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["灼热"]
    local ____opt_result_8
    if runtime ~= nil then
        ____opt_result_8 = runtime.remaining
    end
    local ____opt_result_8_9 = ____opt_result_8
    if ____opt_result_8_9 == nil then
        ____opt_result_8_9 = _____707C_70ED_9ED8_8BA4_6301_7EED_79D2
    end
    ____registerManualBuff_12(
        ____target_10,
        ____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E_BuffID__707C_70ED_11,
        ____opt_result_8_9,
        nextStack,
        {stack = nextStack, sourceName = "巴尔扎罗斯"}
    )
end
return ____exports
