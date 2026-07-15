--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.00．配置")
local _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["祖地双灵卫单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____83B7_53D6_5168_90E8_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部祖地双灵卫运行时上下文"]
local _____83B7_53D6_6216_521B_5EFA_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建祖地双灵卫运行时上下文"]
local ____03_FF0E_53CC_7075_540C_8A93 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.03．双灵同誓")
local _____6CE8_518C_7956_5730_53CC_7075_540C_8A93 = ____03_FF0E_53CC_7075_540C_8A93["注册祖地双灵同誓"]
local _____66F4_65B0_7956_5730_53CC_7075_540C_8A93 = ____03_FF0E_53CC_7075_540C_8A93["更新祖地双灵同誓"]
local ____04_FF0E_5B88_95E8_8F6E_5E8F = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.04．守门轮序")
local _____6CE8_518C_7956_5730_53CC_7075_536B_5B88_95E8_8F6E_5E8F = ____04_FF0E_5B88_95E8_8F6E_5E8F["注册祖地双灵卫守门轮序"]
local ____05_FF0E_4FB5_8680_62E9_5F62 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.05．侵蚀择形")
local _____7ED1_5B9A_7956_5730_53CC_7075_536B_4FB5_8680_751F_547D_4E0B_9650 = ____05_FF0E_4FB5_8680_62E9_5F62["绑定祖地双灵卫侵蚀生命下限"]
local _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5 = ____05_FF0E_4FB5_8680_62E9_5F62["更新祖地双灵卫侵蚀阶段"]
local ____07_FF0E_53CC_94A5_51C0_5316 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.07．双钥净化")
local _____66F4_65B0_7956_5730_53CC_7075_536B_53CC_94A5_51C0_5316 = ____07_FF0E_53CC_94A5_51C0_5316["更新祖地双灵卫双钥净化"]
local ____09_FF0E_540C_606F_5F52_5BC2 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.09．同息归寂")
local _____7ED1_5B9A_7956_5730_53CC_7075_536B_540C_606F_751F_547D_4E0B_9650 = ____09_FF0E_540C_606F_5F52_5BC2["绑定祖地双灵卫同息生命下限"]
local _____66F4_65B0_7956_5730_53CC_7075_536B_540C_606F_5F52_5BC2 = ____09_FF0E_540C_606F_5F52_5BC2["更新祖地双灵卫同息归寂"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器")
local _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668 = ____17_FF0E_5468_671F_673A_5236_8C03_5EA6_5668["创建周期机制调度器"]
local ____require_result_0 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
local _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C = ____require_result_0["注册Boss自动技能启动监听"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local getServerTime = ____require_result_1.getServerTime
local _____7956_5730_53CC_7075_536B_88AB_52A8_5DF2_6CE8_518C = false
local function _____5C1D_8BD5_7ED1_5B9A_53CC_7075_536B_4E0A_4E0B_6587(unit, remainingRetries)
    local context = _____83B7_53D6_6216_521B_5EFA_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587(unit)
    if context ~= nil then
        _____7ED1_5B9A_7956_5730_53CC_7075_536B_4FB5_8680_751F_547D_4E0B_9650(context)
        _____7ED1_5B9A_7956_5730_53CC_7075_536B_540C_606F_751F_547D_4E0B_9650(context)
        return
    end
    if remainingRetries <= 0 then
        return
    end
    addDelayedCallback(
        250,
        function()
            _____5C1D_8BD5_7ED1_5B9A_53CC_7075_536B_4E0A_4E0B_6587(unit, remainingRetries - 1)
        end
    )
end
local function ____on_7956_5730_53CC_7075_536BBoss_542F_52A8(context)
    _____5C1D_8BD5_7ED1_5B9A_53CC_7075_536B_4E0A_4E0B_6587(context["Boss单位"], 8)
end
local function _____63A8_8FDB_7956_5730_53CC_7075_536B_8FD0_884C_65F6(context, now)
    _____66F4_65B0_7956_5730_53CC_7075_540C_8A93(context, now)
    _____66F4_65B0_7956_5730_53CC_7075_536B_4FB5_8680_9636_6BB5(context, now)
    _____66F4_65B0_7956_5730_53CC_7075_536B_53CC_94A5_51C0_5316(context, now)
    _____66F4_65B0_7956_5730_53CC_7075_536B_540C_606F_5F52_5BC2(context, now)
end
local function _____6CE8_518C_53CC_7075_536B_5355_4F4D_76D1_542C(name, unitId)
    _____6CE8_518CBoss_81EA_52A8_6280_80FD_542F_52A8_76D1_542C({
        ["名称"] = name,
        ["单位类型ID"] = stringToFourCC(unitId),
        ["on启动"] = ____on_7956_5730_53CC_7075_536BBoss_542F_52A8
    })
end
____exports["注册祖地双灵卫被动效果"] = function()
    if _____7956_5730_53CC_7075_536B_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____7956_5730_53CC_7075_536B_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_7956_5730_53CC_7075_540C_8A93()
    _____6CE8_518C_7956_5730_53CC_7075_536B_5B88_95E8_8F6E_5E8F()
    local units = _____7956_5730_53CC_7075_536B_5355_4F4D_6280_80FD_914D_7F6E["单位"]
    _____6CE8_518C_53CC_7075_536B_5355_4F4D_76D1_542C("赤誓灵卫运行时上下文绑定", units["赤誓灵卫"]["单位ID"])
    _____6CE8_518C_53CC_7075_536B_5355_4F4D_76D1_542C("裂誓战躯运行时上下文绑定", units["赤誓灵卫"]["变异单位ID"])
    _____6CE8_518C_53CC_7075_536B_5355_4F4D_76D1_542C("苍影灵卫运行时上下文绑定", units["苍影灵卫"]["单位ID"])
    _____6CE8_518C_53CC_7075_536B_5355_4F4D_76D1_542C("无面祷影运行时上下文绑定", units["苍影灵卫"]["变异单位ID"])
    _____521B_5EFA_5468_671F_673A_5236_8C03_5EA6_5668({
        ["名称"] = "祖地双灵卫-联合运行时推进",
        ["间隔毫秒"] = 200,
        ["取当前时间"] = getServerTime,
        ["取上下文列表"] = _____83B7_53D6_5168_90E8_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587,
        ["执行"] = _____63A8_8FDB_7956_5730_53CC_7075_536B_8FD0_884C_65F6
    })
end
____exports["祖地双灵卫被动效果状态"] = {["已设计"] = true, ["已实现"] = true, ["已注册"] = true, ["包含机制"] = {
    "四单位Boss启动绑定",
    "双灵同誓",
    "侵蚀择形",
    "双钥净化",
    "同息归寂",
    "公共调度器"
}}
____exports["注册祖地双灵卫被动效果"]()
return ____exports
