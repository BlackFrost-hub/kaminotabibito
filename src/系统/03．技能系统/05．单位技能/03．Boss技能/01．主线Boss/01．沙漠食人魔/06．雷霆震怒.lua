--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB_673A_5236 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.00．食人魔公共.01．共享机制")
local _____65BD_653E_98DF_4EBA_9B54_96F7_9706_9707_6012 = ____01_FF0E_5171_4EAB_673A_5236["施放食人魔雷霆震怒"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.00．配置")
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["沙漠食人魔单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.02．数值与表现配置")
local _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["沙漠食人魔技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____96F7_9706_9707_6012_6280_80FDID = stringToFourCCSafe(_____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["雷霆震怒"])
local _____96F7_9706_9707_6012_5DF2_6CE8_518C = false
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____83B7_53D6_6C99_6F20_98DF_4EBA_9B54_6280_80FD_4E0A_4E0B_6587(boss)
    local _____5355_4F4D_5B58_6D3B_result_1
    if _____5355_4F4D_5B58_6D3B(boss) then
        _____5355_4F4D_5B58_6D3B_result_1 = boss
    else
        _____5355_4F4D_5B58_6D3B_result_1 = nil
    end
    return _____5355_4F4D_5B58_6D3B_result_1
end
____exports["释放沙漠食人魔雷霆震怒"] = function(boss)
    return _____65BD_653E_98DF_4EBA_9B54_96F7_9706_9707_6012(boss, _____6C99_6F20_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆震怒"])
end
local function ____on_96F7_9706_9707_6012_6280_80FD_58F3_91CA_653E(_context, boss)
    ____exports["释放沙漠食人魔雷霆震怒"](boss)
end
____exports["注册沙漠食人魔雷霆震怒"] = function()
    if _____96F7_9706_9707_6012_5DF2_6CE8_518C then
        return
    end
    _____96F7_9706_9707_6012_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "沙漠食人魔-雷霆震怒",
        ["单位类型ID"] = _____6C99_6F20_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____96F7_9706_9707_6012_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6C99_6F20_98DF_4EBA_9B54_6280_80FD_4E0A_4E0B_6587,
        ["释放技能"] = ____on_96F7_9706_9707_6012_6280_80FD_58F3_91CA_653E,
        ["技能实例持续时间秒"] = 6
    })
end
return ____exports
