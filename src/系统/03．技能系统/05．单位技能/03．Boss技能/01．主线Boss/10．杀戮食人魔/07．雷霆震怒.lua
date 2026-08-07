--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB_673A_5236 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.00．食人魔公共.01．共享机制")
local _____65BD_653E_98DF_4EBA_9B54_96F7_9706_9707_6012 = ____01_FF0E_5171_4EAB_673A_5236["施放食人魔雷霆震怒"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.00．配置")
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["杀戮食人魔单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建杀戮食人魔上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.02．数值与表现配置")
local _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["杀戮食人魔技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_1.debugLogForce
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____96F7_9706_9707_6012_6280_80FDID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["雷霆震怒"])
local _____96F7_9706_9707_6012_5DF2_6CE8_518C = false
local function _____53D6_53E5_67C4ID(handle)
    return handle ~= nil and handle ~= 0 and GetHandleId(handle) or 0
end
____exports["释放杀戮食人魔雷霆震怒"] = function(context)
    local _____662F_5426_5F00_59CB = _____65BD_653E_98DF_4EBA_9B54_96F7_9706_9707_6012(context["Boss单位"], _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["雷霆震怒"])
    debugLogForce(
        "杀戮食人魔-雷霆震怒",
        "释放请求",
        "bossHid=",
        _____53D6_53E5_67C4ID(context["Boss单位"]),
        "started=",
        _____662F_5426_5F00_59CB
    )
    return _____662F_5426_5F00_59CB
end
local function ____on_96F7_9706_9707_6012_6280_80FD_58F3_91CA_653E(context)
    local _____662F_5426_5F00_59CB = ____exports["释放杀戮食人魔雷霆震怒"](context)
    debugLogForce(
        "杀戮食人魔-雷霆震怒",
        "技能壳释放",
        "bossHid=",
        _____53D6_53E5_67C4ID(context["Boss单位"]),
        "started=",
        _____662F_5426_5F00_59CB
    )
end
____exports["注册杀戮食人魔雷霆震怒"] = function()
    if _____96F7_9706_9707_6012_5DF2_6CE8_518C then
        debugLogForce("杀戮食人魔-雷霆震怒", "重复注册请求已忽略")
        return
    end
    _____96F7_9706_9707_6012_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "杀戮食人魔-雷霆震怒",
        ["单位类型ID"] = _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____96F7_9706_9707_6012_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587,
        ["释放技能"] = ____on_96F7_9706_9707_6012_6280_80FD_58F3_91CA_653E,
        ["技能实例持续时间秒"] = 6
    })
    debugLogForce(
        "杀戮食人魔-雷霆震怒",
        "技能壳注册完成",
        "skillId=",
        _____96F7_9706_9707_6012_6280_80FDID,
        "unitTypeId=",
        _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID
    )
end
return ____exports
