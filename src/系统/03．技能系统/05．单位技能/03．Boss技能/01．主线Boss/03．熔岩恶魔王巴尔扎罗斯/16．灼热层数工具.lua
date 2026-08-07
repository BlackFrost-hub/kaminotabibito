--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
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
____exports["施加巴尔扎罗斯灼热"] = function(context, target, _____5C42_6570, _____6301_7EED_79D2)
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = _____707C_70ED_9ED8_8BA4_6301_7EED_79D2
    end
    local ____temp_7 = context == nil
    if not ____temp_7 then
        local ____self_6 = context["清理"]
        ____temp_7 = ____self_6["已清理"](____self_6)
    end
    if ____temp_7 or not _____5355_4F4D_6709_6548(context["Boss单位"]) then
        return
    end
    if not _____5355_4F4D_6709_6548(target) or _____5C42_6570 <= 0 then
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
    local ____registerManualBuff_14 = registerManualBuff
    local ____target_12 = target
    local ____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E_BuffID__707C_70ED_13 = _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E.BuffID["灼热"]
    local ____opt_result_10
    if runtime ~= nil then
        ____opt_result_10 = runtime.remaining
    end
    local ____opt_result_10_11 = ____opt_result_10
    if ____opt_result_10_11 == nil then
        ____opt_result_10_11 = _____707C_70ED_9ED8_8BA4_6301_7EED_79D2
    end
    ____registerManualBuff_14(
        ____target_12,
        ____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E_BuffID__707C_70ED_13,
        ____opt_result_10_11,
        nextStack,
        {stack = nextStack, sourceName = "巴尔扎罗斯"}
    )
end
return ____exports
